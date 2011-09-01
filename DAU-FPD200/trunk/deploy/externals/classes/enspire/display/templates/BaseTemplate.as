/* 	Class: enspire.display.templates.BaseTemplate 
	A base class for all ILE templates to extend from. This class is dynamic to allow psuedo multiple class inheritance for dynamic registration
*/
import org.asapframework.util.debug.Log;
//
import enspire.core.Server;
import enspire.display.templates.ITemplate;
import enspire.model.Configs;
import enspire.model.Labels;
import enspire.display.LayoutUtils;
import enspire.utils.TextFieldUtils;
import enspire.core.SoundManager;
import enspire.display.BaseDisplayObject;
dynamic class enspire.display.templates.BaseTemplate extends BaseDisplayObject implements ITemplate{
	/*	Group: Private vars
		
		Var: nW
		number max width of template display area
	*/
	private var nW:Number;
	/*	Var: nH
		number max height of template display area
	*/
	private var nH:Number;
	/*	Var sounds
		a reference to the SoundManager
	*/
	private var sounds;
	/*	Group: Public Vars
	
		Var: args
		reference to current segments args
	*/
	public var args:Object;
	/*	Var: profile
		config profile object
	*/
	public var profile:Object;
	/*	Var: mcClip
		refernce to the clipplayer clip
	*/
	public var mcClip:MovieClip;
	/*	Group: Constructor
	
		Function: BaseTemplate
		adds dynamic registration and gets refernec to clipplayer clip
	*/
	function BaseTemplate() {
		super();
		this.hide()
		this.mcClip = Server.getController("clipPlayer").mcSkin.mcClip;
		sounds = SoundManager.getInstance();
	}
	/*	Group: Utility Functions
	
		Function: setArgs
		sets the args for this template
		
		Parrameters:
		o - (required) args object
	*/
	public function setArgs(o:Object) {
		this.args = o;
	}
	/*	Function: setProfile
		sets the profile for this template
		
		Parrameters:
		o - (required) profile object
	*/
	public function setProfile(o:Object) {
		this.profile = o;
	}
	/*	Function: findClip
		searches clipplayer clip for movieclip
		
		Parrameters:
		sName - (required) string instance name of the movieclip
	*/
	public function findClip(sName:String) {
		return LayoutUtils.find(this.mcClip, sName, "movieclip");
	}
	/*	Function: sizeTextField
		set a text fields width
		
		Parrameters:
		tf - (required) textfield to size
		nW - (required) number width
	*/
	public function sizeTextField(tf:TextField, nW:Number) {
		LayoutUtils.applyWidthToTextField(tf, nW);
	}
	/*	Function: getLabel
		gets labels text
		
		Parrameters:
		sLabel - (required) string name of label
	*/
	public function getLabel(sLabel:String) {
		return Labels.getLabel(sLabel)
	}
	/*	Function: draw
		used to do initial render of template should be implemented in subclass
	*/
	public function draw() {
		//Log.status("Draw", this.toString());
		this.show();
		this.gotoAndPlay("start");
	}
	/*	Function: update
		update any layout or changes
	*/
	public function update() {
		
	}
	/*	Function: nWidth
		getter/setter for max template width
	*/
	public function get nWidth() : Number {
		return this.nW;
	}
	public function set nWidth(n:Number) {
		this.nW = n;
	}
	/*	Function: nHeight
		getter/setter for max template height
	*/
	public function get nHeight() : Number {
		return this.nH;
	}
	public function set nHeight(n:Number) {
		this.nH = n;
	}
	public function setTextStyle(tf:TextField) {
		TextFieldUtils.setStyleSheet(tf)
	}

	/*	Function: toString
		returns string "enspire.display.templates.BaseTemplate"
	*/
	public function toString() {
		return "enspire.display.templates.BaseTemplate";
	}
	
}