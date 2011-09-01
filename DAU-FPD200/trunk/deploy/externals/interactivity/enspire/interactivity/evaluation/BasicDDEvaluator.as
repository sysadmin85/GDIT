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
   Class: BasicDDEvaluator
   The most basic class to evaluate drag and drop sorting-based activities.
   
   This class returns an evaluation of type <SimpleDDEvaluation> in its evaluate()
   method.
*/
class enspire.interactivity.evaluation.BasicDDEvaluator 
	extends BasicSortingEvaluator {
	
	public function BasicDDEvaluator() {
		super();
	}
	
	public function evaluate():IEvaluation {
		trace("evaluating D&D");
		
		var bin:IBin;
		var binID:String;
		var binTargetElements:Array;
		var binElements:Array;
		
		// defined as draggers that are in bays they shouldnt be in
		var incorrectDraggers:Array = new Array();
		var correctDraggers:Array = new Array();
		
		var evaluation:SimpleDDEvaluation = new SimpleDDEvaluation();
		evaluation.setCorrect(true);
		
		for(var i = 0; i < bins.length; i++) {
			bin = bins[i];
			binID = bin.getID();
			binTargetElements = binTargets[binID];
			binElements = bin.getElementsInBin();
			
			var binElementIDs:Array = new Array();
			
			trace(binID);
			for(var q = 0; q < binElements.length; q++) {
				binElementIDs.push(binElements[q].getID());				
			}
			
			
			for(var j = 0; j < binTargetElements.length; j++) {
				var target = binTargetElements[j];
				trace(target);
				if(ArrayUtils.findElement(binElementIDs,target) == -1) {
					evaluation.setCorrect(false);
				}
			}
			
			
			/* loop through the draggers in this bin,
			   find all the ones that dont belong, and stuff them into an
			   array */
			for(var k = 0; k < binElements.length; k++) {
				var be:ISortingElement = binElements[k];
				var beID:String = be.getID();
				if(ArrayUtils.findElement(binTargetElements,beID) == -1) {
					incorrectDraggers.push(be);
					evaluation.setCorrect(false);
				} else {
					correctDraggers.push(be);
				}
			}
			
		}
		
		this.numTries++;
		
		evaluation.setNumTries(this.numTries);
		
		evaluation.setCorrectDraggers(correctDraggers);
		evaluation.setIncorrectDraggers(incorrectDraggers);
		
		return evaluation;
	}
	
	
}