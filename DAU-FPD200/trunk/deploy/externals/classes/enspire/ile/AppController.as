/*	Class: AppController
	ILE 1.6 main controller class,takes place of ILE_Controller in ILE 1.5
*/
// fuse tweening library
import com.mosesSupposes.fuse.*;
// third party classes
import org.asapframework.util.debug.Log;
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import org.asapframework.util.StringUtilsTrim;
import org.asapframework.util.FrameDelay;
// ile classes
import enspire.accessibility.AccessManager;
import enspire.core.Server;
import enspire.ile.BaseAppController;
import enspire.ile.IleEvent;
import enspire.lms.LMSCommands;
import enspire.model.Configs;
import enspire.model.State;
import enspire.model.IleModel;
import enspire.model.Labels;
import enspire.utils.ILE_utils;
import enspire.utils.GarbageCollection;
import enspire.model.LimitedStack;
import enspire.ile.AppEvents;
import enspire.ile.InteractivityController;

// new loader
import enspire.loader.Preloader;
import enspire.loader.PreloaderEvent;



class enspire.ile.AppController extends BaseAppController{
	/*  Group: Private Static Vars
	
		Var: my_ILE
		private static var to hold the singleton instance of this class
	*/
	private static var my_ILE:AppController;
	
	// do not need any more
	/*	Var: nStartChapter
		the statrting chapter of an ILE application, default is 0 
	
	public var nStartChapter:Number;
	/*	Var: nStartSection
		the statrting section of an ILE application, default is 0 
	
	public var nStartSection:Number;
	/*	Var: nStartClip
		the statrting clip of an ILE application, default is 0 

	public var nStartClip:Number;
	/*	Var: nStartSeg
		the statrting segment of an ILE application, default is 0 
	*/
	public var nStartSeg:Number;
	
