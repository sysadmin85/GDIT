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
class enspire.interactivity.display.SimpleSequencingDisplay implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	private var profile:Object;
	
	private var draggers:Array;
	
	private var draggerXLocks:Array;
	private var draggerYLocks:Array;
	
	private var ghostDragger:MovieClip;
	
	private var inFeedbackPhase;
	private var activePopups;
	
	private var randomizer:VisualRandomizer;
	
	private var DRAGGER_TWEEN_TIME = .40;
	
	public function SimpleSequencingDisplay() {
		draggers = new Array();
		randomizer = new VisualRandomizer();
		draggerXLocks = new Array();
		draggerYLocks = new Array();
		ghostDragger = new MovieClip();
		inFeedbackPhase = false;
	}
	
	public function showActivity():Void {
		initDraggers();
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
			displayText = draggers[0].getFeedbackText();
		}
		
		evnt.setPopupText(displayText);
		Interactivity.getInstance().dispatchInteractivityEvent(evnt);
	}
	
	public function revealAnswers() {
		for(var i = 0; i < draggers.length; i++) {
			draggers[i].disableDrag();
		}
		if(profile["sFeedbackType"] == "specific") {
			inFeedbackPhase = true;
		}
	}
	
	public function getDraggers():Array {
		return draggers;
	}
	
	public function updateDraggerLocations() {
		var dragger:Dragger;
		for(var i = 0; i < draggers.length; i++) {
			if(draggers[i] != ghostDragger) {
				dragger = Dragger(draggers[i]);
				ZigoEngine.doTween(dragger,"_x",draggerXLocks[i],DRAGGER_TWEEN_TIME);
				ZigoEngine.doTween(dragger,"_y",draggerYLocks[i],DRAGGER_TWEEN_TIME);
			}
		}
	}
	
	
	/* This catches the events that get fired from the draggers */
	public function notifyEvent(de:DraggerEvent) { 
	
		var dragger:Dragger = Dragger(de.getObj());
		
		switch(de.getType()) {
			
			case DraggerEvent.DRAGGER_MOVE:
				var new_y = dragger._y;
				var newIndex = 0;
				
				while(draggerYLocks[newIndex] < new_y) {
					newIndex++;
				}
				
				newIndex = newIndex;
				
				if(ArrayUtils.findElement(draggers,ghostDragger) != newIndex) {
					ArrayUtils.removeElement(draggers,ghostDragger);
					ArrayUtils.insertElementAt(draggers, newIndex, ghostDragger);
				}
				updateDraggerLocations();
				
				break;
				
			case DraggerEvent.DRAGGER_OVER:
				trace("OVER!!!");
				if(inFeedbackPhase) {
					trace("SATISFY");
					showHotspot(dragger);
				}
				
				break;
				
			case DraggerEvent.DRAGGER_OUT:
				
				if(inFeedbackPhase) {
					removeActivePopups();
				}
				
				break;
				
			case DraggerEvent.DRAGGER_PRESS:
				dragger.swapDepths(10000);
				var insertPoint = ArrayUtils.findElement(draggers,dragger);
				ArrayUtils.removeElement(draggers,dragger);
				ArrayUtils.insertElementAt(draggers, insertPoint, ghostDragger);
				updateDraggerLocations();
				break;
				
				
			case DraggerEvent.DRAGGER_RELEASE:
				var insertPoint = ArrayUtils.findElement(draggers,ghostDragger);
				if(insertPoint != - 1) {
					ArrayUtils.removeElement(draggers,ghostDragger);
					ArrayUtils.insertElementAt(draggers, insertPoint, dragger);
				}
				updateDraggerLocations();
				break;
		}
	}
	
	
	private function showHotspot(dragger) {
			removeActivePopups();
			//var popupHolder = hotSpot.getPopupHolder();
			var pop = Interactivity.iTimeline.attachMovie("HotSpotPopup_0",
											  "popup"+dragger.getID(),
											  Interactivity.iTimeline.getNextHighestDepth());
			ConstructorUtil.createVisualInstance(MouseFollower, pop);
			pop._visible = false;
			
			
			pop._x = pop._parent._xmouse;
			pop._y = pop._parent._ymouse;
			pop.mcText.tf.autoSize = true;
			pop.mcText.tf.htmlText = dragger.getFeedbackText();
			pop.mcBg._height = pop.mcText.tf.textHeight + pop.mcText._y + 5;
			activePopups.push(pop);
			
			
			pop.startFollow();
	}
	
	public function removeActivePopups() {
		for(var i = 0; i < activePopups.length; i++) {
			var pop = activePopups[i];
			pop.removeMovieClip();
		}
		activePopups = new Array();
	}
	
	
	private function initDraggers() {
		var i = 0; 
		while(args["sDragger"+i] != undefined) {
			ConstructorUtil.createVisualInstance(Dragger, clip["mcDragger"+i]);
			draggerXLocks.push(clip["mcDragger"+i]._x);
			draggerYLocks.push(clip["mcDragger"+i]._y);
			clip["mcDragger"+i].setID(args["sDragger"+i]);
			clip["mcDragger"+i].setText(args["sDragger"+i+"Name"]);
			clip["mcDragger"+i].setFeedbackText(args["sDragger"+i+"Feedback"]);
			clip["mcDragger"+i].addListener(this);
			draggers.push(clip["mcDragger"+i]);
			i++;
		}
		draggerXLocks.sort(Array.NUMERIC);
		draggerYLocks.sort(Array.NUMERIC);
		
		if(profile["bRandomizeChoices"]) {
			ArrayUtils.randomize(draggers);
			for(var j = 0; j < draggers.length; j++) {
				draggers[j]._x = draggerXLocks[j];
				draggers[j]._y = draggerYLocks[j];
			}
		}
	}
	
	private function initPrompt() {
		clip.mcPrompt.mcText.tf.autoSize = true;
		clip.mcPrompt.mcText.tf.htmlText = args["sPrompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		clip.mcPrompt.mcBg._height = clip.mcPrompt.mcText._height + (clip.mcPrompt.mcText._y * 2);
	}
	
	
}

