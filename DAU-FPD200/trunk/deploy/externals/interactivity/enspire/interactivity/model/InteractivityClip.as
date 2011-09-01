import org.asapframework.util.*;
import org.asapframework.data.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;


/*
   Class: InteractivityClip
   Base class for all MovieClips that play a visual role in interactivities. For example: Draggers,
   Choices, HotSpots, Sliders, etc. The functionality included in this class allows all inheriting
   instances to act as event dispatchers, and store an ID.
   
   Below is an example of using the event dispatching system to change the appearance of a dragger 
   when it is rolled over.
   
   Example usage:
   
   (start code)
   // assume mcDragger is of type: Dragger
   var dragger:Dragger = timeline["mcDragger"];
   
   // listen to events from this dragger
   dragger.addListener(this);
   
   // the dragger will send you events via this function
   function notifyEvent(e:DraggerEvent) {
	   switch(de.getType()) {
			
			case DraggerEvent.DRAGGER_OVER:
				
				e.getObj().gotoAndStop("over");
				
				break;
	   }
   }
   (end)
   
*/
class enspire.interactivity.model.InteractivityClip 
	extends MovieClip {
	
	private var listeners:Array;
	private var id:String;
	private var index:Number;
	public var _accProps;
	private var read:ReadItem;
	public function InteractivityClip() {
		super();
		this._accProps = {}
		listeners = new Array();
	}
	
	public function setID(id) {
		this.id = id;
	}
	
	public function getID():String {
		return this.id;
	}
	
	public function setIndex(i:Number) {
		index = i;
	}
	
	public function getIndex() {
		return index;
	}
	
	
	/* Function: notifyListeners
       Sends an <IInteractivityCilpEvent> to all objects that have added themselves as listeners to 
	   this instance. The function 'notifyEvent' is called on the listener, and the event is passed as
	   a parameter.
	   
	   example usage:
	   (start code)
	    // from <Dragger> class
	    private function initHandlers() {
		this.onPress = function() {
			if(dragEnabled) {
				draggerPress();
				var de = new DraggerEvent(DraggerEvent.DRAGGER_PRESS,this);
				notifyListeners(de);
			}
		}
	   (end)
    */
	private function notifyListeners(ie:IInteractivityClipEvent) {
		for(var i = 0; i < listeners.length; i++) {
			listeners[i].notifyEvent(ie);
		}
	}
	
	
	/* Function: addListener
       Adds obj to the list of event listeners for this InteractivityClip. Obj must
	   implement a function called 'notifyEvent', which accepts an <IInteractivityClipEvent>
	   as it's sole argument. 
	   
	   Here's an example of listening to events from a dragger.
	   
	   Example usage:
	   
	   (start code)
	   // assume mcDragger is of type: Dragger
	   var dragger:Dragger = timeline["mcDragger"];
	   
	   // listen to events from this dragger
	   dragger.addListener(this);
	   
	   // the dragger will send you events via this function
	   function notifyEvent(e:DraggerEvent) {
		   switch(de.getType()) {
				
				case DraggerEvent.DRAGGER_OVER:
					
					e.getObj().gotoAndStop("over");
					
					break;
		   }
	   }
	   (end)
	   
    */
	public function addListener(obj:Object) {
		if(ArrayUtils.findElement(listeners,obj) == -1) {
			listeners.push(obj);
		}
	}
	
	
	/* Function: removeListener
       Removes obj from the list of event listeners for this InteractivityClip. Obj will no longer 
	   receive event notifications from this InteractivityClip.
    */
	public function removeListener(obj:Object) {
		ArrayUtils.removeElement(listeners,obj);
	}
	public function allowAccess(sText:String, sDesc:String) {
		this.read = AccessManager.addItem("content", this, sText, sDesc);
		
		this.onSetFocus = function() {
			trace("SET FOCUS: "+this+" "+this.read.getName()+" "+this.read.getDescription());
		}
	}
	
	public function getAccess() {
		return this.read;
	}
	
}

