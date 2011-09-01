/*	Class: enspire.display.PopupManager
	This is a singleton class that manages Alerts, HotSpots, Splashes, Bullet List, Blocker, and Fade

*/
import com.mosesSupposes.fuse.Fuse;
import org.asapframework.util.debug.Log;
import org.asapframework.data.KeyValueList;
//
import enspire.model.Configs;
//
import enspire.core.Server;
import enspire.display.ContentContainer;
import enspire.display.BaseDisplayManager;
import enspire.display.templates.BaseTemplate;
import enspire.display.alerts.AlertTemplate;
import enspire.display.LayoutUtils;
import enspire.display.HotSpotManager;
//
import enspire.display.ITemplateFactory;

import enspire.utils.ConstructorUtil;
import enspire.utils.GarbageCollection;
//
class enspire.display.TemplateManager extends BaseDisplayManager{
	/*	Group: Private Static Vars
		
		Var: aManager
		a holder for our singelton instance
	*/
	private static var aManager:TemplateManager;
	/*	Var: mcPopups
		a movie clip to hold alerts
	*/
	private var mcPopups:MovieClip;
	/*	Var: mcTemplates
		a movieclip to hold splashes and bullet list and hot spot popups
	*/
	private var mcTemplates:MovieClip;
	/*	Var: mcAlerts
		a movieclip to alert templates
	*/
	private var mcAlerts:MovieClip;
	/*	Var: mcFade
		a movieClip that holds our fade overlay
	*/
	private var mcFade:MovieClip;
	/*	Var: mcBlocker
		a movieClip that acts as a blocker for the content area
	*/
	private var mcBlocker:MovieClip;
	/*	Var: nFadeDuration
		number in seconds for fade in, default is .5. This can be set from popupSetup.as
	*/
	private var nFadeDuration:Number;
	/*	Var: nBlocklerAlpha
		number the alpha of the blocker clip, default is 50. This can be set from popupSetup.as
	*/
	private var nBlockerAlpha:Number;
	/*	Var: aTemplates
		array holding the templates currently on the stage
	*/
	private var aTemplates:Array;
	/*	Var: factory
		Template Factory for the popup manager to use for template creation
	*/
	private var factory:ITemplateFactory;
	/*	Var: hotspots
		reference to the hotspot manager
	*/
	public var hotspots:HotSpotManager;
	/*	Group: Constructor
		
		Function: PopupManager
		private function for singelton call getInstance to initilizs this class
	*/
	
