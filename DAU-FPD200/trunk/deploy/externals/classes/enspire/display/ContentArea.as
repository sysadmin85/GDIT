/*
	Class: ContentArea
	holds references to all the various layers in the applications display area
*/

import org.asapframework.util.debug.Log;
import org.asapframework.util.StringUtils;
import enspire.display.ContentContainer;
import enspire.utils.ClipUtils;


class enspire.display.ContentArea{
	/* Group: Private Vars
		
		Var: aContainers
		Array of all content containers in this area
	*/
	
	private var aContainers:Array;
	private var mcContainer:MovieClip;
	private var mcArea:MovieClip;
	/*	Var: nHeight
		holds the height of current area, is pulled from mask height. It will be supplied to ContentContainers if one is not specified.
	*/
	private var nHeight:Number;
	/*	Var: nWidth
		holds the width of current area, is pulled from mask width. It will be supplied to ContentContainers if one is not specified.
	*/
	private var nWidth:Number;
	/*	Var: sName
		name id of ContentArea
	*/
	private var nDepth:Number
	private var sName:String;
	/*	Var: mcMask
		movieClip to use as a Mask, containers will automaticlly setMask using this mask clip it is required
	*/
	private var mcMask:MovieClip;
	/* Group: Constructor
		
		Function: ContentArea
		
		Parameters:
			sName - requires string for name id of area
			mcArea - required MovieClip to house containers, should have one movieClip called mcMask to work properly
	*/
	function ContentArea(sName:String, mcArea:MovieClip, nWidth:Number, nHeight:Number) {
		this.sName = sName;

		this.mcArea = mcArea;
		this.mcMask = mcArea.mcMask;
		this.mcContainer = this.mcArea.createEmptyMovieClip("mcContainer", 10);
		
		if(this.mcMask != undefined) {
			this.mcMask  = this.mcArea.mcMask;
			this.mcMask.swapDepths(20);
			this.mcContainer.setMask(this.mcMask);
		}
		this.nWidth  = nWidth;
		this.nHeight = nHeight;
		this.nDepth = 0;
		this.aContainers  = new Array();
		//Log.status("New Content Area "+this.nWidth+"x"+this.nHeight, this.toString());
	}
	/* Group: Methods
		
		Function: addContentContainer
		creates a ContentContiner and adds it to aContainers
		
		Parameters:
			sName - required string for name id of conatiner

			nW - optional width, will use ContentArea width if not supplied
			nH - optional height, will use ContentArea height if not supplied
	*/
	public function addContentContainer(sName:String, bPausable:Boolean, nW:Number, nH:Number) : Void {
		var sInstanceName = "mc"+StringUtils.capitalizeWords(sName);
		var mc:MovieClip

		mc = this.mcContainer.createEmptyMovieClip(sInstanceName, this.mcContainer.getNextHighestDepth());

		var nContainerW:Number = isNaN(nW) ? this.getWidth() : nW;
		var nContainerH:Number = isNaN(nH) ? this.getHeight() : nH;
		
		
		var oContainer = new ContentContainer(sName, mc, nContainerW, nContainerH, this.mcMask, bPausable);
		aContainers.push(oContainer);
		//Log.info("addContentContainer: "+ oContainer.toString(), this.toString());
	}
	/*	Function: getContainer
		Returns a ContentContainer
		
		Parameters:
			sName - required string for name id of conatiner
	*/
	public function getContainer(sName:String) : ContentContainer {
		for(var i:Number = 0; i < this.aContainers.length; i++) {
			if(this.aContainers[i].name == sName) {
				return this.aContainers[i]
			}
		}
	}
	/*	Function: hasContainer
		Returns a true/false if container is in area
		
		Parameters:
			sName - required string for name id of conatiner
	*/
	public function hasContainer(sName) : Boolean {
		for(var i:Number = 0; i < this.aContainers.length; i++) {
			if(this.aContainers[i].name == sName) {
				return true;
			}
		}
		return false;
	}
	/*	Function: getId
		Returns string name of ContentArea
	*/
	public function getId() {
		return this.sName;
	}
	/*	Function: getWidth
		Returns width of area as determind by mask
	*/
	public function getWidth() {
		return nWidth;
	}
	/*	Function: getHeight
		Returns height of area as determind by mask
	*/
	public function getHeight() {
		return nHeight;
	}
	function pause() {
		for(var i:Number = 0; i < this.aContainers.length; i++) {
			if(this.aContainers[i].isActive()) {
				this.aContainers[i].pause();
			}
		}
	}
	function resume() {
		for(var i:Number = 0; i < this.aContainers.length; i++) {
			if(this.aContainers[i].isActive()) {
				this.aContainers[i].resume();
			}
		}
	}
	function setActiveContainers(a:Array) {
		var sTmp = a.join(",");
		//Log.status("Setting active containers "+sTmp, this.toString());
		for(var i:Number = 0; i < this.aContainers.length; i++) {
			if(sTmp.indexOf(this.aContainers[i].name) == -1) {
				this.aContainers[i].setActive(false);
			}else{
				this.aContainers[i].setActive(true);
			}
		}
	}
	/*	Function: toString
		Returns sName of Area, may want to add dump of ContentContainer ids at some point
	*/
	public function toString() {
		return "ContentArea: "+this.sName;
	}
	
	
}