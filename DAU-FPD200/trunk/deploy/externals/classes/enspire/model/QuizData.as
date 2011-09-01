import org.asapframework.util.ArrayUtils;
//
import enspire.model.QuizDataItem;
import enspire.model.Configs;
//
class enspire.model.QuizData{
	public var nQuestions:Number
	private var nId:Number;
	private var profile:Object;
	private var aBank:Array;
	private var bComplete:Boolean;
	public var sTitle:String;
	private var nScore:Number;
	function QuizData(nId:Number) {
		this.nId = nId
		this.bComplete = false;
		this.aBank = new Array();
		this.profile = Configs.getProfile("Quiz"+this.nId);
		
	}
	function addItem(n:Number) {
		if(isNaN(n)) {
			return;
		}
		this.aBank[n] = new QuizDataItem(n);
	}
	function getItem(n:Number) {
		return this.aBank[n];
	}
	function getTotalQuestions() {
		return this.aBank.length;
	}
	function get id() {
		return this.nId;
	}
	function getScore() {
		if(!this.bComplete) {
			return;
		}
		if(this.nScore == undefined) {			
			var nPoints:Number = 0;
			var nTotalPoints:Number = 0;
			for(var i:Number = 0; i < this.aBank.length; i++) {
				nTotalPoints += this.aBank[i].nPointValue;
				if(this.aBank[i].getCorrect()) {
					nPoints += this.aBank[i].nPointValue;
				}
			}
		}
		this.nScore = Math.round((nPoints/nTotalPoints)*100);
		return this.nScore
	}
	function isCompleted() {
		if(this.bComplete) {
			return true;
		}
		for(var i:Number = 0; i < this.aBank.length; i++) {
			if(this.aBank[i].getComplete() != true) {
				return false
			}
		}
		this.bComplete = true;
		return true;
		
	}
	function getLastCompleted() {
		for(var i:Number = 0; i < this.aBank.length; i++) {
			if(this.aBank[i].getComplete() != true) {
				return (i - 1);
			}
		}
	}
	function randomize() {
		ArrayUtils.randomize(this.aBank);
	}
	function getNext() {
		
	}
	function getPrev() {
		
	}
	function getData() {
		
	}
	function restoreData(sData:String) {
		
	}
	function saveData() {
		
	}
	function toString() {
		var s = "Quiz "+this.nId + " - " + this.sTitle + " \n\tCompleted: " + this.bComplete;
		if(this.bComplete) {
			s +"\n\tScore: "+this.getScore();
		}
		for(var i:Number = 0; i < this.aBank.length; i++) {
			s += "\n\t\t"+this.aBank[i].toString();
		}
		s += "\n\n";
		return s;
	}
}