	private var backStack:LimitedStack; 
	
	
	/*  Group: Constructor  
		
		Function: AppController
		Singleton, sets up Fuse Tweening, Pause/Play Prototyping, makes a holder for the IFT if one does not exsist, creates holder for the Base
		
		Parameters:
			inTimeline  -  required reference to the timeline that is the root of your application
	*/
	private function AppController(inTimeline:MovieClip) {
		super(inTimeline)
		// add this controller to the Server
		Server.addController("app", this);
		//do not need this anymore
		/*this.nStartChapter = 0;
		this.nStartSection = 0;
		this.nStartClip = 0;*/
		this.nStartSeg = 0;
		//
		this.loadStyles("css/app.css");
		
		Server.loader.addEventListener(PreloaderEvent.ON_LOAD_START,  this);
		Server.loader.addEventListener(PreloaderEvent.ON_LOAD_PROGRESS,  this);
		Server.loader.addEventListener(PreloaderEvent.ON_LOADED,  this);
		Server.loader.addEventListener(PreloaderEvent.ON_LOAD_ERROR,  this);
		Server.loader.addEventListener(PreloaderEvent.ON_ALL_LOADED,  this);
		
		

		//
	}
	/*	Function: getInstance
		returns an instance to the main application controller, you must call init on this class before getInstance can be used otherwise it will throw an error
	*/
	public static function getInstance() : AppController {
		if(my_ILE == undefined) {
			//Log.status("\nERROR: ILE must be initilized with this function: ILE.init(this);\n");
			return;
		}
		return my_ILE;
	}
	/* 	Function: init
		initilizes the singelton instance of this class must be called before anything else
		
		Parameters:
			inTimeline  -  required reference to the timeline that is the root of your application
	*/
	public static function init(inTimeline:MovieClip) : AppController {
		if(inTimeline == undefined) {
			//Log.status("\nERROR: you must include a refernece to the main timeline to this function\n\ti.e. ILE.init(this);\n", "ILE_controller");
			return;
		}
		my_ILE = new AppController(inTimeline);
		return my_ILE;
	}
	/*	Group: Setup functions
		
		Function: setInitAppState 
		sets various application state starting variables
	*/
	private function setInitAppState() : Void {
		//trace("\n\nConfigs: "+Configs.toDump());
		
		
		State.bAudio = Configs.getConfig("bAudio");
		State.bMute = !State.bAudio;
		State.bAutoplay = (Configs.getConfig("bAutoplay") == true);
		//
		State.sRelease = Configs.getConfig("sRelease");
		State.bFinal = (State.sRelease == "final");
		State.bAccessible = (Configs.getConfig("bAccessible") == true);
		// if we have accessibilty 
		if(State.bAccessible) {
			AccessManager.doProto();
			AccessManager.setGroupOrder(Configs.getConfig("aReadOrder"));
			AccessManager.createGroup("gui", true);
		}
		// do defult sound stuff
		if(Configs.getConfig("sSoundDir") != undefined) {
			this.sounds.setSoundDirectory(Configs.getConfig("sSoundDir"));
		}
		if(Configs.getConfig("sSoundFxDir") != undefined) {
			this.sounds.setFxDirectory(Configs.getConfig("sSoundFxDir"));
		}
		if(!isNaN(Configs.getConfig("nSoundVol"))) {
			this.sounds.setVolume(Configs.getConfig("nSoundVol"));
		}
		// only do IFT if we are on our servers
		State.bIFT = ((Configs.getConfig("bIFT") == true) && (this.bLocal));
		
		if(!State.bIFT) {
			this.mcTimeline.mcIFT._visible = false;
		}
		
		State.bLMS = ((Configs.getConfig("bLMS") ==  true) && (System.capabilities.playerType != "StandAlone"));
		// see if we need to attach any of the debug consoles
		if((Configs.getConfig("sConsole") != "") && (Configs.getConfig("sConsole") != undefined) && (!State.bFinal)) {
			
			this.attachDebugConsoles(Configs.getConfig("sConsole"));
			
		}
		
		// connect to listen for the gui being ready to go
		Server.connect(this, "startApp", AppEvents.GUI_READY);
		
		this.backStack = new LimitedStack(Configs.getConfig("nStackLimit"));
		resetState();
		
		//Log.info(ILE_utils.getVersionInfo(), this.toString());
		this.dumpStyles();
		//Log.info(Configs.toDump(), this.toString());;
		
		this.gotoLabel("setup");
	}
	/*	Function: onContentLoaded
		called from IleWrapper, if load is finished call onInitContentLoaded which should be defined in setup/ileSetup.as
		
		Parameters:
			nPercent  -  updates preloader animation
			bFinished - says if load queue is finished
	*/
	public function onContentLoaded(nPercent:Number, bFinished:Boolean) : Void {
		this.mcTimeline.mcPreloadAnim.updateBar(nPercent);
		if(bFinished){
			this.onInitContentLoaded();
		}
	}
	/*	Function: loadIle
		used to load ILE includesnow just calls next frame on the main timeline
	*/
	private function loadIle() : Void {
		this.mcTimeline.nextFrame();
	}
	/* 	Group: Application Control Logic Functions
		
		Function: runILE
		this is a little confusing because this does not start the app it just sets the timeline to the run frame and starts the background load queue and starts the IFT if we are using one
	*/
	public function runILE() : Void {
		//Log.status("Start Base", this.toString());
		this.base.gotoAndStop("run");
		this.base._visible = true;
		// if we an IFT lets give it its number
		if(State.bIFT){
			this.initIFT();
		}
		// get an array of clips for preload
		//var aPreloadClips:Array = ILE_utils.getPreloadClips();
		//_global.ILE.Preloader.preload( aPreloadClips );
		//
		////Log.info("Queueing " + aPreloadClips.length + " for background load.", this.toString());
	}
	/*	Function: startApp
		
		this starts the application and is called when gui is done loading all of its stuff
	*/
	public function startApp() : Void {
		// set the init time
		State.startTime = new Date();
		
		/*// set lms started if we are doing lms
		if(State.bLMS) {
			LMSCommands.setStarted();
		}*/
		
		// disable mute and auto advance if there is no audio (state is set from bAudio) config
		if(!State.bAudio) {
			var gui = Server.getController("gui")
			gui.disableControl("autoplay");
			gui.disableControl("mute")
		}
		
		
		
		//Log.status( "\n------------------------------    Application start    ------------------------------\n" , this.toString());
		var segData = this.gotoIndex(this.nStartSeg);
		
		Server.notify(AppEvents.START_APP, segData);
		
		/* INTEGRATE - not sure if this is really the right place for this */
		setupInteractivity();
		
	}
	/* INTEGRATE */
	public function setupInteractivity() {
		var gui = Server.getController("gui");
		var INTERACTIVITY_API = gui.getContainer("interactivity").getClip().API;
		Server["INTERACTIVITY_API"] = INTERACTIVITY_API;
		INTERACTIVITY_API.addInteractivityListener(InteractivityController.getInstance());
		INTERACTIVITY_API.setLabels(Labels);
	}
	
