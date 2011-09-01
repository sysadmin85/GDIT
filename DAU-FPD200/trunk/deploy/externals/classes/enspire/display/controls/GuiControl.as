import enspire.display.controls.BaseControl;
import enspire.model.Labels;
class enspire.display.controls.GuiControl extends BaseControl{
	function GuiControl() {
		super();

	}

	public function setText(sTxt:String) {
		this.mcText.tf.autoSize = true;
		this.mcText.tf.text = sTxt;
	}

	public function formatButton() {
		var nPadding:Number = 6;
		var nIconW :Number= this.mcIcon._width;
		var nStartW:Number = this._width;
		var nTotalW:Number = this.mcText._width;
		//
		var tx:Number = ((nStartW/2)-(nTotalW/2))+(nIconW/2);
		var ix:Number = tx-nIconW-nPadding;
		//
		this.mcText._x = tx;
		this.mcIcon._x = ix;
	}
	function toString() {
		return "enspire.display.controls.GuiControl";
	}
}