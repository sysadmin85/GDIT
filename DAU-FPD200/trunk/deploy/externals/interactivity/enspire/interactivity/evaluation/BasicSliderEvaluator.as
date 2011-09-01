import org.asapframework.util.ArrayUtils;
import org.asapframework.util.debug.Log;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Class: BasicSliderEvaluator
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.evaluation.BasicSliderEvaluator 
	extends BasicEvaluator
		implements IEvaluator {
	
	
	private var slider:Slider;
	private var targetValue:Number;
	
	public function BasicSliderEvaluator() {

	}
	
	public function setSlider(s:Slider) {
		slider = s;
	}
	
	public function setTargetValue(v:Number) {
		targetValue = v;
	}
	
	
	public function evaluate():IEvaluation {
		trace(slider.getValue() - targetValue);
		return null;
	}
	
	
}