	private function TemplateManager() {
		super();
		this.nFadeDuration = .5;
		this.nBlockerAlpha = 50;
		this.aTemplates = new Array();
		Server.addController("templates", this);
		//Log.info("created", this.toString());
	}
	/*	Function: getInstance
		returns the singelton instance of this class
	*/
	public static function getInstance() : TemplateManager {
		if(aManager ==  undefined) {
			aManager = new TemplateManager()
		}
		return aManager;
	}
	/*	Group: Init Functions
			
		Function: setContainer
		this sets up all the necissary movieclips inside of the content containers clip
		
		Parrameters:
		container - (required) a ContentContainer, these are typicaly set up in guiSetup.as
	*/
	public function setContainer(container:ContentContainer) : Void {
		super.setContainer(container);
		// create a holder for templates
		var mcClip =  this.cContainer.getClip();
		var nW = this.cContainer.getWidth();
		var nH = this.cContainer.getWidth();
		//
		this.mcTemplates = mcClip.createEmptyMovieClip("mcTemplates", 10);
		this.mcPopups = mcClip.createEmptyMovieClip("mcPopups", 20); 
		
		this.hotspots = new HotSpotManager(this.mcPopups, nW, nH);
		
		// create fade clip
		this.mcFade = mcClip.attachMovie("fade", "mcFade", 30);
		this.mcFade._alpha = 0;
		this.mcFade._width = nW;
		this.mcFade._height = nH;
		// create blocker
		this.mcBlocker = mcClip.attachMovie("blocker", "mcBlocker", 40)
		this.mcBlocker._alpha = this.nBlockerAlpha;
		this.mcBlocker._width = nW;
		this.mcBlocker._height = nH;
		this.mcBlocker.onRollOver = function() {
			this.useHandCursor = false;
		}
		this.hideBlocker();
		// create a holder for alerts and make sue it is not pausable
		this.mcAlerts = this.cContainer.getClip().createEmptyMovieClip("mcAlerts", 50);
		this.mcAlerts.bPausable = false;
	}
	public function registerFactory(factory:ITemplateFactory) {
		if(!(factory instanceof ITemplateFactory)) {
			//Log.error("Template Factory does not implement ITemplateFactory", this.toString());
		}
		//Log.info("Template Factory Registered: "+factory.toString(), this.toString());
		this.factory = factory;

	}
	/*	Function: doAlert
	
		Parrameters:
		sType - (required) string name of alert
		sText - (required) string text of 
	*/
	public function doAlert(sType:String, sText:String, sButtonLabel:String , fCallback:Function) : AlertTemplate {
		var alert = this.factory.makeTemplate(sType, this.mcAlerts);
		
		alert.clip.nWidth = this.cContainer.getWidth();
		alert.clip.nHeight = this.cContainer.getHeight();
		alert.clip.setText(sText);
		alert.clip.addButton(sButtonLabel, fCallback);
		alert.clip.allowAccess()
		alert.clip.draw();
		
		var profile = Configs.getProfile(alert.profile);
		alert.clip.setProfile(profile);
		
		this.alignToContainer(alert.clip, profile);
		
		GarbageCollection.markAsTrash(alert.clip);
		
		this.showBlocker();
		
		//Log.info("Do alert - type: "+sType+"\n\ttext: "+sText+"\n", this.toString());
		return alert.clip;
	}
	public function doConfirm(sType:String, sText:String, sButtonLabel1:String , fCallback1:Function, sButtonLabel2:String , fCallback2:Function) {
		
	}
	// -----------------------------------------------------------------------  Blocker Functions
	public function showBlocker() {
		this.mcBlocker._visible = true;
	}
	public function hideBlocker() {
		this.mcBlocker._visible = false;
	}
	public function setBlockerAlpha(n:Number) {
		if(isNaN(n)) { 
			return;
		}
		this.nBlockerAlpha = n;
		if(this.mcBlocker != undefined) {
			this.mcBlocker._alpha = this.nBlockerAlpha;
		}
	}
	// -----------------------------------------------------------------------  Fade Functions
	public function setFadeDuration(n:Number) {
		if(isNaN(n)) { 
			return;
		}
		this.nFadeDuration = n;
	}
	public function doFade() {
		//Log.status("Fade in overlay: "+this.nFadeDuration, this.toString());
		this.mcFade._alpha = 100;
		this.mcFade.fadeOut(this.nFadeDuration);
		this.mcFade._visible = true;
	}
	public function hideFade() {
		this.mcFade._visible = false;
	}
	// -----------------------------------------------------------------------  Template Functions
	/*	Function: createTemplate
		adds a new template to the stage
	
		Parrameters:
		sTemplate - (required) string name of alert
		sProfile - (optinal) override default profile
		nDelay - (optional) set a delay for the temaplete to be drawn
	*/
	public function createTemplate(sTemplate:String, sProfile:String, nDelay:Number) {
		// attempt to get a template from the template factory
		var template = this.factory.makeTemplate(sTemplate, this.mcTemplates);
		template.clip.nWidth = this.cContainer.getWidth();
		template.clip.nHeight = this.cContainer.getHeight();
		
		// get the template over ride if there is one
		if(sProfile == undefined) {
			template.profile = sTemplate; 
		}
		
		// get the profile object from the configs and assign it to the template
		var profile = Configs.getProfile(template.profile);
		template.clip.setProfile(profile);
		
		// maybe refactor to accept a override so this can easily be used by sims
		template.clip.setArgs(Server.model.args);
		
		// make sure the clip gets removed form the stage
		GarbageCollection.markAsTrash(template.clip);
		
		// add to list of current templates
		this.aTemplates.push(template.clip);
		
		// delay if needed
		if(!isNaN(nDelay)) {
	
			template.clip.draw();
			this.alignToContainer(template.clip, profile);
			
		}else{
			// create a fuse and scope it to the content containers clips so it gets picked up by pause/play
			var f = new Fuse();
			f.target = template.clip;
			f.scope = template.clip;
			
			// add the delay
			f.push({ delay: nDelay });
			var fInit = function() {
				//trace("TEMPLATE INITED");
				this.draw();
				Server.getController("templates").alignToContainer(this);
			}
			f.push({func:fInit});
			f.start();
		}
	
		//Log.status("Created Template "+sTemplate+", delay: "+nDelay+", profile: "+template.profile, this.toString());
		
		// return the clip
		return template.clip;
	}
	/*	Function: getTemplate
		returns a template
	
		Parrameters:
		nTemplate - (optinal) if you have multiple templates on the stage use the number in which they where added starting with 0
	*/
	public function getTemplate(nTemplate:Number) {
		if(nTemplate == undefined) {
			nTemplate = 0;
		}
		return this.aTemplates[nTemplate];
	}
	/*	Function: flush
		clears the array of templates on stage called by the appcontroller
	*/
	public function flush() {
		this.aTemplates = new Array();
	}
	/*	Function: alignToContainer
		dynamicly alligns a template to its content container from parmaeters set in its profile
		
		Parrameters:
		template(required) - a BaseTemplate or its sub class 
	*/
	public function alignToContainer(template:BaseTemplate) {
		
		var profile = template.profile
		////Log.debug("alignToContainer :"+template.toString() + profile.xAlign+ " x "+profile.yAlign);
		// if we are doing a dynamic allign
		if((profile.xAlign != undefined) && (profile.yAlign != undefined)) {
			//Log.debug("DYNA ALIGN :"+profile.xAlign+" x "+ profile.yAlign);
			LayoutUtils.dynaAlignToBounds(this.cContainer.getBounds(), template, profile.xAlign, profile.yAlign);
		}else{
			// set dynamic registartion
			if(!isNaN(profile.nRegY)) {
				template.yreg = profile.nRegY;
			}
			if(!isNaN(profile.nRegX)) {
				template.xreg = profile.nRegX;
			}
			// set x and y bases on dynamic registration
			if(!isNaN(profile.nPosY)) {
				template._y2 = profile.nPosY;
			}
			if(!isNaN(profile.nPosX)) {
				template._x2 = profile.nPosX;
			}
		}
		
	}
	public function refresh() {
		hideBlocker();
	}
	public function toString() {
		return "enspire.display.TemplateManager";
	}
}