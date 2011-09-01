/*
	Class: Server
	is a static class that acts as a holder for various controllers that make up an Enspire/ILE application
	to provide a central place to gather references to app, gui, popups, ect..
*/
import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
import org.asapframework.util.ArrayUtils;
import org.asapframework.events.notificationcenter.NotificationCenter;
//
import enspire.core.CommandLibrary;
import enspire.audio.SoundManager;
import enspire.model.XMLLibrary;
import enspire.model.IUserData;
import enspire.model.ICourseModel;
import enspire.ile.AppEvents;
import enspire.utils.ConstructorUtil;
import enspire.model.Configs;

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;

// new loader
import enspire.loader.Preloader;
import enspire.loader.PreloaderEvent;
//
class enspire.core.Server{
	
	private static var oModel:ICourseModel
	/*	Var: aFlags
		array to hold all the flags for segment completion*/
	private static var aFlags:Array = new Array();
	/*	Var: userdata
		object that implements IUserData. To get this object call Server.user*/
	private static var userdata:IUserData;
	/*	Var: communicator
		ASAP NotificationCenter of the Event Handleing Model*/
	private static var communicator:NotificationCenter = NotificationCenter.getDefaultCenter();
	/*	Var: commands
		a CommandLibrary library to hold application commands*/
	public static var commands:CommandLibrary = new CommandLibrary("server");
	/*	Var: overrides
		a CommandLibrary library to hold override commands*/
	public static var overrides:CommandLibrary = new CommandLibrary("overrides");
	/*	Var: textStyle
		reference to a TextField StyleSheet loaded by application*/
	public static var textStyle:TextField.StyleSheet = new TextField.StyleSheet();
	/*	Var: xmls
		xml library to hold all xml data loaded into application*/
	public static var xmls:XMLLibrary = new XMLLibrary();
	
	public static var sounds:SoundManager = new SoundManager();
	
	public static var loader:Preloader = new Preloader();
	
	/* 
		Var: lControllers 
		a org.asapframework.data.KeyValueList used to store controllers as name/value pairs
	*/
	private static var lControllers:KeyValueList = new KeyValueList();
	/*
		Function: addController
		adds a controller to the lControllers
		
		Parameters:
			sName  -  name id of the controller
			controller - untyped controller
			fController - function(class) for the controller to take if it does not allreay have one
	*/
	public static function addController(sName:String, controller, fController:Function) : Void{
		if(fController != undefined) {
			//Log.info("addController: "+sName+" Making CLASS", "enspire.core.Server");
			var newController = ConstructorUtil.createVisualInstance(controller, fController)
			lControllers.addValueForKey(newController, sName);
		}else{
			lControllers.addValueForKey(controller, sName);
		}
		
		//Log.info("Controller: "+sName+" added", "enspire.core.Server");
	}
	
	/*
		Function: getController
		used to get a refernce to a controller
		
		Parameters:
			sName  -  name id of the controller
			
		Returns: 
			untyped controller or undefined if controller has not been added or has been removed
	*/
	public static function getController(sName:String)  {
		var controller =  lControllers.getValueForKey(sName);
		return controller;
	}
	/*
		Function: hasController
		check to see if a controller exsists
		
		Parameters:
			sName  -  name id of the controller
			
		Returns: 
			true or false
	*/ 
	public static function hasController(sName:String) : Boolean  {
		return (lControllers.getValueForKey(sName) != undefined);
	}
	/*
		Function: removeController
		used to remove controller from library
		
		Parameters:
			sName  -  name id of the controller
	*/
	public static function removeController(sName:String) : Void {
		lControllers.removeValueForKey(sName);
	}
	/*
		Function: getControllerIds
		get an array of all the controller ids
	*/		
	public static function getControllerIds() : Array{
		var ctrls = lControllers.getArray();
		var a = new Array();
		for(var i=0; i < ctrls.length; i++) {
			a.push(ctrls[i].key);
		}
		return a;
	}
	public static function set model(oMod:ICourseModel) {
		oModel = oMod;
	}
	/*
		Function: model
		returns refernce to the model
	*/
	public static function get model() {
		return oModel;
	}
	/*
		Function: run
		change in ILE 1.6.8 use this instead of commands.runCommand so that the RUN_CMD notification goes out
		
		Parameters:
			sCmd  -  string name of the cmd that has been run
	*/
	public static function run(sCmd:String) {
		// check for an over ride 
		if(overrides.hasCommand(sCmd)) {
			overrides.runCommand(sCmd);
		}else{
			commands.runCommand(sCmd);
		}
		notify(AppEvents.RUN_CMD, sCmd);
	}
	
