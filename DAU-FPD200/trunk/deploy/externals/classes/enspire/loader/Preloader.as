// this is a multi-treaded universal loader
// two queues one for background loads and one for active loads
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import org.asapframework.util.debug.Log;
//
import org.asapframework.util.ArrayUtils;
//
import enspire.loader.LoadData;
import enspire.loader.PreloaderEvent;
import enspire.loader.LoaderEvent;
import enspire.loader.SoundLoader;
import enspire.loader.SwfLoader;
import enspire.loader.XmlLoader;
import enspire.loader.ILoader;

class enspire.loader.Preloader{
	private static var MAX_LOADERS:Number = 3;
	private static var STATE_NONE:Number = 0;
	private static var STATE_LOADING:Number = 1;
	private static var STATE_LOADING_BG:Number = 2;
	private static var STATE_PAUSED:Number = 3;
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var nMaxLoaders:Number;
	private var aQueue:Array;
	private var aBackground:Array;
	private var aCurrent:Array;
	private var aLoaders:Array;
	private var sLoadingState:Number;
	private var bBackgroundPaused:Boolean;
	private var nCurrentTotal:Number;
	
	function Preloader(nMax:Number) {
		EventDispatcher.initialize(this);
		this.nMaxLoaders = (nMax == undefined) ? MAX_LOADERS : nMax;
		this.aQueue = new Array();
		this.aBackground = new Array();
		this.aLoaders = new Array();
		this.sLoadingState = STATE_NONE;
		this.bBackgroundPaused = false;
		this.nCurrentTotal;
	}
	// add a load data to either the main queue of the background queue
	function addToQueue(sUrl:String, oLoc:Object, sName:String, bBackground:Boolean, fCallback:Function, oCallbackScope:Object) {
		var oLoad = new LoadData(sUrl, oLoc, sName, fCallback, oCallbackScope);
		//Log.status("addToQueue - "+oLoad, this.toString());
		if(bBackground == true) {
			this.aBackground.push(oLoad);
		}else{
			// pull it out of the background array if we are adding it to the active queue
			ArrayUtils.removeElement(this.aBackground, oLoad);
			this.aQueue.push(oLoad);
		}
	}
	function runQueue() {
		////trace("Run Queue"+ this.aQueue.length);
		//Log.status("Run Preload Queue - "+ this.aQueue.length+" to load", this.toString());
		if(this.aQueue.length == 0) {
			// need to frame delay and send all done so if nothings been added to the queue then we still send the all clear
			return;
		}
		this.nCurrentTotal = this.aQueue.length;
		// if we are currently running the background load then pause it
		if(this.sLoadingState == STATE_LOADING_BG) {
			pauseBackgroundLoad();
		}
		
		this.sLoadingState = STATE_LOADING;
		this.dispatchEvent(new PreloaderEvent(PreloaderEvent.ON_LOAD_START, undefined));
		////trace("Setting this.sLoadingState to "+STATE_LOADING);
		// go ahead and start as meay con current loads as we can
		this.aCurrent = this.aQueue;
		for(var i:Number = 0; i < this.nMaxLoaders; i++) {
			this.getNextInQueue();
		}
		
	}
	function getQueueLength() {
		return this.aQueue.length;
	}
	function runBackgroundQueue() {
		this.sLoadingState = STATE_LOADING_BG;
		this.getNextInQueue();
	}
	function stopLoadAndClear() {
		if(this.sLoadingState == STATE_LOADING) {
			for(var i:Number; i < this.aLoaders.length; i++) {
				this.aLoaders[i].stopLoad();
				this.aBackground.push(this.aLoaders[i].getLoadData());
				aLoaders[i].removeEventListener(LoaderEvent.ON_LOADED, this);
				aLoaders[i].removeEventListener(LoaderEvent.ON_LOAD_ERROR, this);
				delete this.aLoaders[i];
			}
			this.aLoaders = [];
		}
	}
	private function pauseBackgroundLoad() {
		if(this.sLoadingState != STATE_LOADING_BG) {
			return;
		}
		this.bBackgroundPaused = true;
		// get the loaders data back into the queue, kill and loader processes and empty the loaders array
		for(var i:Number; i < this.aLoaders.length; i++) {
			this.aLoaders[i].stopLoad();
			this.aBackground.push(this.aLoaders[i].getLoadData());
			aLoaders[i].removeEventListener(LoaderEvent.ON_LOADED, this);
			aLoaders[i].removeEventListener(LoaderEvent.ON_LOAD_ERROR, this);
			delete this.aLoaders[i];
		}
		this.aLoaders = [];
	}
	
