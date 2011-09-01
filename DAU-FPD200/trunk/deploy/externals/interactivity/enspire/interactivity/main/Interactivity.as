import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;



/*
   Class: Interactivity
   This is the main API for dealing with the Interactivity package. A singleton
   instance of this class is generated when the swf is initially loaded. This instance 
   is the handle by which you will interact with the interactivity package.
   
   Example usage:
   
    (start code)
	// initializing the API
    var interactivity_API = interactivityHolder["API"];
	// register to listen for interactivity events
	interactivity_API.addInteractivityListener(this);
	
	// creating an interactivity
	API.createActivity(args["activityType"], args, profile, mcClip);

	//listening to interactivity events
	function notifyInteractivityEvent(e:InteractivityEvent) {
		if(e instanceof TemplatesEvent) {
			showTemplate(TemplateEvent(e).getTemplateText());
		} 
		if(e instanceof ScoreEvent) {
			recordScore(e);
		}
	}
	(end)
*/

class enspire.interactivity.main.Interactivity {
	
	public static var instance:Interactivity;
	public static var iTimeline:MovieClip;
	
	private var currentActivity:IActivity;
	private var listeners:Array;
	
	private var labels:Object;
	
	/* Constructor: Interactivity
       Should never be called by any code outside of this class. Interactivity API exists as a singleton
	   that should be accessed by calling the static function <getInstance>
    */
	public function Interactivity() {
		listeners = new Array();
	}
	
	/* Constructor: getInstance
       Proper way to 
    */
	public static function getInstance() {
		if(instance == undefined) {
			instance = new Interactivity();
		}
		return instance;
	}
	
	public function createActivity(type:String, args:Object, profile:Object, clip:MovieClip) {
		trace("Creating type: " + type);
		var activity = InteractivityFactory.createActivity(type);
		addInteractivityListener(activity);
		currentActivity = activity;
		currentActivity.setActivityArgs(args);
		currentActivity.setActivityProfile(profile);
		currentActivity.setupActivityDisplay(clip);
		currentActivity.init();
	}
	
	public function resumeActivity():Void {
		trace("Interactivity.resumeActivity");
		trace(currentActivity);
		currentActivity.resume();
	}
	
	public function destroyActivity():Void {
		currentActivity.destroy();
	}
	
	public function addInteractivityListener(obj:Object) {
		if(ArrayUtils.findElement(listeners,obj) == -1) {
			listeners.push(obj);
		}
	}
	
	public function setLabels(l:Object) {
		labels = l;
	}
	
	public function getLabels():Object {
		return labels
	}
	
	public function dispatchInteractivityEvent(e:InteractivityEvent) {
		notifyListeners(e);
	}
	
	public function notifyListeners(e:InteractivityEvent) {
		for(var i = 0; i < listeners.length; i++) {
			listeners[i].notifyInteractivityEvent(e);
		}
	}	
	
}



