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
   Class: SimpleSliderController
   Main class that controls the Multiple Slider activity type. This class
   manages the evaluator and display classes for the activity. 
*/
class enspire.interactivity.control.SimpleSliderController 
	implements IActivity {
		
	private var evaluator:BasicSliderEvaluator;
	private var activityArgs:Object;
	private var activityDisplay:SimpleSliderDisplay;
	
	
	public function SimpleSliderController() {
		evaluator = new BasicSliderEvaluator();
	}
	
	
	public function init():Void {
		activityDisplay.showActivity();
		setupEvaluator();
		enableSubmit();
	}
	
	/* this function is called when the user navigates away from the current segment. Write code
	   here that will clean up attached movie clips, etc. */
	public function destroy():Void {
		
	}
	
	/* this function is generally called after displaying feedback to the user, and 
       normally is used to transition state in the activity. For example, in a multiple select, 
	   this is where we switch to the feedback phase */
	public function resume():Void {
		
	}
	
	public function setActivityArgs(args:Object):Void {
		activityArgs = args;
	}
	
	public function setActivityProfile(profile:Object):Void {
		//activityProfile = profile;
	}
	
	/* using data in the args, setup your Evaluator for the activity here */
	private function setupEvaluator() {
		evaluator.setSlider(activityDisplay.getSlider());
		evaluator.setTargetValue(parseInt(activityArgs["nTargetValue"]));
	}
	
	/* create and configure your activity display here, the clip argument points at the movie clip that contains
	   the interactivity assets. */
	public function setupActivityDisplay(clip:MovieClip):Void {
		activityDisplay = new SimpleSliderDisplay();
		activityDisplay.setClip(clip);
		activityDisplay.setArgs(activityArgs);
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
		
	
}

