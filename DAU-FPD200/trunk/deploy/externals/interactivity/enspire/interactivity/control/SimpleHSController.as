import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;


/*
   Class: SimpleHSController
   Main class that controls the Hotspot activity type. This class
   manages the evaluator and display classes for the activity. 
*/
class enspire.interactivity.control.SimpleHSController 
	implements IActivity {
		
	private var evaluator:BasicChoiceEvaluator;
	private var activityArgs:Object;
	private var activityProfile:Object;
	private var activityDisplay:SimpleHSDisplay;
	
	
	public function SimpleHSController() {
		evaluator = new BasicChoiceEvaluator();
	}
	
	/* Must be called after you have set the args and the clip */
	public function init():Void {
		initFunctionality();
		activityDisplay.showActivity();
		setupEvaluator();
		enableSubmit();
	}
	
	/* this function is called when the user navigates away from the current segment. Write code
	   here that will clean up attached movie clips, etc. */
	public function destroy():Void {
		trace("destroy: " + activityDisplay.getClip());
		activityDisplay.getClip().removeMovieClip();
		activityDisplay.removeActivePopups();
	}
	
	/* this function is generally called after displaying feedback to the user, and 
       normally is used to transition state in the activity. For example, in a multiple select, 
	   this is where we switch to the feedback phase */
	public function resume():Void {
		
	}
	
	/* This necessitates that there has to be some sort of 
	   agreed upon format for interactivity args */
	public function setActivityArgs(args:Object):Void {
		activityArgs = args;
	}
	
	public function setActivityProfile(profile:Object):Void {
		activityProfile = profile;
	}
	
	/* using data in the args, setup your Evaluator for the activity here */
	private function setupEvaluator() {
		//var i = 0;
		//while(activityArgs["choice"+i] != undefined) {
			//evaluator.addChoice(activityDisplay.getClip().choiceHolder["choice"+i]);
			//i++;
		//}
		//evaluator.setTargetChoices(activityArgs["correctChoices"].split(","));
	}
	
	/* create and configure your activity display here, the clip argument points at the movie clip that contains
	   the interactivity assets. */
	public function setupActivityDisplay(clip:MovieClip):Void {
		activityDisplay = new SimpleHSDisplay();
		activityDisplay.setClip(clip);
		activityDisplay.setArgs(activityArgs);
		activityDisplay.setProfile(activityProfile);
	}
	
	/* this function does a number of things. It calls the evaluate() function on 
	   the activity evaluator, which returns an instance of an Evaluation. This evaluation
	   is then sent to the activity display, so that the display can reflect the results of the
	   evaluation */
	public function evaluateActivity():IEvaluation {
		var evaluation = evaluator.evaluate();
		activityDisplay.displayEvaluation(evaluation);
		
		reportScore(evaluation);
		
		return evaluation;
	}
	
	/* dispatches a ScoreEvent that can be caught and handled by the surrounding application */
	public function reportScore(evaluation:IEvaluation):Void {
		var scoreEvent = new ScoreEvent();
		scoreEvent.setEvaluation(evaluation);
		var inter = Interactivity.getInstance();
		inter.dispatchInteractivityEvent(scoreEvent);
	}
	
	
	private function enableSubmit() {
		var submitBtn = activityDisplay.getClip()["mcSubmit"];
		submitBtn["controller"] = this;
		submitBtn.onRelease = function() {
			this["controller"].evaluateActivity();
		}
	}
	
	public function notifyInteractivityEvent(e:InteractivityEvent):Void {
		
	}
	
	
	/* This is probably where the code will get a little nastay no matter what */
	private function initFunctionality() {
		
	}
		
	
}

