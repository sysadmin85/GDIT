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
   Class: SimpleSequencingController
   Main class that controls the Slider activity type. This class
   manages the evaluator and display classes for the activity. 
*/
class enspire.interactivity.control.SimpleSequencingController 
	implements IActivity {
		
	private var evaluator:BasicSequencingEvaluator;
	private var activityArgs:Object;
	private var activityProfile:Object;
	private var activityDisplay:SimpleSequencingDisplay;
	
	
	public function SimpleSequencingController() {
		evaluator = new BasicSequencingEvaluator();
	}
	
	/* Must be called after you have set the args and the clip */
	public function init():Void {
		activityDisplay.showActivity();
		setupEvaluator();
		enableSubmit();
	}
	
	/* this function is called when the user navigates away from the current segment. Write code
	   here that will clean up attached movie clips, etc. */
	public function destroy():Void {
		Interactivity.iTimeline["mcSubmit"].removeMovieClip();
	}
	
	/* this function is generally called after displaying feedback to the user, and 
       normally is used to transition state in the activity. For example, in a multiple select, 
	   this is where we switch to the feedback phase */
	public function resume():Void {
		trace("resume called");
		var numTries = evaluator.getNumTries();
		if(numTries >= parseInt(activityProfile["nTries"])) {
			if(parseInt(activityProfile["nTries"]) != 0) {
				if(activityProfile["sFinish"] != "next") {
					activityDisplay.revealAnswers();
					Interactivity.iTimeline["mcSubmit"]._visible = false;
				}
			}
		} else {
			//activityDisplay.moveIncorrectDraggers();
		}	
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
		evaluator.setCorrectSequence(activityArgs["sCorrectSequence"].split(","));
	}
	
	/* create and configure your activity display here, the clip argument points at the movie clip that contains
	   the interactivity assets. */
	public function setupActivityDisplay(clip:MovieClip):Void {
		activityDisplay = new SimpleSequencingDisplay();
		activityDisplay.setClip(clip);
		activityDisplay.setArgs(activityArgs);
		activityDisplay.setProfile(activityProfile);
	}
	
	/* this function does a number of things. It calls the evaluate() function on 
	   the activity evaluator, which returns an instance of an Evaluation. This evaluation
	   is then sent to the activity display, so that the display can reflect the results of the
	   evaluation */
	public function evaluateActivity():IEvaluation {
		evaluator.setCurrentSequence(activityDisplay.getDraggers());
		var evaluation = evaluator.evaluate();
		if(activityArgs["sCorrectSequence"] == "all") {
			evaluation.setCorrect(true);
		}
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
		var submitBtnHolder = activityDisplay.getClip()["mcSubmitHolder"];
		var submitBtn = Interactivity.iTimeline.attachMovie("SubmitButton","mcSubmit",Interactivity.iTimeline.getNextHighestDepth());
		submitBtn._x = submitBtnHolder._x;
		submitBtn._y = submitBtnHolder._y;
		submitBtn.mcText.tf.htmlText = "Submit";
		submitBtn["controller"] = this;
		ConstructorUtil.createVisualInstance(SubmitButton, submitBtn);
		submitBtn.setText(Interactivity.getInstance().getLabels().getLabel("submit"));
		submitBtn.setCallback(this,this.evaluateActivity);
	}
	
	public function notifyInteractivityEvent(e:InteractivityEvent):Void {
		
	}
		
	
}

