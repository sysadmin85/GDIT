import enspire.model.QuizData;
class enspire.model.QuizDataItem{
	var bComplete:Boolean
	var sSaveData:String;
	var quiz:QuizData;
	var bCorrect:Boolean;
	var nId:Number;
	var nPointValue:Number;
	
	function QuizDataItem(nId:Number, qd:QuizData) {
		this.nId = nId;
		this.bComplete = false;
		this.bCorrect = false;
		this.quiz = qd;
		this.nPointValue = 1;
	}
	function setComplete() {
		this.bComplete = true;
	}
	function getComplete() {
		return this.bComplete;
	}
	function setCorrect(b:Boolean) {
		this.bComplete = true;
		this.bCorrect = b;
	}
	function getCorrect() {
		return this.bCorrect;
	}
	function encode() {
		
		return this.bCorrect ? 1 : 0;
	}
	function decode(sData:String) {
		if(sData == "1") {
			this.bCorrect = true;
		}
	}
	function toString() {
		return "QuizData "+this.nId+" completed: "+this.bComplete+" bCorrect: "+this.bCorrect;
	}
}