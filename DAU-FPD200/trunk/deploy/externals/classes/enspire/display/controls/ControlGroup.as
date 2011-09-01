import enspire.display.controls.BaseControl;
class enspire.display.controls.ControlGroup{
	private var aControls:Array;
	private var sName:String;
	
	function ControlGroup(sName:String) {
		this.aControls = new Array();
		this.sName = sName;
	}
	function addControl(c:BaseControl) {
		this.aControls.push(c);
	}
	function setEnabled(b:Boolean) {
		for(var i:Number = 0; i < this.aControls.length; i++) {
			this.aControls.setEnabled(b);
		}
	}
	
	
}