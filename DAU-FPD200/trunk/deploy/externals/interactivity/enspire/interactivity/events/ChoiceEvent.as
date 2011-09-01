import enspire.interactivity.model.*;
import enspire.interactivity.events.*;

/*
   Class: ChoiceEvent
   Event that is dispatched from any Movie Clip that inherits from <Choice> when
   the standard mouse actions are performed on the clip.
*/

class enspire.interactivity.events.ChoiceEvent 
	implements IInteractivityClipEvent {
	
	/* Variable: CHOICE_PRESS
	   Static enumeration returned by <getType> if this event was created by a mouse press.
	*/
	public static var CHOICE_PRESS = 934563;
	/* Variable: CHOICE_RELEASE
	   Static enumeration returned by <getType> if this event was created by a mouse release.
	*/
	public static var CHOICE_RELEASE = 134637;
	/* Variable: CHOICE_OVER
	   Static enumeration returned by <getType> if this event was created by mousing over the Choice.
	*/
	public static var CHOICE_OVER = 456854;
	/* Variable: CHOICE_OUT
	   Static enumeration returned by <getType> if this event was created by mousing out of the Choice.
	*/
	public static var CHOICE_OUT = 345675;
	/* Variable: CHOICE_MOVE
	   Static enumeration returned by <getType> if this event was created by the mouse moving while over the Choice.
	*/
	public static var CHOICE_MOVE = 426737;
	/* Variable: CHOICE_FEEDBACK_CLICK
	   Static enumeration returned by <getType> if this event was created by the mouse moving while over the Choice.
	*/
	public static var CHOICE_FEEDBACK_CLICK = 3759211;
	
	private var type:Number;
	private var obj:InteractivityClip;
	
	
	/* Constructor: ChoiceEvent
       Creates a new ChoiceEvent with the given type, and a reference to the Choice instance that is linked
	   to this event. 
	   
	   Example:
	   (start example)
	   		var ce = new ChoiceEvent(ChoiceEvent.CHOICE_PRESS,mcChoice);
	   (end)
    */
	public function ChoiceEvent(type:Number,obj:InteractivityClip) {
		this.type = type;
		this.obj = obj;
	}
	
	/* Function: getType
       Returns the type of this event, which will be one of the various enumerations like CHOICE_RELEASE.
	   
	   Example:
	   (start example)
	   		var type = ce.getType();
	   (end)
    */
	public function getType():Number {
		return type;
	}
	
	/* Function: getObj
       Returns the Choice object that is associated with this event.
	   
	   Example:
		(start example)
	   		var choice = ce.getObj();
			choice.gotoAndStop("over");
		(end)

    */
	public function getObj():InteractivityClip {
		return obj;
	}
	
	public function traceMe() {
		var str = obj + " : ";
		switch (type) {
			case CHOICE_PRESS:
				str += "PRESSED";
				break;
			case CHOICE_RELEASE:
				str += "RELEASED";
				break;
			case CHOICE_OVER:
				str += "OVER";
				break;
			case CHOICE_OUT:
				str += "OUT";
				break;
			case CHOICE_MOVE:
				str += "MOVE";
				break;
		}
		trace(str);
		
	}
	
	
}

