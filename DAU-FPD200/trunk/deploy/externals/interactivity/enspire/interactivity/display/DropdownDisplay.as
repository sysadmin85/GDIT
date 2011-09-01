import mx.controls.ComboBox;

import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;
import enspire.interactivity.*;

import com.mosesSupposes.fuse.*;

/*
   Class: SimpleSequencingDisplay
   Class that manages all of the visual elements related to the Sequencing activity
*/
class enspire.interactivity.display.DropdownDisplay implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	private var profile:Object;
	
	private var dropdowns:Array;
	
	
	private var inFeedbackPhase;
	private var activePopups;
	
	public function DropdownDisplay() {
		dropdowns = new Array();
		inFeedbackPhase = false;
	}
	
	public function showActivity():Void {
		initDropdowns();
		initPrompt();
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
		//previousEvaluation = e;
		
		var labels = Interactivity.getInstance().getLabels();
		var isCorrect:Boolean = e.getCorrect();
		
		var displayText;
		
		//if(profile["sFeedbackType"] == "general") {
		
			if(isCorrect) {
				displayText = args["sCorrectFeedback"];
			} else {
				displayText = args["sIncorrectFeedback"];
			}
			
		//} 
		
		var evnt = new PopupEvent();
		
		if(isCorrect) {
			evnt.setButtonText(labels.getLabel(profile["sLabelCorrect"]));
		} else {
			if(e.getNumTries() >= parseInt(profile["nTries"])) {
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
		
		if(profile["sFeedbackType"] == "ranked") {
			displayText = dropdowns[0].getFeedbackText();
		}
		
		evnt.setPopupText(displayText);
		Interactivity.getInstance().dispatchInteractivityEvent(evnt);
	}
	
	public function revealAnswers() {
		
	}
	
	public function getDropdowns():Array {
		return dropdowns;
	}	
	
	/* This catches the events that get fired from the dropdowns */
	public function notifyEvent(e:Object) { 
		
		
	}
	private function initDropdowns() {
		var i = 0; 
		while(args["sDrop"+i+"Text"] != undefined) {
			
			if(clip["mcLabel"+i] != undefined) {
				clip["mcLabel"+i].tf.text = args["sDrop"+i+"Label"];
			}
			var cb:ComboBox = ComboBox(clip["mcCombo"+i]);
			var aChoices = args["sDrop"+i+"Text"].split(",");
			
			cb.addItem("");

			for(var j:Number = 0; j < aChoices.length; j++) {
				cb.addItem(aChoices[j]);
			}
			dropdowns.push(cb);
			i++;
		}
	}
	
	private function initPrompt() {
		clip.mcPrompt.mcText.tf.autoSize = true;
		clip.mcPrompt.mcText.tf.htmlText = args["sPrompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		clip.mcPrompt.mcBg._height = clip.mcPrompt.mcText._height + (clip.mcPrompt.mcText._y * 2);
	}
	
	
}