	public function startSegment(sSegId:String) {
		
		var sLookup = State.sChapterId+"_"+State.sSectionId+"_"+State.sClipId+"_"+sSegId;
		//trace("START SEGMENT: "+sLookup);
		this.gotoIndex(Server.model.structure.getSegmentById(sLookup).nAbsoluteIndex)
	}
	/*  Group: Navigation
	
	*/
	public function gotoIndex(n:Number) {
		trace("gotoIndex: "+n);
		var segData = Server.model.getSegData(n);
		
		//trace("GET OLD SEG DATA: "+State.nAbsoluteIndex);
		var oldSeg = Server.model.getSegData(State.nAbsoluteIndex);
		
		
		if(segData == undefined) {
			//Log.error("Undefined Seg Called", this.toString());
			return;
		}
		// check to see if we are in the middle of a load
		
		Server.loader.stopLoadAndClear();
		
		
		if(segData.chapter.nChapIndex != oldSeg.nChapIndex) {
			this.onBeforeStartChapter(segData);
		}
		if(segData.section.nSectIndex != oldSeg.nSectIndex) {
			this.onBeforeStartSection(segData);
		}
		//trace("CHECK FOR LOAD CLIP: \nsegData.clip.nClipIndex:"+segData.clip.nClipIndex+"\noldSeg.nClipIndex: "+oldSeg.nClipIndex);
		
		if(segData.clip.nClipIndex != oldSeg.clip.nClipIndex) {
			this.onBeforeStartClip(segData);
		}
		this.onBeforeStartSeg(segData);
		
		trace("SETTING segData.nAbsoluteIndex: "+segData.nAbsoluteIndex);
		
		State.nAbsoluteIndex = segData.nAbsoluteIndex;
		
		//trace("ABSOLUTE INDEX: "+State.nAbsoluteIndex);
		
		if(Server.loader.getQueueLength() > 0) {
			// just call in after start seg in a frame
			State.appState = "segLoad";
			Server.loader.runQueue();
		}else{
			//just pause a frame for init
			var fd = new FrameDelay(this, onAfterStartSeg);
		}
		
		return segData;
	}
	/* Group: Before Action Functions
		Use these functions to add to the load queue
		
	*/
	private function onBeforeStartChapter() {
		
	}
	private function onBeforeStartSection() {
		
	}
	private function onBeforeStartClip( segData) {
		//trace("TO LOAD CLIPDATA: "+segData.clip.toString());
		State.bLoadingClip = true;
		Server.loader.addToQueue(segData.clip.url, Server.getController("gui").getContainer("clipPlayer").getClip());
	
		//_global.ILE.Preloader.preload([{url: clipData.url, target: Server.getController("gui").getContainer("clipPlayer")}], this.onLoadComplete, this);
	}
	public function onBeforeStartSeg(segData){
		//Log.status("onBeforeStartSeg()", this.toString());
		GarbageCollection.destroy();
		Server.model.setGlobalLocation(segData.nAbsoluteIndex);
		
		// until we have a clipplayer object just do it manually
		this.startSegAudio();
		State.sAccGroup = undefined;
		Server.clearFlags(); 
		Server.clearOverrides();
	}
	
