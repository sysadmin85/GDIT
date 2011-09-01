import mx.controls.ComboBox;

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
   Class: BasicSequencingEvaluator
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.evaluation.DropdownEvaluator 
	extends BasicEvaluator
		implements IEvaluator {
	
	var correctSequence:Array;
	var currentSequence:Array;
	
	public function DropdownEvaluator() {

	}
	
	public function setCorrectSequence(a:Array) {
		correctSequence = a;
	}
	
	public function setCurrentSequence(a:Array) {
		currentSequence = a;
	}
	
	public function evaluate():IEvaluation {
		var dd:ComboBox;
		var seqEval = new SimpleSequencingEvaluation();
		seqEval.setCorrect(true);
		for(var i = 0; i < currentSequence.length; i++) {
			dd = ComboBox(currentSequence[i]);
			var id:String = dd.selectedItem.label;
			if(id != correctSequence[i]) {
				seqEval.setCorrect(false);
			}
		}
		
		this.numTries++;
		
		seqEval.setNumTries(this.numTries);
		
		return seqEval;
	}
	
	
}