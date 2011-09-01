import enspire.interactivity.model.*;
import enspire.interactivity.events.*;

/*
   Class: LikertEvent
   Event that is dispatched from any Movie Clip that inherits from <Choice> when
   the standard mouse actions are performed on the clip.
*/

class enspire.interactivity.events.LikertEvent 
	implements IInteractivityClipEvent {
	
	/* Variable: LIKERT_PRESS
	   Static enumeration returned by <getType> if this event was created by a mouse press.
	*/
	public static var LIKERT_PRESS = 645739;
	/* Variable: LIKERT_RELEASE
	   Static enumeration returned by <getType> if this event was created by a mouse release.
	*/
	public static var LIKERT_RELEASE = 135278;
	/* Variable: LIKERT_OVER
	   Static enumeration returned by <getType> if this event was created by mousing over the Choice.
	*/
	public static var LIKERT_OVER = 998723;
	/* Variable: LIKERT_OUT
	   Static enumeration returned by <getType> if this event was created by mousing out of the Choice.
	*/
	public static var LIKERT_OUT = 123123;
	/* Variable: LIKERT_MOVE
	   Static enumeration returned by <getType> if this event was created by the mouse moving while over the Choice.
	*/
	public static var LIKERT_MOVE = 980765;
	
	private var type:Number;
	private var obj:InteractivityClip;
	
	
	/* Constructor: LikertEvent
       Creates a new ChoiceEvent with the given type, and a reference to the Choice instance that is linked
	   to this event. 
	   
	   Example:
	   (start example)
	   		var ce = new ChoiceEvent(ChoiceEvent.CHOICE_PRESS,mcChoice);
	   (end)
    */
	public function LikertEvent(type:Number,obj:InteractivityClip) {
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
			case LIKERT_PRESS:
				str += "PRESSED";
				break;
			case LIKERT_RELEASE:
				str += "RELEASED";
				break;
			case LIKERT_OVER:
				str += "OVER";
				break;
			case LIKERT_OUT:
				str += "OUT";
				break;
			case LIKERT_MOVE:
				str += "MOVE";
				break;
		}
		trace(str);
		
	}
	
	
}

