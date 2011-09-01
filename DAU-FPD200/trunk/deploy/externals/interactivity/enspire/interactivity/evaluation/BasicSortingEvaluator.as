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
   Class: BasicSortingEvaluator
   The most basic class to evaluate sorting-based activities. Since most sorting interactivities
   will likely be drag-and-drop, you will probably be using the inherited class <BasicDDEvaluator>.
   
   This class returns an evaluation of type <SimpleEvaluation> in its evaluate()
   method.
*/
class enspire.interactivity.evaluation.BasicSortingEvaluator
	extends BasicEvaluator
		implements IEvaluator {
	
	var bins:Array;
	var binTargets:Object;
	
	public function BasicSortingEvaluator() {
		bins = new Array();
		binTargets = new Object();
	}
	
	/* Function: addBin
       This type of evaluator requires a bit of setup to ready it for use. Specifically, 
	   we need to keep track of all bins that are participating in the activity.
	   
	   To see how this operates, see this code from the setupEvaluator() function in the
	   <SimpleDDController> class. Note that a <Bay> extends from a <IBin>
	   
	   Example usage:
	   
	   (start code)
		var i = 0;
		while(activityArgs["bay"+i] != undefined) {
			evaluator.addBin(activityDisplay.getClip()["bay"+i]);
			evaluator.setBinTargets(activityArgs["bay"+i],activityArgs["bay"+i+"draggers"].split(","));
			i++;
		}
	   (end)
	   
    */
	public function addBin(b:IBin) {
		if(ArrayUtils.findElement(bins,b) == -1) {
			bins.push(b);
		}
	}
	
	
	/* Function: setBinTargets
       This type of evaluator requires a bit of setup to ready it for use. Specifically, 
	   we need to know what sorting elements belong in each bin.
	   
	   To see how this operates, see this code from the setupEvaluator() function in the
	   <SimpleDDController> class. Note that a <Bay> extends from a <IBin>
	   
	   Example usage:
	   
	   (start code)
		var i = 0;
		while(activityArgs["bay"+i] != undefined) {
			evaluator.addBin(activityDisplay.getClip()["bay"+i]);
			evaluator.setBinTargets(activityArgs["bay"+i],activityArgs["bay"+i+"draggers"].split(","));
			i++;
		}
	   (end)
	   
    */
	public function setBinTargets(binId:String,elementIDs:Array) {
		trace("setting bin target: " + binId);
		trace("elementIDs: " + elementIDs);
		binTargets[binId] = elementIDs;
	}
	
	public function evaluate():IEvaluation {
		var bin:IBin;
		var binID:String;
		var binTargetElements:Array;
		var binElements:Array;
		
		
		var evaluation:SimpleEvaluation = new SimpleEvaluation();
		evaluation.setCorrect(true);
		
		for(var i = 0; i < bins.length; i++) {
			bin = bins[i];
			binID = bin.getID();
			binTargetElements = binTargets[binID];
			binElements = bin.getElementsInBin();
			
			var binElementIDs:Array = new Array();
		
			for(var q = 0; q < binElements.length; q++) {
				binElementIDs.push(binElements[q].getID());
			}
			
			for(var j = 0; j < binTargetElements.length; j++) {
				var target = binTargets[j];
				if(ArrayUtils.findElement(binElementIDs,target) == -1) {
					evaluation.setCorrect(false);
				}
			}
		}
		
		this.numTries++;
		
		evaluation.setNumTries(this.numTries);
		
		return evaluation;
	}
	
	
}