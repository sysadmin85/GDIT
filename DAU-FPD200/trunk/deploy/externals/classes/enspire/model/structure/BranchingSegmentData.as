import enspire.model.structure.SegmentData;
import enspire.model.structure.BranchData;

dynamic class enspire.model.structure.BranchingSegmentData extends SegmentData{
	public var aBranches:Array;
	private var bAllComplete:Boolean
	
	function BranchingSegmentData() {
		super();
		this.aBranches = new Array();
	}
	function addToBranch(nBranch:Number , seg:SegmentData) {
		
		if(this.aBranches[nBranch] == undefined) {
			this.aBranches[nBranch] = new BranchData(nBranch);
		}
		seg.bAllComplete = false;
		seg.head = this;
		seg.nBranchNumber = nBranch
		this.aBranches[nBranch].addToBranch(seg);
	}
	function getBranchCount() {
		return this.aBranches.length
	}
	function getBranchLength(nBranch:Number) {
		return this.aBranches[nBranch].getBranchLength();
	}
	function getBranchComplete(nBranch:Number) {
		return this.aBranches[nBranch].getComplete();
	}
	function getBranchEndId(nBranch:Number) {
		var n = this.aBranches[nBranch].getBranchLength() - 1;
		return this.aBranches[nBranch].aSegment[n].id;
	}
	function getBranchStartId(nBranch) {
		////trace("getBranchStartId(nBranch): " + this.aBranches[nBranch].aSegment[0].id);
		return this.aBranches[nBranch].aSegment[0].nAbsoluteIndex;
	}
	function getComplete() {
		if((this.args.sBranchCompletion == "none") || (this.bAllComplete)) {
			return true;
		}
		// if they have not hit the head they cannot be complete
		if(!this.bComplete) {
			return false;
		}
		if(this.args.sBranchCompletion == "one") {
			this.bComplete = false;
			for(var i:Number = 0; i < this.aBranches.length; i++) {
				if(this.aBranches[i].getComplete()) {
					this.bAllComplete = true;
					return this.bAllComplete;
				}
			}
			
		}else{
			for(var i:Number = 0; i < this.aBranches.length; i++) {
				if(!this.aBranches[i].getComplete()) {
					return false;
				}
			}
		}
		this.bAllComplete = true;
		return this.bAllComplete;
	}
}