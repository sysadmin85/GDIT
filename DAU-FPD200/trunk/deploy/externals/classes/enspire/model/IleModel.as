import org.asapframework.util.debug.Log;
import org.asapframework.util.ObjectUtils;
//
import enspire.model.CourseModel;
import enspire.model.Configs;
import enspire.model.State;
import enspire.model.ILELocation;
import enspire.model.Labels;
import enspire.model.structure.*;
import enspire.utils.ILE_utils;

import enspire.core.Server;
//
// the defualt model class for a ILE course can be extend to meet course demands
class enspire.model.IleModel extends CourseModel{
	public static var STRUCT:String = "struct";
	public var structure:StructureData;
	public var oStructure;
	private var oChapter:ChapterData;
	private var oSection:SectionData;
	private var oClip:ClipData;
	private var oSeg:SegmentData;
	
	private var oArgs;
	function IleModel() {
		super();
		this.structure = new StructureData();
	}
	function createModel() {
		if(Server.xmls.hasXml( IleModel.STRUCT)) {
			buildStruct( Server.xmls.getXml( IleModel.STRUCT, true) )
		}
	}
	// load xml is not typecaset becuase it casues problems with the xml prototyping nice to do replace with XPath to get chapters
	// ------------------------------------------------------------------------------- Model functions
	function buildStruct(loadXml){
		//Log.status("BUILDING STRUCT", this.toString());
		this.structure.parseStructure(loadXml);
		
		
		var xmlChapters = loadXml.firstChild.findElement("chapters");
		this.oStructure =  new _global.ILE.StructureClass(xmlChapters);
		_global.ILE.app.oStructure = this.oStructure;
		//Log.status("xml parsing OK", this.toString());
		this.getNumValidSegs();
		
		
	}
	public function getPrev(){
		var seg = Server.model.getSegData(State.nAbsoluteIndex);
		if(seg.bInBranch) {
			if(seg.nBranchOrder == 0) {
				return seg.head.nAbsoluteIndex;
			}			 
		}
		var nBack = State.nAbsoluteIndex-1;
		var segBack = Server.model.structure.aSegments[nBack]
		// if were trying to back up into a branch make sure we back clear out of the branch
		if(segBack.bInBranch) {
			for(var i:Number = nBack; i >= 0; i--) {
				if(Server.model.structure.aSegments[i].bInBranch == false) {
					return i;
				}
			}
		}
		return nBack;
	}
	// returns the id for next seg branching is determined here
	public function getNext() {
		var seg = Server.model.getSegData(State.nAbsoluteIndex);
		var nNext = State.nAbsoluteIndex + 1;
		if(seg.bInBranch) {
			if(seg.nBranchOrder == (seg.branch.length -1)) {				
				// if we have completed the branch by either none one or all branches being explored get the next seg from the continue to seg from the args
				if(seg.head.getComplete()) {
					//trace("seg.head.getComplete()) "+seg.head.getComplete());
					for(var i:Number = nNext; i < Server.model.structure.aSegments.length; i++) {
						var segData = Server.model.structure.aSegments[i];
						if(!segData.bInBranch) {
							return segData.nAbsoluteIndex;
						}
					}	
				}
				return seg.head.nAbsoluteIndex;
			}			 
		}else{
			if(seg.bBranchHead) {
				for(var i:Number = nNext; i < Server.model.structure.aSegments.length; i++) {
					var segData = Server.model.structure.aSegments[i];
					if(!segData.bInBranch) {
						return segData.nAbsoluteIndex;
					}
				}	
			}
		}
		return nNext;
		
	}
	// this function will be removed when old clip player is updated
	function getNumValidSegs(){
		var aChapter:Array = new Array();
		var aChapters:Array = this.oStructure.aChapter;
		//temp varible to map old structure to new one
		var nAbsolute = 0;
		for(var i=0; i<aChapters.length; i++){
			var o:Object = {};
			o.aSection = [];
			aChapter.push(o);
			
			var sChapterId = aChapters[i].id;
			var aSections = aChapters[i].aSection;
			
			for(var j=0; j<aSections.length; j++){
				
				var o = {};
				o.aClip = [];
				aChapter[i].aSection.push(o);
				
				var sSectionId = aSections[j].id;
				var aClips = aSections[j].aClip;
				
				for(var k=0; k<aClips.length; k++){
					
					var sClipId = aClips[i].id;
					
					var o = {};
					o.aSegment = [];
					aChapter[i].aSection[j].aClip.push(o);
					
					var aSegments = aClips[k].aSegment;
					
					
					
					for(var m=0; m<aSegments.length; m++){
						
						aSegments[m].nAbsolute = nAbsolute;
						nAbsolute++;
						
						if(aSegments[m].id.indexOf("_") < 0){
							aChapter[i].aSection[j].aClip[k].aSegment.push(aSegments[m].id);
						}
					}
				}
			}
		}
	}
	public function setGlobalLocation(nIndex:Number) {
		//trace("setGlobalLocation("+nIndex+")");
		var seg = this.getSegData(nIndex);
		
		var aSegIdParts = seg.id.split("_");
		// gets our location in numerical indexes and sets it to a global set of variables
		var nChapter = seg.chapter.nChapter;	
		var nSection = seg.section.nSection;
		var nClip = seg.clip.nClip
		var nSegment = seg.nSegment
		
		
		// set globally
		State.nChapter = seg.chapter.nChapter;
		State.nSection = seg.section.nSection;
		State.nClip = seg.clip.nClip;
		State.nSegment = seg.nSegment;
		
		
		// set total segments realitive to branch
		if(seg.bInBranch) {
			State.nTotalSegments = seg.branch.length + 1;
		}else{
			State.nTotalSegments = seg.clip.getSegCount()+ 1
		}
		
		
		
		
		State.nTotalChapters = structure.getChapterCount();
		State.nTotalSections = seg.chapter.getSectionCount();
		State.nTotalClips    = seg.section.getClipCount();

		this.setArgs(seg.args)
		this.oChapter = seg.chapter
		this.oSection = seg.section;
		this.oClip = seg.clip;
		this.oSeg = seg
		
		// global ids, too
		State.sChapterId = seg.chapter.id;
		State.sSectionId = seg.section.id;
		State.sClipId = seg.clip.id;
		State.sSegmentId = seg.id;
		
		State.bBranching = seg.bInBranch;
		
		State.bFirstSeg = (seg.nAbsoluteIndex == 0);
		State.bFirstSegInClip = (seg.nSegment == 0);
		State.bLastSeg = (seg.nAbsoluteIndex == (this.structure.aSegments.length - 1));
		
	}
	public function getClip(nChapter:Number, nSection:Number, nClip:Number) : Object {
		return this.oStructure.aChapter[nChapter].aSection[nSection].aClip[nClip];
	}
	public function get args() {
		return this.oArgs;
	}
	public function get chapter() {
		return this.oChapter;
	}
	public function get section() {
		return this.oSection;
	}
	public function get clip() {
		return this.oClip;
	}
	public function get seg() {
		return this.oSeg;
	}
	
	public function argsToString() {
		var s:String = "\n-----------------------  Start Args -------------------\n";
		for(var arg in this.oArgs) {
			s += "\t"+arg+":   "+this.oArgs[arg]+"\n";
		}
		s += "-----------------------   End Args  -------------------\n";
		return s;
	}
	
	public function getCourseTitle() {
		//return oStructure.aChapter[0].title;
		return Labels.getLabel("courseTitle");
	}
	public function getSectionTitle() {
		return oStructure.aChapter[0].aSection[State.nSection].title;
	}
	public function getClipTitle() {
		return oStructure.aChapter[0].aSection[State.nSection].aClip[State.nClip].title;
	}
	public function getSegData(n:Number) {
		return structure.aSegments[n];
	}
	function toString() : String {
		return "enspire.model.IleModel";
	}
}