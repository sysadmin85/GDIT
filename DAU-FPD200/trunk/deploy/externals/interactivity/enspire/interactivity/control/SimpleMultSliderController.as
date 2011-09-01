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
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.control.SimpleMultSliderController 
	implements IActivity {
		
	private var evaluator:BasicMultSliderEvaluator;
	private var activityArgs:Object;
	private var activityDisplay:SimpleMultSliderDisplay;
	
	
	public function SimpleMultSliderController() {
		evaluator = new BasicMultSliderEvaluator();
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
	
	private function setupEvaluator() {
		var targets = new Array();
		var thresholds = new Array();
		var i = 0; 
		while(activityArgs["slider"+i] != undefined) {
			targets.push(parseInt(activityArgs["slider"+i+"TargetValue"]));
			i++;
		}
		i = 0; 
		while(activityArgs["slider"+i] != undefined) {
			thresholds.push(parseInt(activityArgs["slider"+i+"Tolerance"]));
			i++;
		}
		evaluator.setSliders(activityDisplay.getSliders());
		evaluator.setTargetValues(targets);
		evaluator.setThresholds(thresholds);
	}
	
	public function setupActivityDisplay(clip:MovieClip):Void {
		activityDisplay = new SimpleMultSliderDisplay();
		activityDisplay.setClip(clip);
		activityDisplay.setArgs(activityArgs);
	}
	
	public function evaluateActivity():IEvaluation {
		var evaluation = evaluator.evaluate();
		activityDisplay.displayEvaluation(evaluation);
		
		reportScore(evaluation);
		
		return evaluation;
	}
	
	public function reportScore(evaluation:IEvaluation):Void {
		var scoreEvent = new ScoreEvent();
		scoreEvent.setEvaluation(evaluation);
		var inter = Interactivity.getInstance();
		inter.dispatchInteractivityEvent(scoreEvent);
	}
	
	private function enableSubmit() {
		var submitBtnHolder = activityDisplay.getClip()["mcSubmitHolder"];
		var submitBtn = submitBtnHolder.attachMovie("SubmitButton","mcSubmit",submitBtnHolder.getNextHighestDepth());
		submitBtn.mcText.tf.htmlText = "Submit";
		submitBtn["controller"] = this;
		submitBtn.onRelease = function() {
			this["controller"].evaluateActivity();
		}
	}
	
	public function notifyInteractivityEvent(e:InteractivityEvent):Void {
		
	}
		
	
}

