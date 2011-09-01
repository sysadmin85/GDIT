import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

/*
   class: SimpleChoiceEvaluation
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.evaluation.SimpleChoiceEvaluation 
	extends SimpleEvaluation 
		implements IEvaluation {
			
	var incorrectChoices:Array;
	var correctChoices:Array;
	
	public function SimpleChoiceEvaluation() {
		
	}
	
	public function getIncorrectChoices():Array {
		return incorrectChoices;
	}
	
	public function setIncorrectChoices(id:Array):Void {
		incorrectChoices = id;
	}
	
	public function getCorrectChoices():Array {
		return correctChoices;
	}
	
	public function setCorrectChoices(cd:Array):Void {
		correctChoices = cd;
	}
	
}

