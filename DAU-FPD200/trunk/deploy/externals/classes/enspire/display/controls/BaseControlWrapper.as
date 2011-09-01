import org.asapframework.util.debug.Log;
//
class enspire.display.controls.BaseControlWrapper{
	private var mcClip:MovieClip;
	private var sType:String;
	private var sName:String;
	function BaseControlWrapper(mcClip:MovieClip) {
		this.mcClip = mcClip;
		this.mcClip.onOldRelease = this.mcClip.onRelease;
		this.mcClip.control = this;
		this.mcClip.onRelease = function() {
			this.control.onControlClick();
			this.onOldRelease();
		}
		this.sName = this.mcClip._name.substr(2).toLowerCase();
	}
	public function onControlClick() {
		//trace("Control Clicked "+this.sName);
	}
	public function __resolve(methodName:String) {
		if(this.mcClip[methodName]) {
			
			return this.mcClip[methodName].apply(null, arguments);
		}else{
			//Log.warn(methodName+" method does not exist", this.toString());
		}
	}
	public function getName() {
		return this.sName;
	}
	public function getClip() {
		return this.mcClip;
	}
	function getType() {
		return this.sType;
	}
}