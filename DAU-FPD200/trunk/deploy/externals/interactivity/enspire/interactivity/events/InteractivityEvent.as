import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

class enspire.interactivity.events.InteractivityEvent implements IInteractivityEvent {
	
	public static var STARTED = 123634;
	public static var COMPLETE = 134637;
	public static var POPUP = 456123;
	public static var SCORE = 653969;
	
	public var type;
	public var data;
	
	public function InteractivityEvent(type:Number, data:Object) {
		this.type = type;
		this.data = data;
	}
	
	public function getType():Number {
		return this.type;
	}
	
	public function getData():Object {
		return data;
	}
	
	public function traceMe() {
		var str = "INTERACTIVITY : ";
		switch (type) {
			case STARTED:
				str += "STARTED";
				break;
			case COMPLETE:
				str += "COMPLETE";
				break;
			case POPUP:
				str += "POPUP";
				break;
			case SCORE:
				str += "SCORE";
				break;
		}
		trace(str);
	}
}

