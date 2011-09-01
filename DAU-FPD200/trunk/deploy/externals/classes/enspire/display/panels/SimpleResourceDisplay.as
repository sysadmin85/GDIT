import enspire.model.Resources;
import enspire.model.ResourceData;
import enspire.model.ResourceGroup;
import enspire.model.Configs;
import enspire.display.layout.BoxLayout;
import enspire.display.BaseDisplayObject;
class enspire.display.panels.SimpleResourceDisplay extends BaseDisplayObject{
	private static var PROFILE_NAME:String = "resourceDisplay"
	private var profile:Object;
	private var sSkin:String;
	private var sDefaultGroup:String;
	private var layout:BoxLayout;
	function SimpleResourceDisplay() {
		this.profile = Configs.getProfile(PROFILE_NAME);
		init();
	}
	function init() {
		this.getProfile()
		this.sSkin = (this.profile["sSkin"] == undefined) ? "ResourceLink" : this.profile["sSkin"];
		this.sDefaultGroup = (this.profile["sDefaultGroup"] == undefined) ? "course" : this.profile["sDefaultGroup"];
		this.draw();
	}

	function draw() {
		var layout = new BoxLayout(this);
		
		// get the resource model for the course group
		var aRes = Resources.getResourcesArray(this.sDefaultGroup);

		
		for(var i:Number = 0; i < aRes.length; i++) {
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