import org.asapframework.util.*;



import enspire.interactivity.model.*;
import enspire.interactivity.events.*;


/*
   Class: Choice
   Base class implementing the functionality needed for a basic Choice. 
   
*/
class enspire.interactivity.model.Choice 
	extends InteractivityClip
		implements IChoice {
	
	private var bSelected:Boolean;
	private var chooseEnabled:Boolean;
	
	private var initBGHeight:Number;
	
	public function Choice() {
		super();
		initBGHeight = this["mcBg"]._height;
		chooseEnabled = true;
		deselect();
		initHandlers();
	}
	
	public function isSelected():Boolean {
		return bSelected;
	}
	
	public function select():Void {
		bSelected = true;
		this["mcSelected"]._visible = true;
		this["mcBg"].mcSelected._visible = true;
	}
	
	public function deselect():Void {
		bSelected = false;
		this["mcSelected"]._visible = false;
		this["mcBg"].mcSelected._visible = false;
	}
	
	public function setText(t:String) {
		this["mcText"].tf.autoSize = true;
		this["mcText"].tf.htmlText = t;
		this["mcBg"]._height = Math.max(initBGHeight,
										this["mcText"]._height + (this["mcText"]._y * 2));
		
		
	}
	public function getText() {
		return this["mcText"].tf.text;
	}
	
	public function disable() {
		this.enabled = false;
		this.tabEnabled =  false;
	}
	
	public function setLabel(t:String) {
		this["mcLabel"].tf.htmlText = t;
	}
	
	
	private function initHandlers() {
		this.onPress = function() {
			choicePress();
			var ce = new ChoiceEvent(ChoiceEvent.CHOICE_PRESS,this);
			notifyListeners(ce);
		}
		this.onRelease = this.onReleaseOutside = function() {
			choiceRelease();
			var ce = new ChoiceEvent(ChoiceEvent.CHOICE_RELEASE,this);
			notifyListeners(ce);
		}
		this.onRollOver = function() {
			choiceOver();
			var ce = new ChoiceEvent(ChoiceEvent.CHOICE_OVER,this);
			notifyListeners(ce);
		}
		this.onRollOut = function() {
			choiceOut();
			var ce = new ChoiceEvent(ChoiceEvent.CHOICE_OUT,this);
			notifyListeners(ce);
		}
	}
	
	private function choicePress() {
		this.gotoAndPlay("down");
	}
	
	private function choiceRelease() {
		trace("choice release parente");
		if(chooseEnabled) {
			trace("choose enabled parente");
			if(isSelected()) {
				deselect();
			} else {
				select();
			}
		}
	}
	
	private function choiceOver() {
		this.gotoAndPlay("over");
	}
	
	private function choiceOut() {
		this.gotoAndPlay("out");
	}
	
	
}

