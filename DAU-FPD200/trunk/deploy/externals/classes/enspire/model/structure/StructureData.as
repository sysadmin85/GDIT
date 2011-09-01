// xpath
import com.xfactorstudio.xml.xpath.XPath;
//
import org.asapframework.data.KeyValueList;

import enspire.model.structure.ChapterData;
import enspire.model.structure.SectionData;
import enspire.model.structure.ClipData;
import enspire.model.structure.SegmentData;
import enspire.model.structure.BranchingSegmentData;
import enspire.model.ModelCollector;
import enspire.model.QuizModelCollector;
import enspire.model.ClipSplashCollector;
import enspire.model.ILELocation;

class enspire.model.structure.StructureData{
	private var aCollectors:Array;
	public var aChapters:Array;
	public var aSections:Array;
	public var aClips:Array;
	public var aSegments:Array;
	public var chapterLookup:KeyValueList;
	public var sectionLookup:KeyValueList;
	public var clipLookup:KeyValueList;
	public var segLookup:KeyValueList;
	
	function StructureData() {
		this.aChapters = new Array();
		this.aSections = new Array();
		this.aClips = new Array();
		this.aSegments = new Array();
		this.segLookup = new KeyValueList();
		this.chapterLookup = new KeyValueList();
		this.sectionLookup = new KeyValueList();
		this.clipLookup = new KeyValueList();
		
		this.aCollectors = new Array();
		//this.addCollector(new QuizModelCollector());
		this.addCollector(new ClipSplashCollector());
		
	}
	function parseStructure(xml:XML) {
		var nChapIndex:Number = 0;
		var nSectIndex:Number = 0;
		var nClipIndex:Number = 0;
		var nAbsoluteIndex:Number = 0;
		
		
		
		var chapNode = XPath.selectSingleNode(xml.firstChild, "chapters");
		var chaps = XPath.selectNodes(chapNode, "chapter");
		////trace(chaps.length + " Chapters");
		
		// loop through chapters
		for(var i:Number = 0; i < chaps.length; i++) {

			// make chapter data object
			var chap = this.makeChapter(chaps[i]);
			chap.nChapter = i
			chap.nChapIndex = nChapIndex;
			nChapIndex++;
			
			
			// add ILELocation to chapterLookup
			this.chapterLookup.addValueForKey(nAbsoluteIndex, chap.id);
			
			
			// loop through sections
			var sects = XPath.selectNodes(chaps[i], "section");
			for(var j:Number = 0; j < sects.length; j++) {

				// make section data object
				var sect = this.makeSection(sects[j]);
				sect.nSection = j
				sect.nSectIndex = nSectIndex;
				nSectIndex++;
				chap.addSection(sect);
				////trace(sect);
				
				// add ILELocation to sectionLookup
				this.sectionLookup.addValueForKey(nAbsoluteIndex, chap.id+"_"+sect.id);
				
				
				// loop through clips
				var clips = XPath.selectNodes(sects[j], "clip");
				for(var k:Number = 0; k < clips.length; k++) {

					// make clip data object
					var clip = this.makeClip(clips[k]);
					clip.nClip = k;
					
					// put an absolute index on a clip
					clip.nClipIndex = nClipIndex;
					nClipIndex++;
					
					sect.addClip(clip)
					//trace(clip);
					
					
					// add ILELocation to sectionLookup
					this.clipLookup.addValueForKey(nAbsoluteIndex, chap.id+"_"+sect.id+"_"+clip.id);
					
					// loop through segs
					var segs = XPath.selectNodes(clips[k], "seg");
					for(var sg:Number = 0; sg < segs.length; sg++) {

						//make seg data object
						var seg = this.makeSeg(segs[sg]);
						var sLink = chap.id + "_"+sect.id+"_"+clip.id+"_"+seg.id;
						seg.nAbsoluteIndex = nAbsoluteIndex;
						seg.sLink = sLink;
						seg.nSegment = sg;
						
						// run our model collectors on this seg
						for(var j:Number = 0; j < this.aCollectors.length; j++) {
							this.aCollectors[j].collect(seg);
						}
						
						
						clip.addSegment(seg);
						
						this.aSegments[seg.nAbsoluteIndex] = seg;
						
						// add absolute to sectionLookup
						this.segLookup.addValueForKey(nAbsoluteIndex, sLink);
						nAbsoluteIndex++;
					}
					this.aClips.push(clip);
				}
				this.aSections.push(sect);
			}
			this.aChapters.push(chap);
		}
		this.sortStructure();
	}
	function getSegmentById(sSearchId:String) {
		var nHeadPos = this.segLookup.getValueForKey(sSearchId);
		return this.aSegments[nHeadPos];
	}
	function getBranchHead(seg:SegmentData) {
		var sSearchId = seg.chapter.id+"_"+seg.section.id+"_"+seg.clip.id+"_"+seg.sBranchHead;
		var nHeadPos = this.segLookup.getValueForKey(sSearchId);
		return this.aSegments[nHeadPos];
	}
	public function addCollector(mc:ModelCollector) {
		this.aCollectors.push(mc);
	}
	// this sets up branching segs so we can check for complete
	function sortStructure() {
		for(var i:Number = 0; i < aSegments.length; i++) {
			
			// if a seg belongs in a branch make sure the branch knows about it
			var seg = this.aSegments[i];
			
			//trace(seg);
			
			if(seg.bInBranch) {				
				var sSearchId = seg.chapter.id+"_"+seg.section.id+"_"+seg.clip.id+"_"+seg.sBranchHead;
				
				var nHeadPos = this.segLookup.getValueForKey(sSearchId);
				var segHead = this.aSegments[nHeadPos];
				var nBranch = getBranchNumberFromId(seg.id);
				////trace("Adding Branch: "+seg.id+" to "+segHead.id+" branch head = "+seg.sBranchHead+" branch num: "+nBranch);
				
				segHead.addToBranch(nBranch, seg);
				
				////trace(this.aSegments[nHeadPos]);
			}
			
		}
	}
	// this strips down a branches id to get the branch number
	function getBranchNumberFromId(s:String) {
		if(s.lastIndexOf("_") == (s.length - 1)) {
			s = s.substr(0, (s.length - 2));
		}
		var aParts = s.substr(s.lastIndexOf("_")).split("")
		var sTemp = "";
		for(var i:Number = 0; i < aParts.length; i++) {
			if(!isNaN(parseInt(aParts[i]))) {
				sTemp += aParts[i];
			}   
		}
		return parseInt(sTemp);
	}
	function getChapterCount() {
		return this.aChapters.length
	}
	function getSaveData() {
		
	}
	function restoreSaveData() {
		
	}
	
