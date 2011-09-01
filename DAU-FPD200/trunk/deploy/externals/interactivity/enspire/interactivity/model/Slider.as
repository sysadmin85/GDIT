import org.asapframework.util.*;

import enspire.interactivity.model.*;
import enspire.interactivity.events.*;


/*
   Class: Slider
   Base class implementing the functionality needed for a basic Slider. 
   
*/
class enspire.interactivity.model.Slider 
	extends InteractivityClip
		implements ISlider {

	private var slideEnabled:Boolean;
	
	private var maxValue:Number;
	private var minValue:Number;
	//private var dragOffset:Number;
	
	
	private var interval:Number;

	
	public function Slider() {
		super();
		slideEnabled = true;
		initHandlers();
	}
	
	
	function getPercentage():Number {
		var maxX = this["mcTrack"]._width; //  - (this["mcHandle"]._width/2);
		var pct = getHandleX() / maxX;
		return pct;
	}
	
	private function getHandleX() {
		//return this["mcHandle"]._x - this["mcTrack"]._x;
		return this["mcHandle"]._x - this["mcTrack"]._x;
	}
	
	function getValue():Number {
		return (getPercentage() * (this.maxValue - this.minValue)) + minValue;
	}
	
	function setMinValue(min:Number):Void {
		this.minValue = min;
	}
	
	function setMaxValue(max:Number):Void {
		this.maxValue = max;
	}
	
	function getMinValue() {
		return this.minValue;
	}
	
	function getMaxValue() {
		return this.maxValue;
	}
	
	private function initHandlers() {
		this["mcHandle"].onPress = function() {
			with(this._parent) {
				if(slideEnabled) {
					handlePress();
					var ce = new SliderEvent(SliderEvent.SLIDER_PRESS,this);
					notifyListeners(ce);
				}
			}
		}
		this["mcHandle"].onRelease = this["mcHandle"].onReleaseOutside = function() {
			with(this._parent) {
				if(slideEnabled) {
					handleRelease();
					var ce = new SliderEvent(SliderEvent.SLIDER_RELEASE,this);
					notifyListeners(ce);
				}
			}
		}
		this["mcHandle"].onRollOver = function() {
			with(this._parent) {
				handleOver();
				var ce = new SliderEvent(SliderEvent.SLIDER_OVER,this);
				notifyListeners(ce);
			}
		}
		this["mcHandle"].onRollOut = function() {
			with(this._parent){
				handleOut();
				var ce = new SliderEvent(SliderEvent.SLIDER_OUT,this);
				notifyListeners(ce);
			}
		}
	}
	
	
	private function followMouse() {
		var newX = this._xmouse; //- dragOffset;
		if(newX < this["mcTrack"]._x) 
			{ newX = this["mcTrack"]._x; }
		if(newX > (this["mcTrack"]._width + this["mcTrack"]._x - (this["mcHandle"]._width/2) )) 
			{ newX = this["mcTrack"]._width + this["mcTrack"]._x - (this["mcHandle"]._width/2); }
		
		this["mcHandle"]._x = newX;
		var se = new SliderEvent(SliderEvent.SLIDER_MOVE,this);
		notifyListeners(se);
		
		this["mcText"].tf.htmlText = getValue();
	}
	
	
	private function handlePress() {
		//dragOffset = this["mcHandle"]._xmouse;
		this["mcHandle"].gotoAndStop("drag");
		this.onEnterFrame = followMouse;
	}
	
	private function handleRelease() {
		this["mcHandle"].gotoAndStop("up");
		this.onEnterFrame = null;
	}
	
	private function handleOver() {
		this["mcHandle"].gotoAndStop("over");
	}
	
	private function handleOut() {
		this["mcHandle"].gotoAndStop("up");
	}
	
}

