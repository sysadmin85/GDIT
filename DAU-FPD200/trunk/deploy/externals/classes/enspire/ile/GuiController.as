import org.asapframework.util.debug.Log;
//
import mx.events.EventDispatcher;
//
import com.mosesSupposes.fuse.*;
//

import enspire.accessibility.AccessManager;
import enspire.core.Server;
import enspire.audio.SoundManager;
import enspire.display.ContentArea;
import enspire.display.BaseGui;
import enspire.display.Tooltip;
import enspire.ile.AppEvents;
import enspire.model.Configs;
import enspire.model.Labels;
import enspire.model.State;
import enspire.utils.ILE_utils;
import enspire.utils.TimeUtils
import enspire.utils.GarbageCollection;
import enspire.utils.ClipUtils;
import enspire.debug.JumpMenu;


//
class enspire.ile.GuiController extends BaseGui{
	// static var for sigleton implemetation
	private static var gui_controller:GuiController;
	//
	private var bPostSkinInit:Boolean
	//
	public var sounds:SoundManager;
	//
	public var mcJumpMenu:JumpMenu;
	
	// constructor and static helper functions
	private function GuiController(inTimeline:MovieClip, sName:String) {
		super(inTimeline, sName);
		this.mcTimeline = inTimeline;
		
		// set up fuze if we are working
		if(this.mcTimeline._parent == undefined) {
			ZigoEngine.simpleSetup(Shortcuts, Fuse, PennerEasing);
		}
		//
		//this.disableControl("autoplay");
		//this.disableControl("mute");
		//
		this.bPostSkinInit = false;

		
		
		if(State.bFinal) {
			this.mcTimeline.mcJumpMenu.removeMovieClip();
		}else{
			this.mcJumpMenu = this.makeDisplayObject(this.mcTimeline.mcJumpMenu, JumpMenu);
			this.mcTimeline.tfDebug.text = "";
			this.mcJumpMenu.init();
		}
		
		//make the tooltip manager
		Tooltip.init(this.mcTimeline);
		
		// set the sound managers clip to this timeline so that we can put event sounds in the gui library 
		this.sounds = Server.sounds;
		this.sounds.setContainer(this.mcTimeline);
		// parse the audio xml if we have it
		if(Server.xmls.hasXml("audio")) {
			this.sounds.parseSounds(Server.xmls.getXml("audio"));
		}
		// connect up to the server
	
		Server.connect(this, "update", AppEvents.START_SEG);
		Server.addController("gui", this);
		//Log.status("init()\n\tgui base clip:"+this.mcTimeline, this.toString());
	}
	// 
	//  ---------------------------------------------------------------------------------------------------  //     
	//								constructor and static helper functions									 //
	//  ---------------------------------------------------------------------------------------------------  //	
	//
	public static function init(inTimeline:MovieClip, sName:String) {
		if(inTimeline == undefined) {
			//Log.error("you must include a reference to the gui ex: init(this, \"main\")", "Gui_controller");
			return;
		}
		if(gui_controller != undefined) {
			//Log.error("gui has already been initilized", "Gui_controller");
			return gui_controller;
		}
		gui_controller = new GuiController(inTimeline);
		return gui_controller;
	}
	public static function getInstance() {
		if(gui_controller == undefined) {
			//Log.error("gui has not been initilized yet call  init([reference to gui timeline], sName)", "Gui_controller");
			return;
		}
		return gui_controller;
	}
	//
	//  ---------------------------------------------------------------------------------------------------  //     
	//											Basic Gui Actions											 //
	//  ---------------------------------------------------------------------------------------------------  //	
	//
	public function initControls() {
		this.setAutoplay(State.bAutoplay);
		this.setMute(State.bMute);
	}
	public function setAutoplay(bAutoplay:Boolean){
		//Log.status("setAutoplay("+bAutoplay+")", this.toString());
		if(bAutoplay) {
			this.getControl("autoplay").setIcon("check_on");
		}else{
			this.getControl("autoplay").setIcon("check_off");
		}
	}
	public function setMute(bMute:Boolean){
		//Log.status("setMute("+bMute+")", this.toString());
		if(bMute) {
			this.getControl("mute").setIcon("check_on");
		}else{
			this.getControl("mute").setIcon("check_off");
		}
	}
	//
	//  ---------------------------------------------------------------------------------------------------  //     
	//												Loading													 //
	//  ---------------------------------------------------------------------------------------------------  //	
	//
	public function preloadStarted() {
		//Log.status("preloadStarted()", this.toString());
		/*var mcSkin = Server.getController("clipPlayer").mcSkin
		mcSkin.mcPreloadAnim.nVisibleDelay = 0;*/
		//ClipUtils.resume(mcSkin.mcPreloadAnim);
	}
	
	public function preloadProgress(nPercent:Number){
		//Log.status("preloadProgress(" + nPercent + ")", this.toString());
		/*var mcSkin = Server.getController("clipPlayer").mcSkin
		// make visible here so there is a one-second delay so if file is in cache (or local), it never gets shown.
		mcSkin.mcPreloadAnim._visible = (mcSkin.mcPreloadAnim.nVisibleDelay++ > 24);
		// if we have to put up the preloader, hide the clip
		mcSkin.mcClip._visible = !mcSkin.mcPreloadAnim._visible;
		mcSkin.mcPreloadAnim.updateBar(nPercent);*/
	}
	
