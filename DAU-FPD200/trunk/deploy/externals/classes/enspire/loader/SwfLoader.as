import mx.utils.Delegate;
import mx.events.EventDispatcher;
import org.asapframework.util.debug.Log;
//
import enspire.loader.ILoader;
import enspire.loader.LoadData;
import enspire.loader.LoaderEvent;
class enspire.loader.SwfLoader implements ILoader{
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var lData:LoadData;
	private var mLoader:MovieClipLoader;
	
	function SwfLoader() {
		////trace("New SwfLoader created");
		EventDispatcher.initialize(this);
		
		mLoader = new MovieClipLoader();
		mLoader.addListener(this);
	}
	public function load(lData:LoadData) {
		this.lData = lData;
		////Log.status("Load: "+lData, this.toString());
		mLoader.loadClip(lData.url, lData.location);
	}
	public function getLoadData() {
		return this.lData;
	}
	public function onLoadStart() {
		////trace("START LOAD: "+this.lData.location+" "+lData.name);
	}
	public function onLoadProgress ( mc:MovieClip, nLoaded:Number, nTotal:Number ) : Void {
		this.lData.bytesLoaded = nLoaded;
		this.lData.bytesTotal = nTotal;
		////trace(this.lData)
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOAD_PROGRESS, this.lData, this));
	}
	public function onLoadComplete(mc:MovieClip) {
		
	}
	public function onLoadInit ( mc:MovieClip ) : Void {
		kill();
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOADED, this.lData, this));
	}
	public function onLoadError ( mc:MovieClip, errorCode:String, httpStatus:Number ) : Void {
		////trace("DISPATCH LOAD ERROR");
		// debug message
		//Log.error("onLoadError - '" + httpStatus + "' error while loading file: " + this.lData.url, toString());
		
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOAD_ERROR, this.lData, this));
	}
	public function kill() {
		mLoader.removeListener(this);
	}
	public function toString() {
		return "enspire.loader.SwfLoader";
	}
}