	/*	
		Function: onAfterStartClip
		need to rework updateBackgroundPreload I do not think this is even being called right now
	*/
	public function onAfterStartClip(){
		//Log.status("onAfterStartClip", this.toString());
		//ILE_utils.updateBackgroundPreload();
	}
	/*	Function: onAfterStartSeg
		this is where the magic happens, called from IleIncludes vie IleWrapper this function was located in GuiController in ILE 1.5
	*/
	public function onAfterStartSeg() : Void {
		var mcClip = Server.getController("gui").getContainer("clipPlayer").getClip();
		mcClip.endSeg = function() {
			Server.getController("app").onEndElement("seg");
		}
		mcClip.gotoAndPlay(State.sSegmentId);
		// set location and completion
				
		// move funtion from utils to app controller
		ILE_utils.setCurrentSegComplete();

		trace("\n----------------------- Seg " + ILE_utils.getLocationAsString() +  " Started --------------------------\n");
		
		// get convience args
		var gui       = Server.getController("gui");
		var nav       = Server.getController("nav");
		var activity  = Server.getController("activities");
		var templates = Server.getController("templates");
		var args      = Server.model.args;
		var seg       = Server.model.seg;
		
		// set app state
		State.appState = "segPlay";
		
		// refesh AccessManager if we are accessible, and recreate the content readgroup
		if(State.bAccessible) {
			AccessManager.refresh();
			AccessManager.createGroup("content");
			AccessManager.createGroup("alert");
		}	
		
		// remove all server flags and clearGuiOverrides
		Server.clearFlags(); 
		Server.clearOverrides();
		
		// refresh gui and flush the templates to clear any lingering reference  
		gui.refresh();
		templates.flush();
		
		// clear state varibles from last seg
		this.resetState();
		
		// if we are running in the LMS then set BookMark need to refactor to be able to set Local Storage flash cookie from Configs
		if(State.bLMS) {
			LMSCommands.setElapsedTime();
		}
		
		// determine next buton state 
		if(State.bLastSeg) {
			this.onCourseEnd();
			gui.disableControl("next");
		}else if( (args.bDisableNext == "true") || ((seg.bBranchHead) && (!seg.getComplete()))  ){
			gui.disableControl("next");
		}else{
			gui.enableControl("next");
		}
		
		// determine back button state
		if((State.bFirstSeg) || (args.bDisableBack == "true")){
			gui.disableControl("back");
		}else{ 
			gui.enableControl("back");
		}
		
		// set our bookmark
		this.setBookmark( Server.user.getBookmark() );
		
		// update IFT
		this.updateIFT();
		
		// start audio
		if((State.bHasAudio) && ((args.noAudio != "true"))) {
			Server.addFlag("audio");
			Server.sounds.playClipSound("segAudio");
		}
		
		// check to see if this is an interactive segment
		State.bInteractive = ((args.sActivityType != undefined) || (args.bInteractive == "true"));
		var INTERACTIVITY_API = gui.getContainer("interactivity").getClip().API;
		INTERACTIVITY_API.destroyActivity();
		if(State.bInteractive) {
			var interactivityController = Server.getController("interactivity");
			var activityDelay = new FrameDelay(interactivityController, interactivityController.startInteractivity);
			//INTERACTIVITY_API.createActivity(args["activityType"], args, null, gui.getContainer("clipPlayer").getClip()["clip"]);
			State.sAccGroup = "content";
		}
		/* INTEGRATE
		if(args.sType != undefined) {
			activity.createInteractivity(args.sType, args.nDelay);
		}
		*/
		
		// split all our template args
		var aTemplates = args.sTemplate.split(",");
		var aDelays = args.sTemplateDelay.split(",");
		var aProfiles = args.sTemplateProfile.split(",");
		
		// loop through number of templates and get individual
		for(var i:Number = 0; i < aTemplates.length; i++) {
			var sTemp:String = StringUtilsTrim.trim(aTemplates[i]);
			var nTryDelay = parseInt(StringUtilsTrim.trim(aDelays[i]));
			var nDelay =  isNaN(nTryDelay) ? undefined : nTryDelay;
			var sProfile;
			if((aProfiles[i] != undefined) &&(StringUtilsTrim.trim(aProfiles[i]) != "")) {
				sProfile = StringUtilsTrim.trim(aProfiles[i]);
			}
			templates.createTemplate(sTemp, sProfile, nDelay);
		}
		
		// if we have a command run it
		if((args.sCommand != undefined) && (args.sCommand != "")) {
			Server.run(args.sCommand);
		}
		
		

		// init hot spots if we have any, this will fail if first hotspot is not numbered 0 or there are breaks in the numbering 0, 1, 3, 4
		Server.getController("templates").hotspots.makeHotSpots(args);
		
		// if we need to do splash
		if(args.sSplash) {
			Server.addFlag("splash");
			templates.createTemplate(args.sSplash);
		}else{
			// add a flag to track if we are done with segment (seg flag is called by endSeg())
			if(args.noSegFlag != "true") {
				Server.addFlag("seg");
			}
		}
		if(this.checkForFade()) {
			Server.getController("templates").doFade();
		}else{
			Server.getController("templates").hideFade();
		}
		
		// send out start notifications
		var sSeg = ILE_utils.getCurrentSeg();
		if(State.nSegment == 0) {
			if(State.nClip == 0) {
				Server.notify(AppEvents.START_SECT, sSeg);
			}
			Server.notify(AppEvents.START_CLIP, sSeg);
		}
		
		Server.notify(AppEvents.START_SEG, sSeg);
		
		// send out a message on the server for all listening components to let them know we have started a new seg
		

		// //trace all model and state elements
		//Log.info(Server.model.argsToString(), this.toString());
		//Log.info(ILE_utils.doStateDump(), this.toString());
		// do the instructions if needed
		if((args.sInstructions != undefined) && (args.sInstructions != "") && (args.bIgnoreInstructions != "true")) {
			State.sAccGroup = "content"
			gui.showInstructions(args.sInstructions);
			
		}
	}
	
	
	
