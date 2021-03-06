﻿import enspire.interactivity.events.*;
import enspire.interactivity.evaluation.*;


/*
   Class: ScoreEvent
   Event dispatched from the Interactivity API each time that an activity is evaluated. In addition 
   to the functionality packaged in InteractivityEvent, ScoreEvents also bundle up the <IEvaluation>
   generated by the activity's Evaluator. 
   
   Example usage:
   (start code)
   function notifyInteractivityEvent(e:InteractivityEvent) {
		if(e instanceof ScoreEvent) {
			var evaluation:IEvaluation = e.getEvaluation();
			trace(evaluation.getNumTries());
			trace(evaluation.getCorrect());
		}
	}
	(end)
*/
class enspire.interactivity.events.ScoreEvent 
	extends InteractivityEvent {
	
	private var evaluation:IEvaluation;
	
	public function ScoreEvent(type:Number, data:Object) {
		super();
		this.type = InteractivityEvent.SCORE;
	}

	/* Function: getEvaluation
       Returns the evaluation associated with this ScoreEvent
	   
	   Example:
	   (start example)
	   		var evaluation:IEvaluation = e.getEvaluation();
			trace(evaluation.getNumTries());
			trace(evaluation.getCorrect());
	   (end)
    */
	public function getEvaluation():IEvaluation {
		return this.evaluation;
	}
	
	public function setEvaluation(evaluation:IEvaluation) {
		this.evaluation = evaluation;
	}
	
	public function traceMe() {

	}
	
	
	
}

