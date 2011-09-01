import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;

/*
   class: InteractivityFactory
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.main.InteractivityFactory {
	
	public static var SIMPLE_DRAG_AND_DROP = "Sorting";
	public static var SIMPLE_MULTIPLE_CHOICE = "MultChoice";
	public static var SIMPLE_MULTIPLE_SELECT = "MultSelect";
	public static var SIMPLE_SEQUENCING = "Sequencing";
	public static var DROP_DOWN = "Dropdown";
	public static var SIMPLE_HOTSPOT = "Hotspot";
	public static var SIMPLE_SLIDER = "ImageSlider";
	public static var SIMPLE_MULT_SLIDER = "simple_mult_slider";
	
	
	/* Constructor: InteractivityFactory
       Don't ever call this. Instantiating an instance of this class is useless. Use
	   the static function <createActivity> instead.
    */
	public function InteractivityFactory() {
	
	}
	
	public static function createActivity(type:String):IActivity {
		trace("CREATINGTYPE: " + type);
		var controller:IActivity;
		switch(type) {
			case SIMPLE_DRAG_AND_DROP:
				controller = new SimpleDDController();
				break;
			case SIMPLE_MULTIPLE_CHOICE:
				controller = new SimpleMCController();
				break;
			case SIMPLE_MULTIPLE_SELECT:
				controller = new SimpleMSController();
				break;
			case SIMPLE_SEQUENCING:
				controller = new SimpleSequencingController();
				break;
			case SIMPLE_HOTSPOT:
				controller = new SimpleHSController();
				break;
			case SIMPLE_SLIDER:
				controller = new SimpleSliderController();
				break;
			case SIMPLE_MULT_SLIDER:
				controller = new SimpleMultSliderController();
				break;
			case DROP_DOWN:
				controller = new DropdownController();
				break;
		}
		return controller;
	}
	
}



