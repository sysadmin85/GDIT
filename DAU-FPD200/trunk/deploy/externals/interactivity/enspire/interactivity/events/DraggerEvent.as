import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Class: DraggerEvent
   Event that is dispatched from any Movie Clip that inherits from <Dragger> when
   the standard mouse actions are performed on the clip.
   
   Example usage:
   
   (start code)
   // assume mcDragger is of type: Dragger
   var dragger:Dragger = timeline["mcDragger"];
   
   // listen to events from this dragger
   dragger.addDraggerListener(this);
   
   // the dragger will send you events via this function
   function notifyDragEvent(e:DraggerEvent) {
	   switch(de.getType()) {
			
			case DraggerEvent.DRAGGER_OVER:
				
				e.getObj().gotoAndStop("over");
				
				break;
	   }
   }
   (end)
   
*/

class enspire.interactivity.events.DraggerEvent 
	implements IInteractivityClipEvent {
	
	/* Variable: DRAGGER_PRESS
	   Static enumeration returned by <getType> if this event was created by a mouse press.
	*/
	public static var DRAGGER_PRESS = 934563;
	/* Variable: DRAGGER_RELEASE
	   Static enumeration returned by <getType> if this event was created by a mouse release.
	*/
	public static var DRAGGER_RELEASE = 134637;
	/* Variable: DRAGGER_OVER
	   Static enumeration returned by <getType> if this event was created by mousing over the Dragger.
	*/
	public static var DRAGGER_OVER = 456854;
	/* Variable: DRAGGER_OUT
	   Static enumeration returned by <getType> if this event was created by mousing out of the Dragger.
	*/
	public static var DRAGGER_OUT = 345675;
	/* Variable: DRAGGER_MOVE
	   Static enumeration returned by <getType> if this event was created by the mouse moving while over the Dragger.
	*/
	public static var DRAGGER_MOVE = 426737;
	
	
	private var type:Number;
	private var obj:InteractivityClip;
	
	
	
	/* Constructor: DraggerEvent
       Creates a new DraggerEvent with the given type, and a reference to the Dragger instance that is linked
	   to this event. 
	   
	   Example:
	   (start example)
	   		var ce = new DraggerEvent(DraggerEvent.DRAGGER_PRESS,mcDragger);
	   (end)
    */
	public function DraggerEvent(type:Number,obj:InteractivityClip) {
		this.type = type;
		this.obj = obj;
	}
	
	/* Function: getType
       Returns the type of this event, which will be one of the various enumerations like DRAGGER_RELEASE.
	   
	   Example:
	   (start example)
	   		var type = de.getType();
	   (end)
    */
	public function getType():Number {
		return type;
	}
	
	public function getObj():InteractivityClip {
		return obj;
	}
	
	public function traceMe() {
		var str = obj + " : ";
		switch (type) {
			case DRAGGER_PRESS:
				str += "PRESSED";
				break;
			case DRAGGER_RELEASE:
				str += "RELEASED";
				break;
			case DRAGGER_OVER:
				str += "OVER";
				break;
			case DRAGGER_OUT:
				str += "OUT";
				break;
			case DRAGGER_MOVE:
				str += "MOVE";
				break;
		}
		trace(str);
		
	}
	
	
}

