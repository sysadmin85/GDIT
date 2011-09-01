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
   Class: LikertWidget
   Base class implementing the functionality needed for a basic Slider. 
   
*/
class enspire.interactivity.model.LikertWidget 
	extends InteractivityClip {

	private var feedbackEnabled:Boolean;
	
	public function LikertWidget() {
		super();
		this["mcFeedback"]._visible = false;
		this["mcBg"]["mcCorrect"]._visible = false;
		this["mcBg"]["mcIncorrect"]._visible = false;
		feedbackEnabled = false;
		initHandlers();
	}
	
	public function enableFeedback() {
		feedbackEnabled = true;
	}
	
	public function getFeedbackEnabled() {
		return feedbackEnabled;
	}
	

	private function initHandlers() {
		this["mcBg"].onPress = function() {
			with(this._parent) {
				likertPress();
				var ce = new LikertEvent(LikertEvent.LIKERT_PRESS,this._parent);
				notifyListeners(ce);
			}
		}
		this["mcBg"].onRelease = this["mcBg"].onReleaseOutside = function() {
			with(this._parent) {
				likertRelease();
				var ce = new LikertEvent(LikertEvent.LIKERT_RELEASE,this._parent);
				notifyListeners(ce);
			}
		}
		this["mcBg"].onRollOver = function() {
			with(this._parent) {
				likertOver();
				var ce = new LikertEvent(LikertEvent.LIKERT_OVER,this._parent);
				notifyListeners(ce);
			}
		}
		this["mcBg"].onRollOut = function() {
			with(this._parent) {
				likertOut();
				var ce = new LikertEvent(LikertEvent.LIKERT_OUT,this._parent);
				notifyListeners(ce);
			}
		}
	}
	
	private function likertPress() {
		//this.gotoAndPlay("down");
		if(feedbackEnabled) {
			this["mcBg"].gotoAndStop("over");
			trace("likert press");
		}
	}
	
	private function likertRelease() {
		if(feedbackEnabled) {
			this["mcBg"].gotoAndStop("over");
			//this.gotoAndPlay("over");
		}
	}
	
	private function likertOver() {
		trace("likert over");
		if(feedbackEnabled) {
			this["mcBg"].gotoAndStop("over");
			//this.gotoAndPlay("over");
		}
	}
	
	private function likertOut() {
		trace("likert out");
		if(feedbackEnabled) {
			this["mcBg"].gotoAndStop("up");
			//this.gotoAndPlay("out");
		}
	}
	

	
	public function showCorrect() {
		this["mcBg"]["mcCorrect"]._visible = true;
		this["mcBg"]["mcIncorrect"]._visible = false;
	} 
	
	public function showIncorrect() {
		this["mcBg"]["mcCorrect"]._visible = false;
		this["mcBg"]["mcIncorrect"]._visible = true;
	}
	
	public function showFeedback() {
		this["mcFeedback"]._visible = true;
	}
	
	public function hideFeedback() {
		this["mcFeedback"]._visible = false;
	}
	
	public function setText(t:String) {
		this["tf"].htmlText = t;
	}
	
	public function setFeedbackText(t:String) {
		this["mcFeedback"].tf.htmlText = t;
	}
	
	public function getHeight() {
		if(this["mcFeedback"]._visible) {
			return this["mcBg"]._height + this["mcFeedback"]._height;
		} else {
			return this["mcBg"]._height;
		}
	}

}

