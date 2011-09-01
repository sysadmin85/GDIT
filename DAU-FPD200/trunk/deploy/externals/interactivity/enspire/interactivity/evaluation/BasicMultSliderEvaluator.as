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
   Class: BasicMultSliderEvaluator
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.evaluation.BasicMultSliderEvaluator 
	extends BasicEvaluator
		implements IEvaluator {
	
	
	private var sliders:Array;
	private var targetValues:Array;
	private var thresholds:Array;
	
	
	public function BasicMultSliderEvaluator() {
		
	}
	
	public function setSliders(s:Array) {
		sliders = s;
	}
	
	public function setTargetValues(v:Array) {
		targetValues = v;
	}
	
	public function setThresholds(t:Array) {
		thresholds = t;
	}
	
	
	public function evaluate():IEvaluation {
		var finalEval = new SimpleMultSliderEvaluation();
		var evaluations = new Array();
		var allCorrect = true;
		for(var i = 0; i < sliders.length; i++) {
			var evaluation = new SimpleSliderEvaluation();
			var distance = sliders[i].getValue() - targetValues[i];
			evaluation.setDistance(distance);
			if(Math.abs(distance) <= thresholds[i]) {
				evaluation.setCorrect(true);
			} else {
				allCorrect = false;
				evaluation.setCorrect(false);
			}
			evaluations.push(evaluation);
		}
		finalEval.setCorrect(allCorrect);
		finalEval.setEvaluations(evaluations);
		return finalEval;
	}
	
	
}