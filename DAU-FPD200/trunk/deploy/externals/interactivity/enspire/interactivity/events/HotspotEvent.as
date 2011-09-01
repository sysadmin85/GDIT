import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Class: HotspotEvent
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
   
   
   Example usage:
   
   (start code)
   // assume mcHotspot is of type: HotSpot
   var hotspot:Hotspot = timeline["mcHotspot"];
   
   // listen to events from this dragger
   hotspot.addHotspotListener(this);
   
   // the dragger will send you events via this function
   function notifyHotspotEvent(e:HotspotEvent) {
	   switch(e.getType()) {
			
			case HotspotEvent.HOTSPOT_OVER:
				
				e.getObj().gotoAndStop("over");
				
				break;
	   }
   }
   (end)
*/

class enspire.interactivity.events.HotspotEvent 
	implements IInteractivityClipEvent {
	
	/* Variable: HOTSPOT_PRESS
	   Static enumeration returned by <getType> if this event was created by a mouse press on the hotspot.
	*/
	public static var HOTSPOT_PRESS = 934563;
	
	/* Variable: HOTSPOT_RELEASE
	   Static enumeration returned by <getType> if this event was created by a mouse release on the hotspot.
	*/
	public static var HOTSPOT_RELEASE = 134637;
	
	/* Variable: HOTSPOT_OVER
	   Static enumeration returned by <getType> if this event was created when the hotspot was moused over.
	*/
	public static var HOTSPOT_OVER = 456854;
	
	/* Variable: HOTSPOT_OUT
	   Static enumeration returned by <getType> if this event was created by when the mouse left the hotspot.
	*/
	public static var HOTSPOT_OUT = 345675;
	
	/* Variable: HOTSPOT_MOVE
	   Static enumeration returned by <getType> if this event was created by the mouse moving over the hotspot.
	*/
	public static var HOTSPOT_MOVE = 426737;
	
	public var type:Number;
	public var obj:InteractivityClip;

	
	/* Constructor: HotspotEvent
       Creates a new HotspotEvent with the given type, and a reference to the HotSpot instance that is linked
	   to this event. 
	   
	   Example:
	   (start example)
	   		var he = new HotspotEvent(HotspotEvent.HOTSPOT_PRESS,mcHotspot);
	   (end)
    */
	public function HotspotEvent(type:Number,obj:InteractivityClip) {
		this.type = type;
		this.obj = obj;
	}
	
	
	/* Function: getType
       Returns the type of this event, which will be one of the various enumerations like HOTSPOT_RELEASE.
	   
	   Example:
	   (start example)
	   		var type = he.getType();
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
			case HOTSPOT_PRESS:
				str += "PRESSED";
				break;
			case HOTSPOT_RELEASE:
				str += "RELEASED";
				break;
			case HOTSPOT_OVER:
				str += "OVER";
				break;
			case HOTSPOT_OUT:
				str += "OUT";
				break;
			case HOTSPOT_MOVE:
				str += "MOVE";
				break;
		}
		trace(str);
		
	}
	
	
}

