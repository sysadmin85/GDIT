class enspire.debug.ConsoleCheckBox extends MovieClip {
	private var tfLabel:TextField;
	private var bChecked:Boolean;
	private var mcIcon:MovieClip;
	function ConsoleCheckBox() {
	}
	function setLabel(s:String) {
		this.tfLabel.text = s;
	}
	function init(sLabel:String, bSelect:Boolean) {
		this.setLabel(sLabel);
		if (bSelect == undefined) {
			bSelect = false;
		}
		if (bSelect) {
			this.select();
		}
		this.onPress = function() {
			if (this.bChecked) {
				this.deselect();
			} else {
				this.select();
			}
		};
	}
	function select() {
		this.bChecked = true;
		this.mcIcon.gotoAndStop("selected");
	}
	function deselect() {
		this.bChecked = false;
		this.mcIcon.gotoAndStop("deselected");
	}
	function isSelected() {
		return this.bChecked;
	}
}