	private function resumeBackgroundLoad() {
		this.bBackgroundPaused = false;
		if(this.aBackground.length == 0) {
			return;
		}
		runBackgroundQueue();
	}
	
	function getNextInQueue() {
		if(this.aCurrent.length == 0) {
			return;
		}
		
		// get a data object, create a loader and start load
		var lData:LoadData = LoadData(this.aCurrent.shift());
		var loader = this.getLoader(lData.getType());
		this.addLoader(loader);
		loader.load(lData);		
	}
	private function getLoader(sFileType) : ILoader {
		switch(sFileType) {
			case "jpg":
			case "jpeg":
			case "png":
			case "gif":
			case "swf":
				return new SwfLoader();
				break;
			case "txt":
			case "xml":
				return new XmlLoader();
				break;
			case "mp3":
				return new SoundLoader();
				break;
			default:
				//Log.error("Unknown file type: "+sFileType);
		}
	}
	function onLoaded(e:LoaderEvent) {
		////trace("LOAD COMPLETE");
		this.removeLoader(e.loader);
		this.dispatchEvent(new PreloaderEvent(PreloaderEvent.ON_LOADED, e.data));
		// if we are all done loading do some clean up
		
		//do call back if there is one
		e.data.doCallback();
		
		////trace(this.aCurrent.length+" left in queue");
		////trace(this.aLoaders.length+" still loading");
		if((this.aCurrent.length == 0) && (this.aLoaders.length == 0)) {
			this.handleAllLoaded();
		}else{
			this.getNextInQueue();
		}
	}
	private function addLoader(loader:Object) {
		loader.addEventListener(LoaderEvent.ON_LOADED, this);
		loader.addEventListener(LoaderEvent.ON_LOAD_ERROR, this);
		if(this.sLoadingState == STATE_LOADING) {
			loader.addEventListener(LoaderEvent.ON_LOAD_PROGRESS, this);
		}
		this.aLoaders.push(loader);
	}
	private function removeLoader(loader:Object) {
		loader.removeEventListener(LoaderEvent.ON_LOADED, this);
		loader.removeEventListener(LoaderEvent.ON_LOAD_ERROR, this);
		if(this.sLoadingState == STATE_LOADING) {
			loader.addEventListener(LoaderEvent.ON_LOAD_PROGRESS, this);
		}
		loader.kill();
		ArrayUtils.removeElement(this.aLoaders, loader);
	}
	private function handleAllLoaded() {

		////trace("handleAllLoaded() does "+this.sLoadingState+" = "+STATE_LOADING);

		////trace("handleAllLoaded()");

		if(this.sLoadingState == STATE_LOADING) {
			// send all loaded event
			this.sLoadingState = STATE_NONE;
			
			// restart the background load one
			if(this.bBackgroundPaused) {
				this.resumeBackgroundLoad();
				return;
			}			
			dispatchEvent(new PreloaderEvent(PreloaderEvent.ON_ALL_LOADED, undefined, 100));
		}else{
			this.nCurrentTotal = 0;
			this.sLoadingState = STATE_NONE;
		}
		
		
	}
	function onLoadError(e:LoaderEvent) {
		////trace("LOAD ERROR");
		
		this.removeLoader(e.loader);
		this.dispatchEvent(new PreloaderEvent(PreloaderEvent.ON_LOADED, e.data));
		// if we are all done loading do some clean up
		if((this.aCurrent.length == 0) && (this.aLoaders.length == 0)) {
			this.handleAllLoaded();
		}else{
			this.getNextInQueue();
		}
	}
	function onLoadProgress(e:LoaderEvent) {
		var nProgress = this.getLoadProgress();
		////trace(nProgress);
		this.dispatchEvent(new PreloaderEvent(PreloaderEvent.ON_LOAD_PROGRESS, e.data, nProgress));
	}
	private function getLoadProgress() {
		// first get the 
		////trace("this.nCurrentTotal " + this.nCurrentTotal);
		var nPart = 100/this.nCurrentTotal;
		var nProgress = (this.nCurrentTotal - (this.aLoaders.length + this.aCurrent.length)) * nPart;
		for(var i:Number = 0; i < this.aLoaders.length; i++) {
			var lData = this.aLoaders[i].getLoadData();
			var nLoaderProgress = nPart  * (lData.bytesLoaded / lData.bytesTotal );
			////trace("nLoaderProgress: "+nLoaderProgress);
			if(!isNaN(nLoaderProgress)) {
				nProgress += nLoaderProgress;
			}
			
		}
		////trace("getLoadProgress: "+nProgress);
		return nProgress;
		
		
	}
	public function toString() {
		return "enspire.loader.Preloader";
	}
	
}