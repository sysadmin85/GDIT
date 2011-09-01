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
   Class: BasicChoiceEvaluator
   The most basic class to evaluate choice-based activities. This includes
   both multiple choice, and multiple select style questions. 
   
   This class returns an evaluation of type <SimpleChoiceEvaluation> in its evaluate()
   method.
*/
class enspire.interactivity.evaluation.BasicChoiceEvaluator 
	extends BasicEvaluator 
		implements IEvaluator {
	
	var choices:Array;
	var targetChoices:Array;
	var multipleSelect:Boolean;
	
	public function BasicChoiceEvaluator() {
		super();
		choices = new Array();
		multipleSelect = false;
	}
	
	public function setMultipleSelect(b:Boolean) {
		multipleSelect = b;
	}
	
	/* Function: addChoice
       This type of evaluator requires a bit of setup to ready it for use. Specifically, 
	   we need to send it handles to all of the <IChoice> objects participating in this
	   activity.
	   
	   To see how this operates, see this code from the setupEvaluator() function in the
	   <SimpleMCController> class.
	   
	   Example usage:
	   
	   (start code)
	   var i = 0;
		while(activityArgs["choice"+i] != undefined) {
			evaluator.addChoice(activityDisplay.getClip().choiceHolder["choice"+i]);
			i++;
		}
	   (end)
	   
    */
	public function addChoice(c:IChoice) {
		choices.push(c);
	}
	
	/* Function: setTargetChoices
       This type of evaluator requires a bit of setup to ready it for use. Specifically, 
	   we need to send it a data structure representing the 'correct' configuration of
	   selected and unselected choices.
	   
	   To see how this operates, see this code from the setupEvaluator() function in the
	   <SimpleMCController> class.
	   
	   Example usage:
	   
	   (start code)
		evaluator.setTargetChoices(activityArgs["correctChoices"].split(","));
	   (end)
	   
    */
	public function setTargetChoices(tc:Array) {
		targetChoices = tc;
	}
	
	/* Function: evaluate
       Returns a <SimpleChoiceEvaluation> representing the current state of the interactivity. 
    */
	public function evaluate():IEvaluation {
		var evaluation:SimpleChoiceEvaluation = new SimpleChoiceEvaluation();
		evaluation.setCorrect(true);
		
		var correctChoices:Array = new Array();
		var incorrectChoices:Array = new Array();
		
		var choice:IChoice;
		for(var i = 0; i < choices.length; i++) {
			choice = choices[i];
			if(choice.isSelected()) {
				if(ArrayUtils.findElement(targetChoices,choice.getID()) == -1) {
					evaluation.setCorrect(false);
					incorrectChoices.push(choice);
				} else {
					correctChoices.push(choice);
				}
			} else {
				if(ArrayUtils.findElement(targetChoices,choice.getID()) != -1) {
					if(multipleSelect) {
						evaluation.setCorrect(false);
						incorrectChoices.push(choice);
					}
				} else {
					if(multipleSelect) {
						incorrectChoices.push(choice);
					}
				}
			}
		}
		
		this.numTries++;
		
		evaluation.setNumTries(this.numTries);
		
		evaluation.setCorrectChoices(correctChoices);
		evaluation.setIncorrectChoices(incorrectChoices);
		
		return evaluation;
	}
	
	
}