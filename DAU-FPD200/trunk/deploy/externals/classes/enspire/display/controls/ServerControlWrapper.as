import enspire.display.controls.BaseControlWrapper;
import enspire.core.Server;
class enspire.display.controls.ServerControlWrapper extends BaseControlWrapper{
	function ServerControlWrapper(mcClip:MovieClip) {
		super(mcClip);
	}
	public function onControlClick() {
		//trace("Control Clicked "+this.sName);
		Server.run(this.sName);
	}
}