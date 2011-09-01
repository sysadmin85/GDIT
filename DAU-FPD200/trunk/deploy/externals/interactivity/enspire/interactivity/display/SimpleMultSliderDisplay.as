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
class enspire.interactivity.display.SimpleMultSliderDisplay 
	implements IActivityDisplay {
		
	private var clip:MovieClip;
	private var args:Object;
	
	private var sliders:Array;
	private var widgets:Array;
	
	private var currentWidget:LikertWidget;
	
	public function SimpleMultSliderDisplay() {
		sliders = new Array();
		widgets = new Array();
	}
	
	public function showActivity():Void {
		initSliders();
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
	
	public function getSliders():Array {
		return sliders;
	}
	
	public function displayEvaluation(e:IEvaluation):Void {
		trace("Display Evaluation");
		var evaluations = SimpleMultSliderEvaluation(e).getEvaluations();
		for(var i = 0; i < evaluations.length; i++) {
			var evaluation = evaluations[i];
			var slider = sliders[i];
			var widget = widgets[i];
			widget.enableFeedback();
			slider.setGhostSliderToValue(600);
			if(evaluation.getCorrect()) {
				widget.showCorrect();
				slider.setCorrect();
			} else {
				widget.showIncorrect();
				slider.setIncorrect();
			}
		}
		layoutWidgets();
	}
	
	public function notifyEvent(de:IInteractivityClipEvent) { 
	
		switch(de.getType()) {
			
			/* CATCHING EVENTS FOR THE LIKERT WIDGETS */
			case LikertEvent.LIKERT_PRESS:

				break;
				
			case LikertEvent.LIKERT_OVER:

				break;

			case LikertEvent.LIKERT_OUT:

				break;

			case LikertEvent.LIKERT_RELEASE:
					var newWidget = de.getObj();
					trace(de.getObj());
					if(currentWidget != undefined) {
						currentWidget.hideFeedback();
					}
					
					if(newWidget.getFeedbackEnabled()) {
						LikertWidget(de.getObj()).showFeedback();
					}
					currentWidget = newWidget;
					layoutWidgets();
					
				break;
			
			case LikertEvent.LIKERT_MOVE:

				break;
	

			/* CATCHING EVENTS FOR THE LIKERT SLIDERS WIDGETS */
			case SliderEvent.SLIDER_PRESS:

				break;
				
			case SliderEvent.SLIDER_OVER:

				break;

			case SliderEvent.SLIDER_OUT:

				break;

			case SliderEvent.SLIDER_RELEASE:

				break;
			
			case SliderEvent.SLIDER_MOVE:

				break;
				
		}
	}
	
	
	private function layoutWidgets() {
		var yOff = 0;
		for(var i = 0; i < widgets.length; i++) {
			widgets[i]._y = yOff;
			yOff += widgets[i].getHeight() + 5;
		}
	}
	
	private function initSliders() {
		var i = 0; 
		while(args["slider"+i] != undefined) {
			
			var widget = clip["mcPromptHolder"]["mcSlider" + i];
			ConstructorUtil.createVisualInstance(LikertWidget, widget);
			ConstructorUtil.createVisualInstance(LikertSlider, widget["mcSlider"]);
			
			widget["mcSlider"].setMaxValue(parseInt(args["slider"+i+"MaxValue"]));
			widget["mcSlider"].setMinValue(parseInt(args["slider"+i+"MinValue"]));
			
			widget.setText(args["slider"+i+"Feedback"]);
			widget.setFeedbackText(args["slider"+i+"Feedback"]);
			
			widget["mcSlider"].addListener(this);
			widget.addListener(this);
			
			widgets.push(widget);
			sliders.push(widget["mcSlider"]);
			i++;
		}
		
		layoutWidgets();
		
	}
	
	private function initPrompt() {
		clip.mcPrompt.tf.autoSize = true;
		clip.mcPrompt.tf.htmlText = args["prompt"];
		var bgInitHeight = clip.mcPrompt.mcBg._height;
		clip.mcPrompt.mcBg._height = Math.max(bgInitHeight,
											  clip.mcPrompt.tf.textHeight + (clip.mcPrompt.tf._y * 2));
	}
	
	
}

