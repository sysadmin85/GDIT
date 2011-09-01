import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Class: SimpleEvaluation
    
	This is the most basic implementation of IEvaluation. This is the Evaluation type you 
	should use if you only need to know the correctness of a users answer, and possibly the number 
	of attempts by the user. If you require more in depth information to be contained within these evaluations, 
	simply extend from this class.
*/

class enspire.interactivity.evaluation.SimpleMultSliderEvaluation 
	extends SimpleEvaluation 
		implements IEvaluation {
	
	
	private var evaluations:Array;
	
	public function SimpleMultSliderEvaluation() {
		super();
	}
	
	public function getEvaluations():Array {
		return evaluations;
	}
	
	public function setEvaluations(e:Array) {
		evaluations = e;
	}
	
}

