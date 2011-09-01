import mx.utils.Delegate;
import enspire.model.structure.StructureData;
import enspire.model.structure.SegmentData;

import StructureDisplay;

class StructureTester{
	var mcClip:MovieClip;
	var structure :StructureData;
	var struct:XML
	var nCurrectLoc:Number
	var oCurrectSeg:SegmentData;
	var sDisplay:StructureDisplay;
	function StructureTester(mcClip:MovieClip) {
		this.mcClip = mcClip;
		this.structure = new StructureData();
		struct = new XML();
		struct.ignoreWhite = true;
		struct.onLoad = Delegate.create(this, doParse);
		struct.load("full-struct.xml");
		
		
		
		this.mcClip.mcRefresh.setText("Refresh");
		this.mcClip.mcBack.setText("Back");
		this.mcClip.mcNext.setText("Next");
		
		this.mcClip.mcRefresh.onRelease = Delegate.create(this, showStructure);
		this.mcClip.mcBack.onRelease = Delegate.create(this, goBackSeg);
		this.mcClip.mcNext.onRelease = Delegate.create(this, goNextSeg);
		
		
		this.sDisplay = new StructureDisplay(this.mcClip.mcDisplay);
	}
	function goNextSeg() {
		if(oCurrectSeg.bInBranch) {
			var segHead = this.structure.getBranchHead(oCurrectSeg);
			if(segHead.getBranchEndId(oCurrectSeg.nBranchNumber) == oCurrectSeg.id) {
				
				
				// if we have completed the branch by either none one or all branches being explored get the next seg from the continue to seg from the args

				if(segHead.getComplete()) {
					var sAfterSeg = oCurrectSeg.chapter.id+"_"+oCurrectSeg.section.id+"_"+oCurrectSeg.clip.id + "_"+segHead.args.sAfterBranchSeg;
					
					trace("sAfterSeg: "+sAfterSeg);
					
					var sAfterBranchSeg = structure.getSegmentById(sAfterSeg);
					if(sAfterBranchSeg != undefined) {
						this.setCurrectLocation(sAfterBranchSeg.nAbsoluteIndex);
						return;
					}
				}
				
				this.setCurrectLocation(segHead.nAbsoluteIndex);
				return;
			}			 
		}
		
		
		
		this.setCurrectLocation(nCurrectLoc+1);
	}
	function goBackSeg() {
		// go back to the head if we are at the start of a branch
		if(oCurrectSeg.bInBranch) {
			var segHead = this.structure.getBranchHead(oCurrectSeg);
			if(oCurrectSeg.nBranchOrder == 0) {
				
				this.setCurrectLocation(segHead.nAbsoluteIndex);
				return;
			}			 
		}
		
		// if were trying to back up into a branch make sure we back clear out of the branch
		var nBack = nCurrectLoc-1
		if(this.structure.aSegments[nBack].bInBranch) {
			for(var i:Number = nBack; i >= 0; i--) {
				if(this.structure.aSegments[i].bInBranch == false) {
					nBack = i;
					break;
				}
			}
		}
		this.setCurrectLocation(nBack);
	}
	function setCurrectLocation(loc) {
		clearBranchButtons()
		if(loc == undefined) {
			loc = 0;
		}
		nCurrectLoc = loc;
		oCurrectSeg = structure.aSegments[nCurrectLoc];
		
		
		
		// set complete as long as its not a branch head
		if(!oCurrectSeg.bBranchHead) {
			oCurrectSeg.setComplete();
		}
		//trace("GO LOCATION: "+nCurrectLoc);
		
		this.sDisplay.setSelected(nCurrectLoc);
		
		var s = oCurrectSeg.chapter.id+" "+oCurrectSeg.section.id+" "+oCurrectSeg.clip.id+" "+oCurrectSeg.id+", "+oCurrectSeg.nPageNumber+" of ";
		if(oCurrectSeg.bInBranch) {
			var segHead = this.structure.getBranchHead(oCurrectSeg);
			s += segHead.getBranchLength(oCurrectSeg.nBranchNumber);
			s += ", branch "+oCurrectSeg.nBranchNumber;
			s += ", required "+segHead.args.sBranchCompletion;
		}else{
			s += oCurrectSeg.clip.getSegCount();
		}
		
		this.mcClip.tfLoc.text = s;
		
		this.mcClip.tf2.text =  oCurrectSeg.sLink+ "\n\n"+ oCurrectSeg.chapter + "\n"+oCurrectSeg.section + "\n"+ oCurrectSeg.clip + "\n"+ oCurrectSeg;
		this.mcClip.tf2.scroll = 0;
		this.mcClip.sb2.reinit();
		
		// disable back button
		if(oCurrectSeg.nAbsoluteIndex == 0) {
			this.mcClip.mcBack.enabled = false;
			this.mcClip.mcBack._alpha = 50;
		}else{
			this.mcClip.mcBack.enabled = true;
			this.mcClip.mcBack._alpha = 100;
		}
		
		if((oCurrectSeg.nAbsoluteIndex == (this.structure.getTotalSegCount() - 1)) || (oCurrectSeg.bBranchHead)) {
			this.mcClip.mcNext.enabled = false;
			this.mcClip.mcNext._alpha = 50;
		}else{
			this.mcClip.mcNext.enabled = true;
			this.mcClip.mcNext._alpha = 100;
		}
		
		if(oCurrectSeg.bBranchHead) {
			for(var i:Number = 0; i < oCurrectSeg.getBranchCount(); i++) {
				var sId = oCurrectSeg.getBranchStartId(i);
				var sSearchId = oCurrectSeg.chapter.id+"_"+oCurrectSeg.section.id+"_"+oCurrectSeg.clip.id+"_"+sId;
				//trace("LOOKING FOR: "+sSearchId);
				
				var nPos = this.structure.segLookup.getValueForKey(sSearchId);
				var mc = this.mcClip.mcBranches.attachMovie("button", "mcBranch"+i, i);
				mc._x = i * 50;
				mc.ref = this;
				mc.nPos = nPos;
				mc.setText(i);
				mc.tf.autoSize = true;
				mc.tf.text = i;
				mc.mcBg._width = mc.tf._width + (mc.tf._x * 2);
				mc.onPress = function() {
					//trace("CALLING BRANCH: "+this.nPos);
					
					this.ref.setCurrectLocation(this.nPos);
				}
			}
		}
		
		
	}
	function clearBranchButtons() {
		for(var elm in this.mcClip.mcBranches) {
			if(this.mcClip.mcBranches[elm] instanceof MovieClip) {
				this.mcClip.mcBranches[elm].removeMovieClip();
			}
		}
	}
	function doParse() {
		structure.parseStructure(struct);
		showStructure()
		
		
		this.sDisplay.init(structure);
		
		setCurrectLocation()
		//trace("CHAPTER LOOKUP:\n"+this.structure.chapterLookup.stringify(": ", "\n"));
		//trace("SECTION LOOKUP:\n"+this.structure.sectionLookup.stringify(": ", "\n"));
		//trace("CLIP LOOKUP:\n"+this.structure.clipLookup.stringify(": ", "\n"));
		//trace("SEGMENT LOOKUP:\n"+this.structure.segLookup.stringify(": ", "\n"));
		
	}
	
	function showStructure() {
		this.mcClip.tf1.text = structure.toString();
		this.mcClip.tf1.scroll = 0;
		this.mcClip.sb1.reinit();
	}
}