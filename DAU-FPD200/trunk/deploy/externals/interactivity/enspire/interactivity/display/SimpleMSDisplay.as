import org.asapframework.util.*;

import com.mosesSupposes.fuse.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;

import enspire.accessibility.AccessManager;
import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;

/*
   Class: SimpleMSDisplay
   Class that manages all of the visual elements related to the Multiple Select activity
*/
class enspire.interactivity.display.SimpleMSDisplay implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	private var profile:Object;
	
	private var choices:Array;
	private var choicePadding:Number;
	private var choiceSpacing:Number;
	
	private var randomizer:VisualRandomizer;
	
	private var promptRead:ReadItem;
	
	private var CHOICE_TWEEN_TIME = .40;
	
	
	public function SimpleMSDisplay() {
		choices = new Array();
		randomizer = new VisualRandomizer();
	}
	
	public function showActivity():Void {
		choicePadding = clip["mcChoiceHolder"]._y - (clip["mcPrompt"]._y + clip["mcPrompt"]._height);
		choiceSpacing = parseInt(profile["nChoiceSpacing"]);
		if(args["nChoiceSpacing"] != undefined) { choiceSpacing = parseInt(args["nChoiceSpacing"]); }
		initPrompt();
		initChoices();
	}
	
	public function updateActivity():Void {
		
	}
	
	public function setArgs(a:Object):Void {
		args = a;
	}
	
	public function setProfile(a:Object):Void {
		profile = a;
	}
	
	public function setClip(c:MovieClip):Void {
		clip = c;
	}
	
	public function getClip():MovieClip {
		return clip;
	}
	
	
	public function displayEvaluation(e:IEvaluation):Void {
		
		var mcEval:SimpleChoiceEvaluation = SimpleChoiceEvaluation(e);
		
		var isCorrect:Boolean = mcEval.getCorrect();
		
		var displayText:String;
		
		var labels = Interactivity.getInstance().getLabels();
		
		var correctChoiceIds = args["sCorrectChoices"].split(",");
		
		if(profile["sFeedbackType"] == "specific") {
			for(var i = 0; i < correctChoiceIds.length; i++) {
				var id = correctChoiceIds[i];
				for(var j = 0; j < choices.length; j++) {
					if(choices[j].getID() == id) {
						choices[j].showCorrect();
					}
				}
			}
		}
		
		
		if(isCorrect) {
			displayText = args["sCorrectFeedback"];
		} else {
			displayText = args["sIncorrectFeedback"];
		}

		var evnt = new PopupEvent();
		
		
		if(isCorrect) {
			evnt.setButtonText(labels.getLabel(profile["sLabelCorrect"]));
			if(profile["sFeedbackType"] != "specific") {
				disableChoices();
			}
		} else {
			if(mcEval.getNumTries() >= parseInt(profile["nTries"])) {
				if(parseInt(profile["nTries"]) != 0) {
					if(args["sLastFeedback"] != undefined) {
						displayText = args["sLastFeedback"];
					}
					evnt.setButtonText(labels.getLabel(profile["sLabelCorrect"]));
				} else {
					evnt.setButtonText(labels.getLabel(profile["sLabelIncorrect"]));
				}
			} else {
				evnt.setButtonText(labels.getLabel(profile["sLabelIncorrect"]));
			}
		}
		
		evnt.setPopupText(displayText);
		Interactivity.getInstance().dispatchInteractivityEvent(evnt);
			
	}
	
	public function disableChoices() {
		for(var i = 0; i < choices.length; i++) {
			choices[i].disable();
		}
	}
	
	
	public function startFeedbackPhase():Void {
		var choice:FeedbackChoice;
		for(var i = 0; i < choices.length; i++) {
			choice = choices[i];
			choice.enableFeedback();
		}
	}
	
	
	/* This catches the events that get fired from the draggers */
	public function notifyEvent(ce:ChoiceEvent) { 
	
		var choice:Choice = Choice(ce.getObj());
		var isSelected:Boolean = choice.isSelected();
		
		switch(ce.getType()) {
			
			case ChoiceEvent.CHOICE_PRESS:
					choice.gotoAndStop("down");
					choice["mcBg"].gotoAndPlay("down");
				break;
				
			case ChoiceEvent.CHOICE_RELEASE:
				if(isSelected) {
					choice.gotoAndStop("selected");
					choice["mcBg"].gotoAndPlay("over");
				} else {
					choice.gotoAndStop("over");
					choice["mcBg"].gotoAndPlay("over");
				}
				
				var submitBtn = clip.mcSubmit;
				ConstructorUtil.createVisualInstance(SubmitButton, submitBtn);
				submitBtn.enable();
				
				break;
				
			case ChoiceEvent.CHOICE_OVER:
				if(!isSelected) {
					choice.gotoAndStop("over");
					choice["mcBg"].gotoAndPlay("over");
				}
				break;
				
			case ChoiceEvent.CHOICE_OUT:
				if(!isSelected) {
					choice.gotoAndStop("up");
					choice["mcBg"].gotoAndPlay("out");
				}
				break;
				
			case ChoiceEvent.CHOICE_FEEDBACK_CLICK:
				for(var i = 0; i < choices.length; i++) {
					if(choices[i] != choice) {
						choices[i].hideFeedback();
					}
				}
				if(FeedbackChoice(choice).getShowingFeedback()) {
					trace("SHOULD HIDE");
					FeedbackChoice(choice).hideFeedback();
				} else {
					trace("SHOULD SHOW");
					FeedbackChoice(choice).showFeedback();
				}
				layoutChoices();
				break;
		}
		
		layoutChoices();
		
	}

	
	private function initPrompt() {
		clip.mcPrompt.tf.autoSize = true;
		clip.mcPrompt.tf.htmlText = args["sPrompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		if(clip.mcPrompt.mcBg == undefined) { return; }
		clip.mcPrompt.mcBg._height = Math.max(bgInitHeight,
											  clip.mcPrompt.tf.textHeight + (clip.mcPrompt.tf._y * 2));
		this.promptRead = AccessManager.addItem("content", clip.mcPrompt.tf, clip.mcPrompt.tf.text);
	}
	
	private function layoutChoices() {
		var yOff = 0;
		for(var i = 0; i < choices.length; i++) {
			var choice = choices[i];
			ZigoEngine.doTween(choice,"_y",yOff,CHOICE_TWEEN_TIME);
			yOff += choice.getHeight() + choiceSpacing;
		}
		
		var newBgHeight = yOff + 
						  clip["mcPrompt"].mcBg._height + 15;
						  
		if(clip["mcSubmit"]._visible) {
			newBgHeight += clip["mcSubmit"]._height;
			
			clip["mcSubmit"]._y = clip["mcBg"]._y + 
							  newBgHeight - 
							  clip["mcSubmit"]._height - 5;
		}

		ZigoEngine.doTween(clip["mcBg"],"_height",newBgHeight,CHOICE_TWEEN_TIME);
							   
	}
	
	private function initChoices() {
		var i = 0;
		var choice:MovieClip;
		
		clip["mcChoiceHolder"]._y = clip["mcPrompt"]._y + clip["mcPrompt"]._height + choicePadding;
		
		while(args["sChoice"+i] != undefined) {
			choice = clip["mcChoiceHolder"].attachMovie(profile["sChoiceSkin"], "choice"+i, clip["mcChoiceHolder"].getNextHighestDepth());
			choice.setID(args["sChoice"+i]);
			choice.setText(args["sChoice"+i+"Text"]);
			choice.setFeedbackText(args["sChoice"+i+"Feedback"]);
			choice.lockInInitHeight();
			choice.addListener(this);
			choices.push(choice);
			i++;
		}
		
		if(profile["bRandomizeChoices"]) {
			//randomizer.randomizePositions(choices);
			ArrayUtils.randomize(choices);
		}
		for(var j = 0; j < choices.length; j++) {
			choices[j].allowAccess("choice "+(j+1) + " " + choices[j].getText())
		}
		AccessManager.update();
		layoutChoices();
		
	}
}

