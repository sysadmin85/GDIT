import mx.utils.Delegate;
import mx.events.EventDispatcher;
import org.asapframework.util.debug.Log;
import org.asapframework.util.framepulse.FramePulse;
import org.asapframework.util.framepulse.FramePulseEvent;
//
import enspire.loader.ILoader;
import enspire.loader.LoadData;
import enspire.loader.LoaderEvent;

class enspire.loader.XmlLoader implements ILoader{
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var lData:LoadData;
	private var xml:XML;
	
	function XmlLoader() {
		EventDispatcher.initialize(this);
	}
	public function load(lData:LoadData) {
		this.lData = lData;
		this.xml = XML(this.lData.location);
		this.xml.ignoreWhite = true;
		this.xml.onLoad = Delegate.create(this, onXmlLoaded);
		
		var fpulse:FramePulse = FramePulse.getInstance();
		fpulse.addEventListener(FramePulseEvent.ON_ENTERFRAME, this)
		
		this.xml.load(this.lData.url);
	}
	private function onEnterFrame() {
		this.lData.bytesLoaded = this.xml.getBytesLoaded();
		this.lData.bytesTotal = this.xml.getBytesTotal();
		////trace("\tP: "+this.lData.bytesLoaded + " - "+this.lData.bytesTotal );
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOAD_PROGRESS, this.lData, this))
	}
	private function onXmlLoaded(bSucsess:Boolean) {
		this.kill();
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOADED, this.lData, this));
	}
	public function  kill() {
		var fpulse:FramePulse = FramePulse.getInstance();
		fpulse.removeEventListener(FramePulseEvent.ON_ENTERFRAME, this);
	}
	public function getLoadData() {
		return this.lData
	}
}
