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
   Class: SimpleMCDisplay
   Class that manages all of the visual elements related to the Multiple Choice activity
*/
class enspire.interactivity.display.SimpleMCDisplay implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	private var profile:Object;
	
	private var choices:Array;
	private var choicePadding:Number;
	private var choiceSpacing:Number;
	
	private var randomizer:VisualRandomizer;
	
	private var promptRead:ReadItem;
	
	public function SimpleMCDisplay() {
		choices = new Array();
		randomizer = new VisualRandomizer();
	}
	
	public function showActivity():Void {
		if(profile["bSubmit"] == false) {
			clip["mcSubmit"]._visible = false;
		}
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
		
		if(profile["sFeedbackType"] == "general") {
		
			if(isCorrect) {
				displayText = args["sCorrectFeedback"];
			} else {
				displayText = args["sIncorrectFeedback"];
			}
			
		} else if(profile["sFeedbackType"] == "specific") {
			var choiceIndex;
			if(isCorrect) {
				choiceIndex = mcEval.getCorrectChoices()[0].getIndex();
			} else {
				choiceIndex = mcEval.getIncorrectChoices()[0].getIndex();
			}
			displayText = args["sChoice" + choiceIndex + "Feedback"];
			
		} else if(profile["sFeedbackType"] == "branching") {
			var choiceIndex;
			if(isCorrect) {
				choiceIndex = mcEval.getCorrectChoices()[0].getIndex();
			} else {
				choiceIndex = mcEval.getIncorrectChoices()[0].getIndex();
			}
			displayText = args["sChoice" + choiceIndex + "NextSeg"];
			
		}else if(profile["sFeedbackType"] == "none") {
			return;
		}
		
		
		var evnt = new PopupEvent();
		
		if(isCorrect) {
			evnt.setButtonText(labels.getLabel(profile["sLabelCorrect"]));
			disableChoices();
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
	
	
	/* This catches the events that get fired from the draggers */
	public function notifyEvent(ce:ChoiceEvent) { 
	
		var choice:Choice = Choice(ce.getObj());
		var isSelected:Boolean = choice.isSelected();
		
		switch(ce.getType()) {
			
			case ChoiceEvent.CHOICE_PRESS:
				if(!isSelected) {
					choice.gotoAndPlay("down");
					choice["mcBg"].gotoAndPlay("down");
				}
				break;
				
			case ChoiceEvent.CHOICE_RELEASE:
				if(!isSelected) {
					choice.gotoAndPlay("over");
					choice["mcBg"].gotoAndPlay("over");
				}
				updateAfterClick(choice);
				break;
				
			case ChoiceEvent.CHOICE_OVER:
				if(!isSelected) {
					choice.gotoAndPlay("over");
					choice["mcBg"].gotoAndPlay("over");
				}
				break;
				
			case ChoiceEvent.CHOICE_OUT:
				if(!isSelected) {
					choice.gotoAndPlay("out");
					choice["mcBg"].gotoAndPlay("out");
				}
				break;
				
		}
	}
	
	private function updateAfterClick(justClicked:Choice) {
		var choice:Choice;
		var oneSelected = false;
		for(var i = 0; i < choices.length; i++) {
			choice = Choice(choices[i]);
			var isSelected = choice.isSelected();
			if(isSelected) { oneSelected = true; }
			if(choice != justClicked) {
				choice.deselect();
				choice.gotoAndStop("up");
				choice["mcBg"].gotoAndPlay("up");
			}
		}
		var submitBtn = clip.mcSubmit;
		ConstructorUtil.createVisualInstance(SubmitButton, submitBtn);
		
		if(oneSelected) {
			submitBtn.enable();
		} else {
			submitBtn.disable();
		}
		
		if(!profile["bSubmit"]) {
			submitBtn.onRelease();
		}
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
			choice._y = yOff;
			yOff += choice._height + choiceSpacing;
		}
		
		clip["mcBg"]._height = yOff + 
							   clip["mcPrompt"].mcBg._height + 15;
							   
		if(profile["bSubmit"]) {
				clip["mcBg"]._height += clip["mcSubmit"]._height;
		}
							   
		if(profile["bSubmit"]) {
			clip["mcSubmit"]._y = clip["mcBg"]._y + 
								  clip["mcBg"]._height - 
								  clip["mcSubmit"]._height - 5;
		}
	}
	
	private function initChoices() {
		var i = 0;
		var choice:MovieClip;
		
		clip["mcChoiceHolder"]._y = clip["mcPrompt"]._y + clip["mcPrompt"]._height + choicePadding;
		
		var yOff = 0;
		
		while(args["sChoice"+i] != undefined) {
			choice = clip["mcChoiceHolder"].attachMovie(profile["sChoiceSkin"], "choice"+i, clip["mcChoiceHolder"].getNextHighestDepth());
			choice.setID(args["sChoice"+i]);
			choice.setIndex(i);
			choice.setText(args["sChoice"+i+"Text"]);
			choice.setLabel(Utils.alphabet[i].toUpperCase());
			choice.addListener(this);
			choices.push(choice);
			i++;
		}
		
		if(profile["bRandomizeChoices"]) {
			//randomizer.randomizePositions(choices);
			ArrayUtils.randomize(choices);
			
		}
		for(var j = 0; j < choices.length; j++) {
			var letter = Utils.alphabet[j].toUpperCase()
			choices[j].setLabel(letter);
			
			trace("SETTING CHOICE TEXT choice "+letter+" - "+choices[j].getText());
			
			choices[j].allowAccess("choice " + letter + " "+ choices[j].getText());
		}
		AccessManager.update();
		layoutChoices();
		
	}
}

