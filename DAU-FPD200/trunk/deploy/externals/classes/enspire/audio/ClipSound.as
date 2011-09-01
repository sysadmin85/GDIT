import enspire.core.Server;
import enspire.audio.BaseSound;
class enspire.audio.ClipSound extends BaseSound{
	
	function ClipSound(sId:String, mc:MovieClip) {
		super(sId, mc);
	}
	function setUrl(sUrl:String) : Void {
		Server.loader.addToQueue(sUrl , this.mcSound, sId);
	}
	function stop() : Void {
		//trace("stop called");
		this.mcSound.stop();
		super.stop();
	}
	function play() : Void {
		//trace("Play "+this);
		this.mcSound.gotoAndPlay(1);
		super.play();
	}
	function pause() : Void {
		this.mcSound.stop();
		super.pause();
	}
	function resume() : Void {
		this.mcSound.play();
		super.resume();
	}
	function toString() {
		return "Clip Sound\nclip:"+this.mcSound._name+"\nid: "+this.sId;
	}
}