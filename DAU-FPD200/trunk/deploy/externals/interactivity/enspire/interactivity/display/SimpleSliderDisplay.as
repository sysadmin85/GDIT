import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

import com.mosesSupposes.fuse.*;


/*
   Class: SimpleSliderDisplay
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.display.SimpleSliderDisplay 
	implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	
	public function SimpleSliderDisplay() {

	}
	
	public function showActivity():Void {
		initSlider();
		initPrompt();
	}
	
	public function updateActivity():Void {
		
	}
	
	public function setArgs(a:Object):Void {
		args = a;
	}
	
	public function setClip(c:MovieClip):Void {
		clip = c;
	}
	
	public function getClip():MovieClip {
		return clip;
	}
	
	public function getSlider():Slider {
		return clip["mcSlider"];
	}
	
	public function displayEvaluation(e:IEvaluation):Void {
		
	}
	
	public function notifyEvent(de:SliderEvent) { 

		switch(de.getType()) {
			
			case SliderEvent.SLIDER_PRESS:

				break;
				
			case SliderEvent.SLIDER_OVER:

				break;

			case SliderEvent.SLIDER_OUT:

				break;

			case SliderEvent.SLIDER_RELEASE:

				break;
			
			case SliderEvent.SLIDER_MOVE:
					var slider = getSlider();
					var pct = slider.getPercentage();
					var totalFrames = clip["mcAnimation"]._totalframes;
					var newFrame = Math.round(pct * totalFrames);
					clip["mcAnimation"].gotoAndStop(newFrame);
				break;
				
		}
		
		
	}
	
	private function initSlider() {
		trace(">>>>>>>>>> >>>>>> >>>>> >>>> initingSlider");
		var slider = clip["mcSlider"];
		ConstructorUtil.createVisualInstance(Slider, slider);
		slider.setMaxValue(parseInt(args["nMaxValue"]));
		slider.setMinValue(parseInt(args["nMinValue"]));
		slider.addListener(this);
	}
	
	private function initPrompt() {
		clip.mcPrompt.tf.autoSize = true;
		clip.mcPrompt.tf.htmlText = args["sPrompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		clip.mcPrompt.mcBg._height = Math.max(bgInitHeight,
											  clip.mcPrompt.tf.textHeight + (clip.mcPrompt.tf._y * 2));
	}
	
	
}

