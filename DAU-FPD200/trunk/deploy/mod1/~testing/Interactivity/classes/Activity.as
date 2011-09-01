import org.asapframework.util.debug.Log;
import org.asapframework.util.ArrayUtils;


import enspire.model.Labels;
import enspire.model.ChoiceData;
import enspire.core.Server;

import DisplayManager;

class Activity{
	public static var MODE_REVIEW:String = "review";
	public static var MODE_ACTIVE:String = "active";
	public static var MODE_INACTIVE:String = "inactive";
	
	public var template:MovieClip;
	private var controller
	public var profile:Object;
	public var args:Object;
	private var sMode:String;
	private var mcSubmit:MovieClip;
	function Activity(mcTemplate:MovieClip, oProfile:Object) {
		this.template = mcTemplate;
		this.profile = oProfile;
		this.template.activity = this;
		
		// get save data
		
		// restore tries 
		
		// if presistant and tries are up go straight to review mode
		
		
		
		this.mcSubmit = this.getSubmit();
		this.mcSubmit.activity = this;
		hideSubmit();
	}
	
	function init() {
		this.controller.init();
		template.init();
		
		// check to see what our start mode is and set mode for the controller
		this.controller.setMode(MODE_ACTIVE);
		
		// call update our template 
		this.template.update();
	}
	
	function addController(sController) {
		// make controller
		
		this.controller = new MultChoiceController();
		// add check to see if current seg has the holder for the display
		
		// make display to be based on profile
		var display = new DisplayManager(this.template.mcActivity);
		display.controller = controller;
		// set display for controller and profile, args, and build model;
		controller.setDisplay(display);
		controller.activity = this;
		controller.template = this.template;
		controller.args = this.args;
		display.template = this;
		controller.buildModel();
	}
	// refactor to look in current segment first
	function getSubmit() {
		return this.template.mcSubmit;
	}
	function showSubmit() {
		this.mcSubmit._visible = true;
	}
	function hideSubmit() {
		this.mcSubmit._visible = false;
	}
	function setSubmitReady(b:Boolean, nIndex:Number) {
		if(b) {
			showSubmit();
		}else{
			hideSubmit()
		}
	}
	function submit() {
		trace("SUBMITED");
		var bCorrect = this.controller.isCorrect();
		this.controller.setMode(MODE_REVIEW);
		this.template.update();
		
		// get save data and save it
		
		// decide if next or feedback or just hang out in review mode and pulse next
		
		
		this.controller.setMode(MODE_REVIEW);
		
		hideSubmit();
	}
	function getFeedback() {
		// get the selection string from the controller
		
		// decide if we need to does specialized feed back and if so how
		
		// decide if
	}
	function get mode() {
		return this.sMode;
	}
	
	function start() {
		this.controller.setMode(MODE_ACTIVE);
	}
	function endActivity() {
		
	}
}