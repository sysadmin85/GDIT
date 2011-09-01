import org.asapframework.util.*;

import enspire.interactivity.model.*;
import enspire.interactivity.events.*;


/*
   Class: LikertSlider
   Base class implementing the functionality needed for a basic Slider. 
   
*/
class enspire.interactivity.model.LikertSlider 
	extends Slider {

	
	public function LikertSlider() {
		super();
		initState();
	}
	
	public function initState() {
		this["mcGhostHandle"]._visible = false;
		this["mcHandle"].mcCorrect._visible = false;
		this["mcHandle"].mcIncorrect._visible = false;
	}
	
	public function setCorrect() {
		this["mcHandle"].mcCorrect._visible = true;
		this["mcHandle"].mcIncorrect._visible = false;
	}
	
	public function setIncorrect() {
		this["mcHandle"].mcCorrect._visible = false;
		this["mcHandle"].mcIncorrect._visible = true;
	}
	
	public function setGhostSliderToValue(v:Number) {
		var span = getMaxValue() - getMinValue();
		var adjusted = v - getMinValue();
		var targetPct = adjusted / span;
		var newX = (targetPct * this["mcTrack"]._width);
		this["mcGhostHandle"]._x = newX;
		this["mcGhostHandle"]._visible = true;
		this["mcGhostHandle"].mcCorrect._visible = true;
		this["mcGhostHandle"].mcIncorrect._visible = false;
		this["mcGhostHandle"]._alpha = 30;
	}

}

