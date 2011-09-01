import enspire.audio.BaseSound;

class enspire.audio.FxSound extends BaseSound{
	function FxSound(sId:String, mc:MovieClip) {
		super(sId, mc);
	}
	
	function stop() : Void {
		//trace("stop called");
		this.oSound.stop()
		super.stop();
	}
	function play() : Void {
		//trace("Play "+this);
		this.oSound.start()
		super.play();
	}
	function pause() : Void {
		this.oSound.stop();
		super.pause();
	}
	function resume() : Void {
		this.oSound.start();
		super.resume();
	}
	function toString() {
		return "Fx Sound\n\tid: "+this.sId;
	}
}