	function getTotalSegCount() {
		return this.aSegments.length;
	}
	function toString() {
		var s = "--    STRUCTURE DUMP     --\n";
		
		for(var i:Number = 0; i < this.aChapters.length; i++) {
			s += this.aChapters[i]+"\n";
			
			for(var j:Number = 0; j < this.aChapters[i].aSection.length; j++) {
				
				s += this.aChapters[i].aSection[j]+"\n";
				
				for(var k:Number = 0; k < this.aChapters[i].aSection[j].aClip.length; k++) {
					
					s+= this.aChapters[i].aSection[j].aClip[k]+"\n";
					
					for(var sg:Number = 0; sg < this.aChapters[i].aSection[j].aClip[k].aSegment.length; sg++) {
						
						s +=  this.segToString(this.aChapters[i].aSection[j].aClip[k].aSegment[sg]);
						
					}
				}
			}
		}
		return s
	}
	function segToString(segData:SegmentData) {
		if(!segData.bBranchHead) {
			return segData.toString()+"\n";
		}else{
			var s = segData.toString()+"\n";
			for(var i:Number = 0; i < segData.aBranches.length; i++) {
				var branch = segData.aBranches[i];
				for(var j:Number = 0; j < branch.aSegment.length; j++) {
					s+= segToString(branch.aSegment[j]);
				}
			}
			return s
		}
	}
	
