import enspire.model.structure.SegmentData;
class enspire.model.structure.BranchData{
	public var aSegment:Array;
	private var nBranchNumber:Number
	private var bComplete:Boolean
	function BranchData(nBranch:Number) {
		this.bComplete = false;
		this.aSegment = new Array();
		this.nBranchNumber = nBranch;
	}
	function addToBranch(seg:SegmentData) {
		seg.nBranchOrder = this.aSegment.length;
		seg.nPageNumber = this.aSegment.length + 1;
		seg.branch = this;
		this.aSegment.push(seg);
		
	}
	function getBranchId() {
		return this.nBranchNumber;
	}
	function getBranchLength() {
		return this.aSegment.length;
	}
	function get length() {
		return this.aSegment.length;
	}
	function getComplete() {
		if(this.bComplete) {
			return true;
		}
		var bAllComplete = true;
		
		for(var i:Number = 0; i < this.aSegment.length; i++) {
			////trace("Checking Branch Segment "+this.aSegment[i].id+": "+this.aSegment[i].getComplete());
			if(!this.aSegment[i].getComplete()) {
				bAllComplete = false;
				break;
			}
		}
		if(bAllComplete) {
			this.bComplete = true;
		}
		
		//trace("this.bComplete: "+this.bComplete);
		return this.bComplete;
	}
	function toString() {
		var s = "Branch("+this.aSegment.length+"): ";
		for(var i:Number = 0; i < this.aSegment.length; i++) {
			s += this.aSegment[i].id;
			if(i != this.aSegment.length) {
				s += ", "
			}
		}
		return s;
	}
}