	public function preloadComplete(){
		//Log.status("preloadComplete()", this.toString());
		/*var mcSkin = Server.getController("clipPlayer").mcSkin
		mcSkin.mcPreloadAnim._visible = false;
		//ClipUtils.pause(mcSkin.mcPreloadAnim);
		mcSkin.mcClip._visible = true;*/
	}
	/*
	// old code for working with old ILEINCLUDES remove when new preloader/cliplayer is working
	
	// broadcasted from skin.as when it's gone idle
	public function onSkinIdle(){
		if(!this.bPostSkinInit){
			this.bPostSkinInit = true;
			this.postSkinInit();
		}
	}
	public function addToLoadQueue(oLoad:Object, fCallBack:Function, oScope:Object) {
		_global.ILE.Preloader.queue(oLoad, fCallBack, oScope)
	}
	public function postSkinInit() {
		//Log.status("Loading Assests", this.toString());
		_global.ILE.Preloader.runQueue(this.postSkinInitComplete, this);
	}
	public function postSkinInitComplete(){
		// send out a message on the server for all listening components to let anybody listening that the gui is ready
		Server.notify(AppEvents.GUI_READY);
	}*/
	public function updatePlayPauseState(){
		//Log.status("updatePlayPauseState()", this.toString());
		var toFocus:String = "none";
		if(State.bPaused){
			// paused
			//Log.status("\tpaused\n\tState.bPaused: "+State.bPaused, this.toString());
			this.enableControl("play");
			this.disableControl("pause");
			this.togglePausePlay(true);
			toFocus = "play"
			
		}else if(Server.getFlagCount() == 0){
			// all things done
			this.disableControl("play");
			this.disableControl("pause");
			this.togglePausePlay(false);
		}else{
			this.enableControl("pause");
			this.disableControl("play");
			this.togglePausePlay(false);
			toFocus = "pause";
		}
		AccessManager.update();
		if(toFocus != "none") Selection.setFocus(getControl(toFocus));
	}
	public function togglePausePlay(b:Boolean) {
		//Log.status("togglePausePlay("+b+")", this.toString());
		var nPlayDepth:Number = this.getControl("play").getDepth();
		var nPauseDepth:Number = this.getControl("pause").getDepth();
		if(b) {
			//Log.status("\tPlay Button should be on top");
			if(nPlayDepth < nPauseDepth) {
				this.getControl("play").swapDepths(this.getControl("pause"));
			}
		}else{
			//Log.status("Pause Button should be on top", this.toString());
			if(nPauseDepth < nPlayDepth) {
				this.getControl("pause").swapDepths(this.getControl("play"));
			}
		}
	}
	//  ---------------------------------------------------------------------------------------------------  //     
	//										Runtime Controls												 //
	//  ---------------------------------------------------------------------------------------------------  //	
	//
	public function onLastSegEnd() {
		this.getControl("exit").hide();
		this.resetControl("next");
	}
	public function refresh() {
		this.resetControl("next");
		this.enableControl("next");
		_global.ILE.Preloader.resetQueue();
		
		// Pause the preload animation if it's not being seen
		if(!Server.getController("clipPlayer").mcSkin.mcPreloadAnim._visible) {
			//ClipUtils.pause(Server.getController("clipPlayer").mcSkin.mcPreloadAnim);
		}
		Server.getController("templates").refresh()
		// reset the next button
		this.resetControl("next");
		GarbageCollection.destroy();
	}
	public function update(){
		// update pause play state
		this.updatePlayPauseState();
		// set the tab
		this.setTab()
	}
	public function setTab() {
		// do not bother if there is no tab group
		//trace("SET TAB BEING CALLED");
		if(this.lTabSets.getCount() == 0) {
			return;
		}
		var args     = Server.model.args;
		// need to refactor this
		var sTab:String = Configs.getConfig("sDefaultTab");
		if (State.bFirstSegInClip){
			// get the title tab if there is one
			var sTitleTab = Configs.getConfig("sTitleTab");
			if((sTitleTab == undefined) || (sTitleTab != "none")) {
				sTab = sTitleTab;
			}
		}
		// if we have overridden the tab in the args always use that one
		sTab = (args.sTab == undefined) ? sTab : args.sTab;
		// if we have found a tab to select do it
		if((sTab != undefined) && (sTab != "none")) {
			this.selectTab(sTab);
		}
	}
	public function showInstructions(sInstructions:String) {
		//Log.info("Add Instructions: "+sInstructions, this.toString());
		var args = Server.model.args;
		var sSkin = (args.sInstructionsSkin == undefined) ? "instructions" : args.sInstructionsSkin
		var sInstructionsLabel = (args.sInstructionsLabel == undefined) ? Labels.getLabel("continue") : args.sInstructionsLabel;
		Server.getController("templates").doAlert(sSkin, sInstructions, sInstructionsLabel);
	}
	
	public function toString() {
		return "enspire.ile.GuiController";
	}
}