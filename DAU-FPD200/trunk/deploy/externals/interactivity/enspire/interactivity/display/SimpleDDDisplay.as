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
   Class: SimpleDDDisplay
   Class that manages all of the visual elements related to the Drag and Drop / Sorting activity
*/
class enspire.interactivity.display.SimpleDDDisplay 
	implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	private var profile:Object;
	
	private var draggers:Array;
	private var bays:Array;
	
	private var previousEvaluation:IEvaluation;
	
	private var randomizer:VisualRandomizer;
	
	private var DRAGGER_TWEEN_TIME = .40;
	
	private var inFeedbackPhase;
	
	private var activePopups;
	
	public function SimpleDDDisplay() {
		draggers = new Array();
		bays = new Array();
		randomizer = new VisualRandomizer();
		inFeedbackPhase = false;
	}
	
	public function showActivity():Void {
		initDraggers();
		initBays();
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
	
	public function moveIncorrectDraggers() {
		var ddEval:SimpleDDEvaluation = SimpleDDEvaluation(previousEvaluation);
		var incorrectDraggers = ddEval.getIncorrectDraggers();
		var correctDraggers = ddEval.getCorrectDraggers();
		var drag:Dragger;
		
		for(var i = 0; i < incorrectDraggers.length; i++) {
			drag = incorrectDraggers[i];
			ZigoEngine.doTween(drag,"_x",[drag.getInitialX()],DRAGGER_TWEEN_TIME);
			ZigoEngine.doTween(drag,"_y",[drag.getInitialY()],DRAGGER_TWEEN_TIME);
			var bin = drag.getBin();
			if(bin != undefined) {
				bin.removeElementFromBin(drag);
				Bay(bin).applyLayout();
			}
		}
		
		for(var k = 0; k < correctDraggers.length; k++) {
			drag = correctDraggers[k];
			drag.disableDrag();
			if(profile["sFeedbackType"] == "general") { 
				// if this isn't going to turn into a hotspot, disable it for good
				drag.disable();
			}
		}
	}
	
	public function revealAnswers() {
		trace("revealing answers");
		var i = 0;
		while(args["sBay"+i] != undefined) {
			var bay = clip["mcBay"+i];
			var targetIds = args["sBay"+i+"Draggers"].split(",");
			for(var j = 0; j < targetIds.length; j++) {
				var targetID = targetIds[j];
				for(var k = 0; k < draggers.length; k++) {
					var dragger = draggers[k];
					var draggerID = dragger.getID();
					if(draggerID == targetID) {
						var bin = dragger.getBin();
						if(bin != undefined) {
							bin.removeElementFromBin(dragger);
							bin.applyLayout();
						}
						dragger["assigned"] = true;
						bay.addElementToBin(dragger);
						bay.applyLayout();
					}
				}
			}
			i++;
		}
		for(var q = 0; q < draggers.length; q++) {
			var dragger = draggers[q];
			dragger.disableDrag();
			if(dragger["assigned"] == undefined) {
				if(dragger.getBin() != undefined) {
					dragger.getBin().removeElementFromBin(dragger);
					draggers[q].getBin().applyLayout();
					if(profile["sFeedbackType"] == "general") { 
						// if this isn't going to turn into a hotspot, disable it for good
						dragger.disable();
					}
				}
				ZigoEngine.doTween(dragger,"_x",[dragger.getInitialX()],DRAGGER_TWEEN_TIME);
				ZigoEngine.doTween(dragger,"_y",[dragger.getInitialY()],DRAGGER_TWEEN_TIME);
			}
			if(profile["sFeedbackType"] == "general") { 
				// if this isn't going to turn into a hotspot, disable it for good
				dragger.disable();
			}
		}
		if(profile["sFeedbackType"] == "specific") {
			inFeedbackPhase = true;
		}
	}
	
	public function displayEvaluation(e:IEvaluation):Void {		
		previousEvaluation = e;
		
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
		
		evnt.setPopupText(displayText);
		Interactivity.getInstance().dispatchInteractivityEvent(evnt);
	}
	
	
	/* This catches the events that get fired from the draggers */
	public function notifyEvent(de:DraggerEvent) { 
		switch(de.getType()) {
			
			case DraggerEvent.DRAGGER_MOVE:
				
				for(var i = 0; i < bays.length; i++) {
					if(bays[i].hitTest(_root._xmouse, _root._ymouse)) {
						//bays[i].gotoAndStop("draggerOver");
					} else {
						//bays[i].gotoAndStop("up");
					}
				}
				
				break;
				
			case DraggerEvent.DRAGGER_OVER:
				
				if(inFeedbackPhase) {
					var dragger = de.getObj();
					trace(dragger.getFeedbackText());
					showHotspot(dragger);
				}
				
				break;
				
			case DraggerEvent.DRAGGER_OUT:
				
				if(inFeedbackPhase) {
					var dragger = de.getObj();
					//trace(dragger.getFeedbackText());
					removeActivePopups();
				}
				
				break;
				
			case DraggerEvent.DRAGGER_PRESS:
					
					var drag = de.getObj();
					drag.swapDepths(10000);
					var bin = drag.getBin();
					if(bin != undefined) {
						bin.removeElementFromBin(drag);
						Bay(bin).applyLayout();
					}
				
				break;
				
				
			case DraggerEvent.DRAGGER_RELEASE:
				var inBay = false;
				for(var i = 0; i < bays.length; i++) {
					//bays[i].gotoAndStop("up");
					if(bays[i].hitTest(_root._xmouse, _root._ymouse)) {
						var bay = bays[i];
						if(bay.getElementsInBin().length < bay.getCapacity()) {
							bay.addElementToBin(de.getObj());
							bay.applyLayout();
							inBay = true;
						}
					}
					
				}
				if(!inBay) {
					var drag = de.getObj();
					var bin = drag.getBin();
					if(bin != undefined) {
						bin.removeElementFromBin(drag);
						Bay(bin).applyLayout();
					}
					ZigoEngine.doTween(drag,"_x",[drag.getInitialX()],DRAGGER_TWEEN_TIME);
					ZigoEngine.doTween(drag,"_y",[drag.getInitialY()],DRAGGER_TWEEN_TIME);
				}
				
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
	
	private function initPrompt() {
		clip.mcPrompt.tf.autoSize = true;
		clip.mcPrompt.tf.htmlText = args["sPrompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		clip.mcPrompt.mcBg._height = Math.max(bgInitHeight,
											  clip.mcPrompt.tf.textHeight + (clip.mcPrompt.tf._y * 2));
	}
	
	private function initDraggers() {
		var i = 0; 
		while(args["sDragger"+i] != undefined) {
			var dragger = clip["mcDragger"+i];
			ConstructorUtil.createVisualInstance(Dragger, dragger);
			dragger.setID(args["sDragger"+i]);
			dragger.setText(args["sDragger"+i+"Name"]);
			dragger.setFeedbackText(args["sFeedback" + i]);
			dragger.addListener(this);
			draggers.push(dragger);
			i++;
		}
		if(profile["bRandomizeChoices"]) {
			randomizer.randomizePositions(draggers);
		}
		for(var i = 0; i < draggers.length; i++) {
			draggers[i].saveInitialPosition();
		}
	}
	
	private function initBays() {
		var i = 0; 
		while(args["sBay"+i] != undefined) {
			ConstructorUtil.createVisualInstance(Bay, clip["mcBay"+i]);
			bays.push(clip["mcBay"+i]);
			clip["mcBay"+i].setID(args["sBay"+i]);
			clip["mcBay"+i].setText(args["sBay"+i+"Text"]);
			clip["mcBay"+i].setCapacity(parseInt(args["sBay"+i+"Capacity"]));
			i++;
		}
	}
	
}