	/*	Function: startSegAudio
		this is what starts audio on a segment
	*/
	public function startSegAudio() {
		// determine if this seg has audio
		
		trace("startSegAudio() ");
		
		Server.sounds.clearClipsSounds();
		
		var args = Server.model.args;
		
		
		if((!Configs.getConfig("bTitleAudio") && State.nSegment == 0) || args.noAudio == "true") {
			State.bHasAudio = false;
		}
		
		//if audio is not present, pretend it's already ended.
		State.bEndedAudio = (State.bAudio && State.bHasAudio) ? false : true;
		
		
		trace("(State.bAudio && State.bHasAudio && (args.noAudio != 'true')) = ("+State.bAudio+" && "+State.bHasAudio+" && ("+args.noAudio+" != 'true')");
		if (State.bAudio && State.bHasAudio && (args.noAudio != "true")) {
			var sSoundFile = State.sSectionId + "_" + State.sClipId + "_" + State.sSegmentId + ".swf";
			trace("ADDING CLIP SOUND: "+sSoundFile);
			Server.sounds.addClipSound("segAudio", sSoundFile, 100);
		}
	}
	/*	Function: onEndElement
		determines autoplay and pulse 
		
		Parrameters:
		sFlag - string name of flag to clear
	*/
	public function onEndElement(sFlag:String){
		
		trace("ONENDELEMENT: sFlag" + sFlag);
		var gui = Server.getController("gui");
		
		// remove the flag and check to see if all flags have been removed
	    Server.removeFlag(sFlag);
		if(Server.getFlagCount() != 0) {
			
			// check to see if we need to enable the interactivity after audio (to be implemented)
			if((sFlag == "audio") && (Configs.getConfig("bEnableAfterAudio")) && ((!Configs.getConfig("bDisableForSB")) && (State.sRelease != "storyboards"))) {
				// add code to activate interactivity
			}
			return;
			
		}
		if(State.bLastSeg) {
			gui.onLastSegEnd();
			gui.updatePlayPauseState();
			Server.notify(AppEvents.END_COURSE, "End");
			return;
		}
		
		Server.notify(AppEvents.END_SEG, ILE_utils.getLocationAsString());
		State.appState = "segEnded";
		gui.updatePlayPauseState();
		
		if(Server.model.getArg("bForceAdvance") == "true") {
			trace("FORCE ADVANCE");
			Server.run("next");
			//gui.getControl("next").onRelease()
		}else if(State.bAutoplay && !State.bInteractive && !State.bMute){
			// check to see if we have over ridden autoplay form the args
			if((Server.model.getArg("noAdvance") != "true")) {
				gui.getControl("next").onRelease();
			}
		}else{
			// check to see if we have over ridden next pulse from the args
			if((Configs.getConfig("bPulseNext")) && (Server.model.getArg("noPulse") != "true") && (!Server.model.seg.bBranchHead)) {
				gui.enableControl("next");
				gui.pulseControl("next");
			}
		}
		if(State.nSegment == (State.nTotalSegments - 1)) {
			if(State.nClip == (State.nTotalClips - 1)) {
				Server.notify(AppEvents.END_SECT, ILE_utils.getCurrentSeg());
			}
			Server.notify(AppEvents.END_CLIP, ILE_utils.getCurrentSeg());
		}
		
		
		
		//Log.status("\n--------------------    Segment Ended   -------------------------\n", this.toString());
	}
	/*	Function: onClose
		not sure when this fires off
	*/
	public function onClose(){
		//Log.status("onClose", this.toString());
		Server.getController("clipPlayer").mcClip._visible = false;
		//GarbageCollection.destroy();
	}
	/*	Function: onCourseEnd
		we are done with course so set LMS complete if we want to
		uses config: bLmsCompleteOnEnd (true/false)
	*/
	private function onCourseEnd() : Void {
		Log.status("\n--------------------------------- Application Exit ---------------------------------\n", this.toString());
		//if((State.bLMS) && (Configs.getConfig("bLmsCompleteOnEnd"))) {
			LMSCommands.setComplete();
			LMSCommands.commit();
		//}
	}
	/*	Function: updateIFT
		updates current location in the ift
		if nothing else is passed in then the current segment is used section id / clip id, segment id
		
		Parameters:
			sGlobalLocation  -  string location if nothing is passes in it defualts to current section id / clip id
			sSegment - segment id
	*/
	public function updateIFT(sGlobalLocation:String, sSegment:String) {
		if(!State.bIFT){
			return;
		}
		var sGlobal:String = (sGlobalLocation == undefined) ? State.sSectionId + "/" + State.sClipId  : sGlobalLocation;
		var sSeg:String = (sSegment == undefined) ? ILE_utils.padSegId(State.sSegmentId) : sSegment;
		_global.IFT.updateLocation(sGlobal, sSeg);
	}
	private function resetState() {

		State.bPaused = false;
		State.bHasAudio = true;
		State.bInteractive = false;
		State.bCourseEnd = false;
	}
	private function onLoadStart(e:PreloaderEvent) {
		//trace("LOAD STARTED");
		State.bLoading = true;
	}
	private function onLoadProgress(e:PreloaderEvent) {
		
	}
	private function  onLoaded(e:PreloaderEvent) {
		
	}
	private function  onLoadError(e:PreloaderEvent) {
		
	}
	
