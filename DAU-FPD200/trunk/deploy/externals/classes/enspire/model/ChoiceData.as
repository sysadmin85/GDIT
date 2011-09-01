class enspire.model.ChoiceData{
	public var sText:String;
	private var bSelected:Boolean;
	private var nIndex:Number;
	private var bCorrect:Boolean;
	public function ChoiceData(sText:String, bCorrect:Boolean, nIndex:Number) {
		this.sText = sText;
		this.bCorrect = bCorrect;
		this.nIndex = nIndex;
	}
	public function setSelected(b:Boolean) {
		this.bSelected = b;
	}
	public function getIndex() {
		return this.nIndex;
	}
	public function getSelected() {
		return this.bSelected;
	}
	public function isCorrect() {
		return this.bCorrect;
	}
	public function toString() {
		return "ChoiceData("+this.nIndex+") "+this.bCorrect+"\n\ttext:"+this.sText;
	}
}