import enspire.model.structure.ChapterData;
dynamic class enspire.model.structure.SectionData {
	public var chapter:ChapterData;
	public var aClip:Array;
	private var bComplete:Boolean
	function SectionData() {
		this.aClip = new Array();
		this.bComplete = false;
		
	}
	function addClip(oClipData) {
		oClipData.chapter = this.chapter;
		oClipData.section = this;
		this.aClip.push(oClipData);
	}
	function getComplete() {
		// check it if only we are not complete
		if(this.bComplete) {
			return true;
		}
		// determine complete
		for(var i:Number = 0; i < this.aClip.length; i++) {
			if(!this.aClip[i].getComplete()) {
				return false;
			}
		}
		this.bComplete = true;
		return this.bComplete;
	}
	function setComplete() {
		this.bComplete = true;
	}
	function getClipCount() {
		return this.aClip.length;
	}
	function getClips() {
		return this.aClip;
	}
	function toString() {
		var s = "SectionData\n";
		for(var arg in this) {
			if((arg != "aClip") && (arg != "chapter") && (typeof(this[arg]) != "function")) {
				s += "\t"+arg+": "+this[arg]+"\n";
			}
		}
		return s;
	}
}