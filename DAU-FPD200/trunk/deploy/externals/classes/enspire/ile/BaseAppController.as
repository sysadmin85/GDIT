/*	Class: BaseAppController
	is a base class to use for all enspire applications, extend this class to gain basic enspire functionality like IFT, pause/play functionallity, also sets up the Fuse Tweening Engine
*/
// third party classes ASAP and FUSE
import org.asapframework.util.debug.Log;
import com.mosesSupposes.fuse.*;
// flash classes
import mx.events.EventDispatcher;
import mx.utils.Delegate;
// enspire classes
import enspire.core.Server;
import enspire.core.VersionInfo;
import enspire.audio.SoundManager;
//
import enspire.debug.ConsoleWindow;
//
import enspire.model.Configs;
import enspire.model.State;
import enspire.model.Globals;
import enspire.model.Labels;
import enspire.model.CourseModel;
import enspire.model.ICourseModel;
import enspire.model.Resources;
import enspire.utils.ClipUtils;
import enspire.lms.LMSCommands;
import enspire.debug.ConsoleManager;

//
import enspire.utils.UrlUtils;
//
// -------------------------------------------------------------------------------- Class Start
class enspire.ile.BaseAppController{
	
	/*	Group: Private Static Vars
	
		Var: BASE_DEPTH
		static depth for the gui/base holder*/
	private static var BASE_DEPTH:Number = 10000;
	/*	Var: IFT_DEPTH
		static depth for the IFT
	*/
	private static var IFT_DEPTH:Number = 60000;
	/*	
		Group: Private Vars
	
		Var: mcTimeline 
		a reference to the main timeline of the application, this typicly will be the root of ile.fla but could be else where*/
	private var mcTimeline:MovieClip;
	
	/*	Var: appStyle
		a reference to a StylesSheet object for the application to provide graeter HTMLText support*/
	private var appStyle:TextField.StyleSheet;
	/*	Var: bConfigs
		a Boolean to tell if the application configs have been loaded and parsed*/
	private var bConfigs:Boolean;
	/*	Var: base
		a reference to the base movieclip. this is not the GUI just the main timeline of the base.swf*/
	private var base:MovieClip;
	/*	Var: console
		this is a Debug console*/
	private var console:ConsoleWindow;
	private var hUrlParams:String;
	private var sLocation:String;
	private var bDeployed:Boolean;
	private var bLocal:Boolean;
	private var sBaseUrl:Boolean;
	private var sounds:SoundManager;
	
	
	/*	
		Group: Public Vars
		
		Var: model
		a Model object for our application
	*/
	public var model:CourseModel;
	/*	Var: onInitContentLoaded
		a User defined funtion called after the initial load queue has run, use this to alter the default behavior of the course
	*/
	public var onInitContentLoaded:Function;
	
