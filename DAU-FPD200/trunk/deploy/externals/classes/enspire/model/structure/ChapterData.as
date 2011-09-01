import enspire.model.structure.SectionData;

dynamic class enspire.model.structure.ChapterData{
	public var id:String;
	public var title:String;
	public var aSection:Array;
	private var bComplete:Boolean
	function ChapterData() {
		this.aSection = new Array();
		this.bComplete = false;
	}
	function addSection(oSectData:SectionData) {
		oSectData.chapter = this;
		this.aSection.push(oSectData);
	}
	function getComplete() {
		// check it if only we are not complete
		if(this.bComplete) {
			return true;
		}
		// determine complete
		for(var i:Number = 0; i < this.aSection.length; i++) {
			if(!this.aSection[i].getComplete()) {
				return false;
			}
		}
		this.bComplete = true;
		return this.bComplete;
	}
	function getSectionCount() {
		return this.aSection.length;
	}
	function toString() {
		var s = "ChapterData\n";
		for(var arg in this) {
			if((arg != "aSection") && (typeof(this[arg]) != "function")) {
				s += "\t"+arg+": "+this[arg]+"\n";
			}
		}
		return s;
	}
}