	function makeChapter(node:XMLNode) {
		var c = new ChapterData();
		for(var elem in node.attributes) {
			c[elem] = node.attributes[elem];
		}
		return c;
	}
	function makeSection(node:XMLNode) {
		var s = new SectionData();
		for(var elem in node.attributes) {
			s[elem] = node.attributes[elem];
		}
		return s;
	}
	function makeClip(node:XMLNode) {
		var cp = new ClipData() 
		for(var elem in node.attributes) {
			cp[elem] = node.attributes[elem];
		}
		return cp;
	}
	
	
	
	function makeSeg(node:XMLNode) {
		var segId = node.attributes.id;
		if(segId.lastIndexOf("_") == (segId.length - 1)) {
			var seg = new BranchingSegmentData();
		}else{
			var seg = new SegmentData();
		}
		for(var elem in node.attributes) {
			seg[elem] = node.attributes[elem];
		}
		// determine branchiness
		var segId = seg.id;
		if(segId.indexOf("_") == -1) {
			seg.bInBranch = false;
			seg.bBranchHead = false;
		}else{
			// check to see if this is a branch head by checking for the undescore as the last charater of the segid
			if(segId.lastIndexOf("_") == (segId.length - 1)) {
				seg.bBranchHead = true;

				if(segId.lastIndexOf("_") == segId.indexOf("_")) {
					seg.bInBranch = false;

					
				}else{
					seg.bInBranch = true;
					var sTempHead = segId.substr(0, (segId.length - 2));
					
					//trace("sTempHead"+segId+" - "+sTempHead );
					seg.sBranchHead = sTempHead.substr(0, sTempHead.lastIndexOf("_")+1);
					
					//trace("seg.sBranchHead "+seg.sBranchHead );
				}
			}else{
				seg.bBranchHead = false;
				seg.bInBranch = true;
				
				seg.sBranchHead = segId.substr(0, segId.lastIndexOf("_")+1)
				
			}
		}
		// get any childern nodes and turn them into objects
		var axChild = node.childNodes;
		for(var n=0; n<axChild.length; n++) {
			var xChild = axChild[n];
			
			//hack to keep unused and depreciated next node out but preserve the cool idea of adding extra nodes in the future
			if(xChild.nodeName != "next") {
				var hChild = {};
				for(var args in xChild.attributes) {
					
					hChild[args] = xChild.attributes[args];
					////trace(args+": "+xChild.attributes[args]);
				}
				seg[xChild.nodeName] = hChild;
			}
		}
		return seg;
	}
	function getProgress() {
		var nTotal = 0;
		var nComplete = 0;
		for(var i:Number = 0; i < this.aChapters.length; i++) {

			for(var j:Number = 0; j < this.aChapters[i].aSection.length; j++) {

				for(var k:Number = 0; k < this.aChapters[i].aSection[j].aClip.length; k++) {

					for(var sg:Number = 0; sg < this.aChapters[i].aSection[j].aClip[k].aSegment.length; sg++) {
						var segData = this.aChapters[i].aSection[j].aClip[k].aSegment[sg]
						nTotal ++;
						if(segData.getComplete()) {
							nComplete++;
						}
					}
				}
			}
		}
		var nDiv = (nComplete/nTotal);
		if(nDiv == 0) {
			return 0;
		}
		return Math.round(nDiv * 100);
	}
	function getSuspend() {
		var s = "";
		for(var i:Number = 0; i < this.aSegments.length; i++) {
			s += (this.aSegments[i].getConplete()) ? 1 : 0;
		}
		return s;
	}
	function parseSuspend(sSuspend:String) {
		if((sSuspend == undefined) || (sSuspend == "")) {
			return;
		}
		var a = sSuspend.split("");
		for(var i:Number = 0; i < a.length; i++) {
			if(a[i] == "1") {
				this.aSegments[i].setComplete();
			}
		}
	}
}