	/*  Group: Constructor
		
		Function: BaseAppController
		Constructor for the Base Application Controller, sets up Fuse Tweening, Pause/Play Prototyping, makes a holder for the IFT if one does not exsist, creates holder for the Base
		
		Parameters:
			inTimeline  -  required reference to the timeline that is the root of your application
	*/
	private function BaseAppController(inTimeline:MovieClip) {
		//Log.status("Application init", this.toString());
		this.mcTimeline = inTimeline;
		// do the FUSE tweening set up
		ZigoEngine.simpleSetup(Shortcuts, Fuse, PennerEasing);
		ZigoEngine.OUTPUT_LEVEL = 3;
		//
		this.bConfigs = false;
		
		// get referenc to our sound manager
		this.sounds = Server.sounds;
		//
		ClipUtils.doPrototyping();
		this.setUrlParams();
		this.makeIFTHolder();
		this.createBase();

		
		
		
		
		// create some global references for multimedia use
		_global.Configs   = Configs;
		_global.State     = State;
		//_global.Globals   = Globals;
		_global.Server    = Server;
		_global.Labels    = Labels;
		_global.Resources = Resources;
		
	}
	/* Group: Setup Functions
	
		Function: loadConfigs
		Loads configs.xml
			
		Parameters:
			sPath  - string path to the config xml document
	*/
	public function loadConfigs(sPath:String) {
		//Log.status("Loading Configs", this.toString());
		var configsXml = Server.xmls.createXml("configs");
		
		configsXml.onLoad = Delegate.create(this, onConfigsLoaded);
		configsXml.load(sPath);
	}
	/*	Function: onConfigsLoaded
		Called when configs finish loading and calls Configs.parse() and calls setInitAppState 
	*/
	public function onConfigsLoaded() {
		//Log.status("Configs Loaded", this.toString());
		if(this.bConfigs) {
			return;
		}
		////trace("CONFIG LOAD: "+Server.xmls.getXml("configs"));
		Configs.parseConfigs(Server.xmls.getXml("configs", true));
		this.bConfigs = true;
		this.setInitAppState();
	}
	/*	Function: setInitAppState
		empty function meant to be overridden in sub classes
	*/
	public function setInitAppState() {
	
	}
	/*	Function: loadStyles
		loads css style sheet
			
		Parameters:
			sPath  - string path to the config xml document
	*/
	public function loadStyles(sPath:String) {
		
		Server.textStyle.load(sPath);
		//this.appStyle.onLoad = Delegate.create(this, onStylesLoaded);
	}
	/*	Function: onStylesLoaded
		logs all the current style names
	*/
	public function dumpStyles() {
		var s:String = "\n---------------  Start Style Dump  -----------------\n\t"
		s += Server.textStyle.getStyleNames().join("\n\t");
		s += "\n---------------   End Style Dump   -----------------\n\t"
		//Log.info(s, this.toString());
	}
	/*	Function: startApp
		empty function to be over written in sub class
	*/
	public function startApp() {
		
	}
	/* Group: Utility Functions
	
		Function: createBase
		creates an empty clip for the base to be loaded into, probably need to add a boolean tp this calss to make sure the base clip is never over written
	*/
	public function createBase() {
		this.base = this.mcTimeline.createEmptyMovieClip("mcBase", BASE_DEPTH);
	}
	/*	Function: getBase
		returns path to the timeline of the GUI/Base
	*/
	public function getBase() {
		return this.base;
	}
	/*	Function: getTimeline
		returns path to main application timeline
	*/
	public function getTimeline() {
		return this.mcTimeline;
	}
	/*	Function: baseUrl
		returns base url as parsed from _root.url
	*/
	public function get baseUrl() {
		return this.sBaseUrl;
	}
	/*	Function: makeIFTHolder
		makes a holder clip for the IFT 
	*/
	private function makeIFTHolder() {
		// make a clip for the IFT and shunt it up to a really high depth
		if(!this.mcTimeline.mcIFT){
			this.mcTimeline.createEmptyMovieClip("mcIFT", IFT_DEPTH);
		}else{
			this.mcTimeline.mcIFT.swapDepths(IFT_DEPTH);
		}
	}
	/*	Function: setModel
		sets the model object for the application to use 
			
		Parameters:
		cModel  - a model object make sure your model class extends CourseModel
	*/
	public function setModel(cModel:CourseModel) {
		if(!(cModel instanceof CourseModel)) {
			//Log.error("Model does not extend CourseModel", this.toString());
			return;
		}
		this.model = cModel
	}
	/*	Function: initIFT
		checks the xml library of the model to see if there is an ift.xml ( project id ) and calls init of IFT.swf
	*/
	public function initIFT() {
		if(Server.xmls.hasXml("ift")) {
			_global.IFT.init(Server.xmls.getXml("ift", true));
		}
	}
	/*	Function: setUrlParams
		sets the base url for the application from _root._url
		need to move this ito the server
	*/
	private function setUrlParams() {
		var _url = _root._url;
		// obtain params passed in through url
		this.hUrlParams = UrlUtils.parseUrlParams(_url);
		this.sLocation = UrlUtils.getLocation(_url);
		this.bDeployed = ((this.sLocation == "remote") && (_url.indexOf("enspire.com") == -1));
		this.bLocal = ((this.sLocation == "remote") && (_url.indexOf("enspire.com") != -1));
		// calculate sBaseUrl for use in the preloader
		// if there were query parameters, get rid of them during this calculation
		var temp = UrlUtils.stripUrlOfQueryString(_url)
		// strip off the trailing filename, i.e. ile.swf
		this.sBaseUrl = temp.substring(0, temp.lastIndexOf("/")+1);
	}
	/*	Function: attachDebugConsole
		adds a debug console to the application, requires the console clip in the library with a linkage name of console
		make sure to call console.showConsole() it is hidden by defualt
	*/
	private function attachDebugConsoles(sConsoles:String) : Void {
		//this.console = ConsoleWindow(this.mcTimeline.attachMovie("console", "mcConsole", CONSOLE_DEPTH));
		ConsoleManager.init(sConsoles, this.mcTimeline);
	}
	/*	Function: gotoLabel
		moves mcTimeline to the frame with specified label
	*/
	public function gotoLabel(sLabel:String) : Void {
		this.mcTimeline.gotoAndStop(sLabel);
	}
	public function getBookmark() {
		var sData:String;
		var sLMSBookmark = Configs.getConfig("sLMSBookmark")
		if(sLMSBookmark == "lms") {
			sData = _root.sData;
		}else if(sLMSBookmark == "cookie") {
			var oSO = SharedObject.getLocal(Configs.getConfig("sCookieId"), "/");
			sData = oSO.data.sData;
		}
		return sData;
	}
	public function setBookmark(sBookmark:String) {
		if(sBookmark == undefined) {
			//Log.error("Bookmark Undefined", this.toString());
			return;
		}
		var sMark = Configs.getConfig("sLMSBookmark")
		if(sMark == "lms") {
			LMSCommands.setBookmark( Server.user.getBookmark() );
		}else if(sMark == "cookie") {
			var oSO = SharedObject.getLocal(Configs.getConfig("sCookieId"), "/");
			oSO.data.sData = sBookmark;
		}
		
	}
	/*	Function: toString
		returns "enspire.ile.BaseAppController";
	*/
	public function toString() : String {
		return "enspire.ile.BaseAppController";
	}
	
}