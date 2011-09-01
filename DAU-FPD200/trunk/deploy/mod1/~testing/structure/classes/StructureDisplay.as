import enspire.model.structure.StructureData;
class  StructureDisplay{
	var mcClip:MovieClip;
	var nSelected:Number;
	var structure:StructureData;
	var aButtons:Array;
	function StructureDisplay(mcClip:MovieClip) {
		this.mcClip = mcClip;
		this.aButtons = new Array();
	}
	function init(structure:StructureData) {
		this.structure = structure;
		this.draw()
	}
	function setSelected(n:Number) {
		if(this.nSelected != undefined) {
			this.aButtons[this.nSelected].gotoAndStop("defualt")
		}
		this.nSelected = n;
		this.aButtons[this.nSelected].gotoAndStop("selected");

		for(var i:Number = 0; i < this.structure.aSegments.length; i++) {
			if(i != n) {
				if(this.structure.aSegments[i].getComplete()) {
					this.aButtons[i].gotoAndStop("complete");
				}else{
					this.aButtons[i].gotoAndStop("defualt");
				}
			}
		}
		
	}
	function draw() {
		var nX = 0;
		for(var i:Number = 0; i < this.structure.aChapters.length; i++) {
			for(var j:Number = 0; j < this.structure.aChapters[i].aSection.length; j++) {
				for(var k:Number = 0; k < this.structure.aChapters[i].aSection[j].aClip.length; k++) {
					for(var sg:Number = 0; sg < this.structure.aChapters[i].aSection[j].aClip[k].aSegment.length; sg++) {
						
						var offset = addSegToStage(this.structure.aChapters[i].aSection[j].aClip[k].aSegment[sg], nX, 0);
						nX += offset.width;
					}
				}
			}
		}
	}
	function addSegToStage(segData, nX:Number, nY:Number) {
		var nLongestBranch = 0;
		var padding = 10;
		var nX;
		var nWidth;
		var nHeight;
		
		var sName = "mc"+ segData.sLink;
		var mc = this.mcClip.mcHolder.attachMovie("seg", sName, this.mcClip.mcHolder.getNextHighestDepth());
		mc._x = nX;
		mc._y = nY;
		mc.sLink = segData.sLink;
		
		this.aButtons[segData.nAbsoluteIndex] = mc;
		
		nWidth = mc._width + padding;
		nHeight = nY;
		
		//trace("ADDING "+mc+"\nx: "+nX+", nY: "+nY+"\n");
		mc.controller = this;
		mc.segData = segData;
		mc.onRollOver = function() {
			var sText = "Seg: "+this.segData.id+"\nCompleted: "+this.segData.getComplete();
			sText += "\nBranchhead: "+this.segData.bBranchHead+"\nIn Branch: "+this.segData.bInBranch;
			this.controller.showText(sText);
			this.useHandCursor = false;
		}
		mc.onRollOut = function() {
			this.controller.clearText();
		}
		
		
		
		if(segData.bBranchHead) {
			var currentBranch = 0;
			var nLongestTotal = nWidth;
			var nXStart = nX + nWidth;
			for(var i:Number = 0; i < segData.aBranches.length; i++) {
				var branch = segData.aBranches[i];
				nX = nXStart;
				for(var j:Number = 0; j < branch.aSegment.length; j++) {
					if(currentBranch != branch.getBranchId()) {
						currentBranch = branch.getBranchId();
						nY += mc._height + padding;
					}
					var offset = addSegToStage(branch.aSegment[j], nX, nY);
					trace("offset.fullwidth "+offset.fullwidth);
					if(offset.fullwidth > nLongestTotal) {
						nLongestTotal = offset.fullwidth;
					}

					nX += offset.width;
					if((nX - nXStart) > nLongestBranch) {
						nLongestBranch = (nX - nXStart);
					}
				}
			}
			if(nLongestTotal > 0) {
				nLongestBranch += nLongestTotal;
			}
			nWidth =  nLongestBranch;
			
			//trace("LONGEST TOTAL"+nLongestTotal);
			nHeight = nY;
		}
		return {width:nWidth, height:nHeight, fullwidth:nLongestBranch};
	}
	function showText(sText:String) {
		this.mcClip.tf.text = sText;
		
	}
	function clearText() {
		this.mcClip.tf.text = "";
	}
}