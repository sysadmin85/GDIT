//
import mx.utils.Delegate;
//
import enspire.audio.SoundManager;
class enspire.audio.BaseSound{
	private static var STATE_PLAY:String = "playing";
	private static var STATE_PAUSE:String = "paused";
	private static var STATE_STOP:String = "stopped";
	private var oSound:Sound;
	private var mcSound:MovieClip;
	private var sPlayState:String;
	private var nStoredVol:Number;
	private var nStoredPos:Number;
	private var sId:String;
	private var nVol:Number;
	function BaseSound(sId:String, mc:MovieClip) {
		this.mcSound = mc;
		this.oSound = new Sound(this.mcSound);
		this.oSound.onSoundComplete = Delegate.create(this, isDone); 
		this.sId = sId;
		this.sPlayState = "stopped";
	}
	function getId() {
		return this.sId;
	}
	private function isDone() {
		this.sPlayState = STATE_STOP;
	}
	function setUrl(sUrl:String) : Void {
		if(isExternal(sUrl)) {
			//trace("LOAD SOUNS FX: "+sUrl);
			this.oSound.loadSound(sUrl);
		}else{
			this.oSound.attachSound(sUrl);
		}
	}
	function stop() : Void {
		this.sPlayState = STATE_STOP;
	}
	function play(nLoops:Number) : Void {
		this.sPlayState = STATE_PLAY;
	}
	function pause() : Void {
		this.sPlayState = STATE_PAUSE;
	}
	function resume() : Void {
		this.sPlayState = STATE_PLAY;
	}
	function remove() : Void {
		delete this.oSound;
		this.mcSound.removeMovieClip();
	}
	function mute() : Void{
		this.oSound.setVolume(0);
	}
	function isPlaying() : Boolean {
		return this.sPlayState == STATE_PLAY;
	}
	function isPaused() : Boolean {
		return this.sPlayState == STATE_PAUSE
	}
	function isStopped() : Boolean {
		return this.sPlayState == STATE_STOP;
	}
	function unmute() {
		this.oSound.setVolume(this.nVol);
	}
	function setVolume(nVolume:Number) : Void {
		this.nVol = nVolume;
	}
	function getVolume() : Number {
		return nVol;
	}
	private function isExternal(sLinkage:String) {
		return (sLinkage.indexOf(".mp3") != -1) && (sLinkage.indexOf(".swf"));
	}
	
}