	private function  onAllLoaded(e:PreloaderEvent) {
		////trace("nAllLoaded "+State.appState);
		
		if(State.appState == "initLoad") {
			this.onInitContentLoaded();
			State.appState = "mediaLoad"
		}else if(State.appState == "mediaLoad") {
			this.startApp();
		}else if(State.appState == "segLoad") {
			State.bLoadingClip = false;
			this.onAfterStartSeg();
		}
		State.bLoading = false;
	}
	private function checkForFade() : Boolean{
		//trace("CHECKING FADE")
		//trace("FIRST CONDITION (not interactive) "+((Configs.getConfig("bFadeInSegs")) && (!State.bInteractive)));
		//trace("SECOND CONDITION (interactive) "+((Configs.getConfig("bFadeInActivity")) && (State.bInteractive)));
			  
		return ((((Configs.getConfig("bFadeInSegs")) && (!State.bInteractive)) || ((Configs.getConfig("bFadeInActivity")) && (State.bInteractive))) && (!Server.model.args.args.noFade));
	}
	public function bUseIft() {
		return ((State.bFinal != true) && (State.bIFT == true));
	}
	/*	Function: toString
		returns "enspire.ile.AppController"
	*/
	public function toString() : String {
		return "enspire.ile.AppController";
	}
}