import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

import mx.utils.Delegate;

import enspire.accessibility.AccessManager;

/*
   Class: SubmitButton
   Generic submit button for all of your submitting needs
   
*/
class enspire.interactivity.model.SubmitButton extends MovieClip {
	
	private var disabled:Boolean;
	private var callbackScope:Object;
	private var callback:Function;
	
	public function SubmitButton() {
		super();
		initHandlers();
		disabled = false;
	}
	
	public function setText(t:String) {
		this["mcText"].tf.htmlText = t;
		this["mcBg"]._width = this["mcText"].tf.textWidth + 50;
		
		AccessManager.addItem("content", this, t);
	}
	
	public function setCallback(scope:Object, func:Function) {
		callbackScope = scope;
		callback = func;
	}
	
	public function disable() {
		trace("disabling");
		disabled = true;
		this.enabled = this.tabEnabled = false;
		this.gotoAndStop("disabled");
		this["mcBg"].gotoAndPlay("disabled");
	}
	
	public function enable() {
		trace("enable");
		this.enabled = this.tabEnabled = true;
		this.gotoAndStop("up");
		this["mcBg"].gotoAndPlay("up");
		disabled = false;
	}
	
	private function initHandlers() {
		trace("init handlers");
		this.onPress = function() {
			if(disabled) { return; }
			this["mcBg"].gotoAndPlay("down");

		}
		this.onRelease = this.onReleaseOutside = function() {
			if(disabled) { return; }
			this["mcBg"].gotoAndPlay("up");
			Delegate.create(callbackScope,callback)();
		}
		this.onRollOver = function() {
			if(disabled) { return; }
			this["mcBg"].gotoAndPlay("over");
		}
		this.onRollOut = function() {
			if(disabled) { return; }
			this["mcBg"].gotoAndPlay("out");
		}
		this.onMouseMove = function() {

		}
	}
}

