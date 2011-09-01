import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;


import com.mosesSupposes.fuse.*;

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;
/*
   Class: SimpleHSDisplay
   Class that manages all of the visual elements related to the Hotspot activity
*/
class enspire.interactivity.display.SimpleHSDisplay 
	implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	private var profile:Object;
	
	private var hotspots:Array;
	
	private var activePopups:Array;
	
	private var read:ReadItem
	private var closeRead:ReadItem;
	private var promptRead:ReadItem;
	public function SimpleHSDisplay() {
		hotspots = new Array();
		activePopups = new Array();
	}
	
	public function showActivity():Void {
		initPrompt();
		initHotspots();
		
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
	
	private function initPrompt() {
		clip.mcPrompt.tf.autoSize = true;
		clip.mcPrompt.tf.htmlText = args["sPrompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		clip.mcPrompt.mcBg._height = Math.max(bgInitHeight,
											  clip.mcPrompt.tf.textHeight + (clip.mcPrompt.tf._y * 2));
		this.promptRead = AccessManager.addItem("content", clip.mcPrompt.tf, clip.mcPrompt.tf.text);
					
	}
	
	
	public function displayEvaluation(e:IEvaluation):Void {

	}
	
	
	/* This catches the events that get fired from the draggers */
	public function notifyEvent(he:HotspotEvent) { 
	
		var hotSpot:HotSpot = HotSpot(he.getObj());
		
		switch(he.getType()) {
			
			case HotspotEvent.HOTSPOT_PRESS:
					hotSpot.gotoAndStop("down");
					removeSelectedHotSpot();
				break;
				
			case HotspotEvent.HOTSPOT_OVER:
					hotSpot.gotoAndPlay("over");
					if(profile["sEvent"] == "roll") {
						showHotspot(hotSpot);
						
					}
				break;

			case HotspotEvent.HOTSPOT_OUT:
					hotSpot.gotoAndPlay("out");
					if(profile["sEvent"] == "roll") {
						removeActivePopups();
					}
				break;

			case HotspotEvent.HOTSPOT_RELEASE:
					trace("release");
					trace(profile["sEvent"]);
					hotSpot.select();
					if(profile["sEvent"] == "release") {
						trace("PASSED IT");
						showHotspot(hotSpot);
					}
				break;
				
		}
	}
	
	
	
	
	private function showHotspot(hotSpot:HotSpot) {
		trace("SHOW HOTSPOT");
		hotSpot.setVisited(true);
			removeActivePopups();
			var labels = Interactivity.getInstance().getLabels();
			if(profile["sPopupType"] == "interactivity") {
				trace("ONSCREEN");
				var popupHolder = hotSpot.getPopupHolder();
				var pop = Interactivity.iTimeline.attachMovie(profile["sPopupSkin"],
												  "popup"+hotSpot.getID(),
												  Interactivity.iTimeline.getNextHighestDepth());
				pop.mcText.tf.autoSize = true;
				pop.mcText.tf.htmlText = hotSpot.getText();
				pop.mcBg._height = pop.mcText._height + pop.mcText._y*2;
				activePopups.push(pop);
				pop.hotspot = hotSpot;
				if(pop["mcClose"] != undefined) {
					pop["controller"] = this;
					pop["mcClose"].onRelease = function() {
						this._parent["controller"].removeActivePopups();
					}
					
					// 508
					var gp = AccessManager.getGroup("content")
					
					this.read = gp.addItemAfter(hotSpot.getAccess() , pop.mcText , hotSpot.getText());
					this.closeRead = gp.addItemAfter(this.read , pop["mcClose"] , "close");
				}
				
				if(popupHolder != undefined) {
					pop._x = popupHolder._x;
					pop._y = popupHolder._y;
				} else {
					if(profile["sMode"] == "follow") {
						ConstructorUtil.createVisualInstance(MouseFollower, pop);
						pop._x = pop._parent._xmouse;
						pop._y = pop._parent._ymouse;
						pop.startFollow();
					} else {
						if(hotSpot._parent["mcPopupHolderAll"] != undefined) {
							pop._x = hotSpot._parent["mcPopupHolderAll"]._x;
							pop._y = hotSpot._parent["mcPopupHolderAll"]._y;
							
						} else {
							pop._x = hotSpot._x;
							pop._y = hotSpot._y;
						}
					}
				}
				
			} else if(profile["sPopupType"] == "template") {
				trace("TEMPLATE");
				var evnt = new PopupEvent();
				evnt.setButtonText(labels.getLabel(profile["sButtonLabel"]));
				evnt.setPopupText(hotSpot.getText());
				Interactivity.getInstance().dispatchInteractivityEvent(evnt);
			}
		checkComplete();
	}
	
	public function checkComplete() {
		var completed = true;
		for(var i = 0; i < hotspots.length; i++) {
			if(!hotspots[i].getVisited()) {
				completed = false;
			}
		}
		if(completed) {
			var evaluation:SimpleEvaluation = new SimpleEvaluation();
			evaluation.setCorrect(true);
			var scoreEvent = new ScoreEvent();
			scoreEvent.setEvaluation(evaluation);
			var inter = Interactivity.getInstance();
			inter.dispatchInteractivityEvent(scoreEvent);
		}
	}
	
	public function removeActivePopups() {
		for(var i = 0; i < activePopups.length; i++) {
			var pop = activePopups[i];
			var spot = pop.hotspot;
			pop.removeMovieClip();
			
			// 508
			this.read.group.removeItem(this.read);
			this.closeRead.group.removeItem(this.closeRead);
			if(spot)
				Selection.setFocus(spot);
			
		}
		activePopups = new Array();
	}
	
	public function removeSelectedHotSpot() {
		for(var i = 0; i < hotspots.length; i++) {
			var spot = hotspots[i];
			spot.deselect();
		}
	}
	
	private function initHotspots() {
		var i = 0;
		var hotspot:HotSpot;
		var popupHolder:MovieClip;
		
		while(args["sHotspot"+i] != undefined) {
			hotspot = clip["mcHotSpot"+i];
			popupHolder = clip["mcPopupHolder"+i];
			ConstructorUtil.createVisualInstance(HotSpot, hotspot);
			hotspot.setID(args["sHotspot"+i]);
			hotspot.setText(args["sHotspot"+i+"Text"]);
			hotspot.setLabel(args["sHotspot"+i+"Label"]);
			hotspot.setPopupHolder(popupHolder);
			
			
			
			// 508
			var rLabel:String = args["sHotspot"+i+"Label"]
			if((!rLabel) || (rLabel == "")) rLabel = "Button "+i;
			var sLab = args["sHotspot"+i+"Label"] == undefined ? "Hotspot "+(i+1) : args["sHotspot"+i+"Label"]
			hotspot.allowAccess(sLab, rLabel, "Press enter to learn more")
			
			
			hotspot.addListener(this);
			hotspots.push(hotspot);
			
			
			
			
			i++;
		}
		AccessManager.update();
	}
}

