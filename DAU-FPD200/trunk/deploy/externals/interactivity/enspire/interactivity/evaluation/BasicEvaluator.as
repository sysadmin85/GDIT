import org.asapframework.util.ArrayUtils;
import org.asapframework.util.debug.Log;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Class: BasicEvaluator
   Really an abstract class. This will never be instantiated, but is the base class for all Evaluators to
   inherit from. 
*/
class enspire.interactivity.evaluation.BasicEvaluator 
	implements IEvaluator {
		
	private var numTries;
	
	public function BasicEvaluator() {
		numTries = 0;
	}
	
	public function evaluate():IEvaluation {
		var evaluation:IEvaluation;
		return evaluation;
	}
	
	public function getNumTries() {
		return numTries;
	}
	
	
}