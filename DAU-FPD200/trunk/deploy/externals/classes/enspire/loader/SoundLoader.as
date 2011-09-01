import mx.utils.Delegate;
import mx.events.EventDispatcher;
import org.asapframework.util.debug.Log;
import org.asapframework.util.framepulse.FramePulse;
import org.asapframework.util.framepulse.FramePulseEvent;
//
import enspire.loader.ILoader;
import enspire.loader.LoadData;
import enspire.loader.LoaderEvent;
class enspire.loader.SoundLoader implements ILoader{
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var lData:LoadData;
	private var snd:Sound;
	
	function SoundLoader() {
		EventDispatcher.initialize(this);
	}
	public function load(lData:LoadData) {
		this.lData = lData;
		this.snd = Sound(this.lData.location);
		this.snd.onLoad = Delegate.create(this, onSoundLoaded);
		
		var fpulse:FramePulse = FramePulse.getInstance();
		fpulse.addEventListener(FramePulseEvent.ON_ENTERFRAME, this.snd)
		
		this.snd.loadSound(this.lData.url, false);
	}
	private function onEnterFrame() {
		////trace("SOUND PROGRESS");
		this.lData.bytesLoaded = this.snd.getBytesLoaded();
		this.lData.bytesTotal = this.snd.getBytesTotal();
		//trace("\tP: "+this.lData.bytesLoaded + " - "+this.lData.bytesTotal );
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOAD_PROGRESS, this.lData, this))
	}
	private function onSoundLoaded(bSucsess:Boolean) {
		kill()
		dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOADED, this.lData, this));
		Sound(this.lData.location).start();
	}
	public function  kill() {
		var fpulse:FramePulse = FramePulse.getInstance();
		fpulse.removeEventListener(FramePulseEvent.ON_ENTERFRAME, this);
	}
	public function getLoadData() {
		return this.lData
	}
}