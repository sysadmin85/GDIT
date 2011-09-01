import enspire.core.Server;
import enspire.display.layout.BoxLayout;
import enspire.display.panels.SimpleResourceDisplay;
import enspire.model.Resources;
import enspire.model.ResourceData;
import enspire.model.ResourceGroup;
import enspire.model.State;
import enspire.ile.AppEvents;

class enspire.display.panels.ClipResourceDisplay extends SimpleResourceDisplay{
	private var profile:Object;
	private var sSkin:String;
	private var layout:BoxLayout;
	private var currentGroup:String;
	private var sDefaultGroup:String;
	private var bMultipleChapters:Boolean;
	private var bMultipleSections:Boolean;
	function ClipResourceDisplay() {
		super();
	}
	function init() {
		this.sSkin = (this.profile["sSkin"] == undefined) ? "ResourceLink" : this.profile["sSkin"];
		this.sDefaultGroup = (this.profile["sDefaultGroup"] == undefined) ? "course" : this.profile["sDefaultGroup"];
		this.layout = new BoxLayout(this);
		
		// these are so that we do not have to add section id or chapter id if we do not have multiples
		this.bMultipleChapters = (Server.model.structure.getChapterCount() > 1);
		this.bMultipleSections = (!bMultipleChapters &&  !(Server.model.structure.aChapters[0].getSectionCount() == 1));

		Server.connect(this, "update", AppEvents.START_SEG);
	}
	function draw() {
		
	}
	function update() {
		
		
		var sLabel = State.sClipId;
		if(this.bMultipleChapters) {
			sLabel = State.sChapterId + "_" +State.sSectionId + "_" + sLabel;
		}else if(this.bMultipleSections) {
			sLabel = State.sSectionId + "_" + sLabel;
		}
		
		if(!Resources.hasResourceGroup(sLabel)) {
			sLabel = this.sDefaultGroup
		}
		
		//trace("LOOKING FOR RESOURCE GROUP: "+sLabel);
		// if we are still in the same group do nothing
		if(this.currentGroup == sLabel) {
			return;
		}
		this.currentGroup == sLabel
		layout.removeElements();
		var aRes = Resources.getResourcesArray(sLabel);
		//trace("MAKING "+aRes.length+" resources");
		for(var i:Number = 0; i < aRes.length; i++) {
			var mc = makeButton(aRes[i], i);
			layout.addElement(mc);
		}
		layout.update();
	}
	function makeButton(rd:ResourceData, nIndex:Number) {
		var mc:MovieClip = this.attachMovie(this.sSkin, "mcResource" + nIndex, nIndex);
		mc.mcText.tf.autoSize = true;
		mc.mcText.tf.text = rd.title;
		mc.resource = rd;
		
		if(mc.mcIcon != undefined) {
			mc.mcIcon.gotoAndStop(rd.type);
		}
		
		
		mc.onRelease = function() {
			this._parent.launchResource(this.resource);
		}
		mc.onRollOver = function() {
				this.gotoAndStop("over")
		}
		mc.onRollOut = mc.onReleaseOutside = function() {
				this.gotoAndStop("out");
		}
		
		mc.mcBg._height = (mc.mcText._y * 2) + mc.mcText._height;
		
		return mc;
	}
	public function toString() {
		return "enspire.display.panels.SimpleResourceDisplay";
	}
	public function launchResource(rd:ResourceData){
		getURL(rd.url, "_blank");
	}
}