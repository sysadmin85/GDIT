import enspire.model.structure.ChapterData;
import enspire.model.structure.SectionData;
import enspire.model.structure.SegmentData;

dynamic class enspire.model.structure.ClipData{
	public var chapter:ChapterData;
	public var section:SectionData;
	public var aSegment:Array;
	private var bComplete:Boolean
	private var aAllSegments:Array;
	function ClipData() {
		this.aSegment = new Array();
		this.aAllSegments = new Array();
		this.bComplete = false;
	}
	function addSegment(seg:SegmentData) {
		seg.chapter = this.chapter;
		seg.section = this.section;
		seg.clip = this;
		
		
		// dont store this here if it in a branch
		if((!seg.bInBranch) && (seg.bCount != false)) {
			seg.nPageNumber = this.aSegment.length + 1;
			this.aSegment.push(seg);
		}
		this.aAllSegments.push(seg)
	}
	function getComplete() {
		// check it if only we are not complete
		if(this.bComplete) {
			return true;
		}
		// determine complete
		for(var i:Number = 0; i < this.aSegment.length; i++) {
			if((!this.aSegment[i].getComplete()) && (!this.aSegment[i].bNoComplete)) {
				return false;
			}
		}
		this.bComplete = true;
		return this.bComplete;
	}
	function getAllSegs() {
		return this.aAllSegments;
	}
	function setComplete() {
		this.bComplete = true;
	}
	function getSegCount() {
		return this.aSegment.length;
	}
	function getStartSegIndex() {
		return this.aSegment[0].nAbsoluteIndex;
	}
	function toString() {
		var s = "ClipData\n";
		for(var arg in this) {
			if((arg != "aSegment") && (arg != "aAllSegments") && (arg != "chapter") && (arg != "section") && (typeof(this[arg]) != "function")) {
				s += "\t"+arg+": "+this[arg]+"\n";
			}
		}
		return s;
	}
}