	public static function clearOverrides() {
		//trace("CLEAR OVERRIDES");
		overrides.clearCommands();
	}
	
	/*
		Group:Communications
	
		Function: connect
		adds listener to the NotificationCenter
	*/
	public static function connect(inObserver:Object, inMethodName:String, inNotificationName:String) {
		communicator.addObserver(inObserver, inMethodName, inNotificationName);
	}
	/*
		Function: disconnect
		removes listener from the NotificationCenter
	*/
	public static function disconnect(inObserver:Object, inNotificationName:String) {
		communicator.removeObserver(inObserver, inNotificationName);
	}
	/*
		Function: notify
		sends notify event to all connected objects
	*/
	public static function notify(inNotificationName:String, inData:Object) {
		//Log.status("Server notify: "+inNotificationName, "enspire.core.Server");
		communicator.post(inNotificationName, null, inData);
	}
	
	/*
		Group:Completion Flags
	
		Function: clearFlags
		removes all flags
	*/
	public static function clearFlags() {
		aFlags = new Array();
	}
	/*
		Function: addFlag
		adds a flag to the server, used to determine if a segment has ended
		
		Parameters:
			sFlag  -  name of flag
	*/
	public static function addFlag(sFlag:String) {
		//Log.status("add flag: "+sFlag, "enspire.core.Server");
		aFlags.push(sFlag);
	}
	/*
		Function: removeFlag
		removes a flag from the server, do not use this use onEndElement in the AppController
		
		Parameters:
			sFlag  -  name of flag
	*/
	public static function removeFlag(sFlag:String) {
		//Log.status("remove flag: "+sFlag, "enspire.core.Server");
		ArrayUtils.removeElement(aFlags, sFlag);
	}
	/*
		Function: getFlagCount
		returns the number of flags current in the flag array
	*/
	public static function getFlagCount() {
		//Log.info("get flag count: "+aFlags.length+", flags: "+aFlags, "enspire.core.Server");
		return aFlags.length;
	}
	/*
		Group:User Managment
	
		Function: setUserdata
		adds a IUserData object to the server
		
		Parameters:
			ud  -  an IUserData
	*/
	public static function setUserdata(ud:IUserData) {
		userdata = ud;
	}
	/*
		Function: user
		retruns reference to a IUserData object
	*/
	public static function get user() {
		return userdata
	}
	/*	
		Group: convience getters
		Function: getControl
		gets a control from the gui
		
		Parameters:
			sName  -  name of the control
	*/
	public static function getControl(sName:String) {
		return getController("gui").getControl(sName);
	}
	public static function makeControl(mc:MovieClip) {
		
	}
	/*	
		Function: getPanel
		gets a panel from the gui
		
		Parameters:
			sName  -  name of the panel
	*/
	public static function getPanel(sName:String) {
        return getController("gui").getPanel(sName);
    }
	/*	
		Function: getUrl
		launches url for reources in a new window or tab 
		
		Parameters:
			sUrl  -  the url to open
	*/
	public static function getUrl(sUrl:String) {
		getURL(sUrl, "_blank");
	}
	/*	
		Function: redirect
		redirects away from the course, this will replace this movie with the url
		
		Parameters:
			sUrl  -  the url to open
	*/
	public static function redirect(sUrl:String) {
		getURL(sUrl);
	}
	/*	
		Function: launchJsPopup
		launches javascript popup
		
		
		Parameters:
			sUrl  -  the url to open 
			nHeight - uses config nJsPopupHeight
			nWidth - uses config nJsPopupWidth
		
	*/
	public static function launchJsPopup(sUrl:String, nHeight:Number, nWidth:Number) {
		var nWidth = nWidth == undefined ? Configs.getConfig("nJsPopupWidth") : nWidth;
		var nHeight = nHeight == undefined ? Configs.getConfig("nJsPopupHeight") : nHeight;
		//ExternalInterface.call("launchPopup", nHeight, nWidth);
	}
	
	
	//508
	public static function makeAccess(oItem, sText:String, sDesc:String) {
		return AccessManager.addItem("content", oItem, sText, sDesc);
	}
}