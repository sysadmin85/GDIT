import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Class: Dragger
   Base class implementing the functionality needed for a basic Dragger. 
   
*/
class enspire.interactivity.model.Dragger 
	extends InteractivityClip
		implements ISortingElement {
	
	private var initialX;
	private var initialY;
	
	private var dragEnabled:Boolean;
	private var feedbackEnabled:Boolean;
	private var dragging:Boolean;
	
	private var bin:IBin;
	
	private var feedbackText;
	private var displayText;
	
	//public var draggerPress;
	
	public function Dragger() {
		super();
		dragEnabled = true;
		dragging = false;
		initHandlers();
	}
	
	public function saveInitialPosition() {
		this.initialX = this._x;
		this.initialY = this._y;
	}
	
	public function setText(t:String) {
		this["mcText"].tf.autoSize = true;
		this["mcText"].tf.htmlText = t;
		var padding = (this["mcBg"]._height - this["mcText"]._height) / 2;
		this["mcText"]._y = padding;
		displayText = t;
	}
	
	public function setFeedbackText(t:String) {
		feedbackText = t;
	}
	
	public function getFeedbackText() {
		return feedbackText;
	}
	
	public function getInitialX() {
		return this.initialX;
	}
	
	public function getInitialY() {
		return this.initialY;
	}
	
	public function setBin(b:IBin):Void {
		this.bin = b;
	}
	
	public function getBin():IBin {
		return this.bin;
	}
	
	public function enableDrag() {
		dragEnabled = true;
		this.enabled = true;
	}
	
	public function disableDrag() {
		dragEnabled = false;
		//this.enabled = false;
		//this.gotoAndStop("disabled");
	}
	
	public function disable() {
		this.enabled = false;
		this.gotoAndStop("disabled");
	}
	
	private function initHandlers() {
		this.onPress = function() {
			if(dragEnabled) {
				draggerPress();
				var de = new DraggerEvent(DraggerEvent.DRAGGER_PRESS,this);
				notifyListeners(de);
			}
		}
		this.onRelease = this.onReleaseOutside = function() {
			if(dragEnabled) {
				draggerRelease();
				var de = new DraggerEvent(DraggerEvent.DRAGGER_RELEASE,this);
				notifyListeners(de);
			}
		}
		this.onRollOver = function() {
			draggerOver();
			var de = new DraggerEvent(DraggerEvent.DRAGGER_OVER,this);
			if(feedbackEnabled) {
				
			}
			notifyListeners(de);
		}
		this.onRollOut = function() {
			draggerOut();
			var de = new DraggerEvent(DraggerEvent.DRAGGER_OUT,this);
			notifyListeners(de);
		}
		this.onMouseMove = function() {
			if(dragging) {
				var de = new DraggerEvent(DraggerEvent.DRAGGER_MOVE,this);
				notifyListeners(de);
			}
		}
	}
	
	
	private function draggerPress() {
		if(!dragEnabled) { return; }
		this.startDrag();
		this.gotoAndPlay("down");
		dragging = true;
	}
	
	
	private function draggerRelease() {
		if(!dragEnabled) { return; }
		this.stopDrag();
		this.gotoAndPlay("up");
		dragging = false;
	}
	
	private function draggerOver() {
		//if(!dragEnabled) { return; }
		this.gotoAndPlay("over");
	}
	
	private function draggerOut() {
		//if(!dragEnabled) { return; }
		this.gotoAndPlay("out");
		dragging = false;
	}
	
}

