import enspire.interactivity.model.*;
import enspire.interactivity.events.*;

/*
   Class: SliderEvent
   Event that is dispatched from any Movie Clip that inherits from <Slider> when
   the standard actions are performed on the widget
*/

class enspire.interactivity.events.SliderEvent 
	implements IInteractivityClipEvent {
	
	/* Variable: SLIDER_PRESS
	   Static enumeration returned by <getType> if this event was created by a mouse press.
	*/
	public static var SLIDER_PRESS = 934563;
	/* Variable: SLIDER_RELEASE
	   Static enumeration returned by <getType> if this event was created by a mouse release.
	*/
	public static var SLIDER_RELEASE = 134637;
	/* Variable: SLIDER_OVER
	   Static enumeration returned by <getType> if this event was created by mousing over the Slider handle.
	*/
	public static var SLIDER_OVER = 456854;
	/* Variable: SLIDER_OUT
	   Static enumeration returned by <getType> if this event was created by mousing out of the Slider handle.
	*/
	public static var SLIDER_OUT = 345675;
	/* Variable: SLIDER_MOVE
	   Static enumeration returned by <getType> if this event was created by the mouse moving while over the Slider handle.
	*/
	public static var SLIDER_MOVE = 426737;
	
	
	private var type:Number;
	private var obj:InteractivityClip;
	
	
	
	/* Constructor: SliderEvent
       Creates a new SliderEvent with the given type, and a reference to the Slider instance that is linked
	   to this event. 
	   
	   Example:
	   (start example)
	   		var se = new SliderEvent(SliderEvent.SLIDER_PRESS,mcSlider);
	   (end)
    */
	public function SliderEvent(type:Number,obj:InteractivityClip) {
		this.type = type;
		this.obj = obj;
	}
	
	/* Function: getType
       Returns the type of this event, which will be one of the various enumerations like SLIDER_RELEASE.
	   
	   Example:
	   (start example)
	   		var type = ce.getType();
	   (end)
    */
	public function getType():Number {
		return type;
	}
	
	/* Function: getObj
       Returns the Slider object that is associated with this event.
	   
	   Example:
		(start example)
	   		var slider = se.getObj();
			slider.gotoAndStop("over");
		(end)

    */
	public function getObj():InteractivityClip {
		return obj;
	}

}

