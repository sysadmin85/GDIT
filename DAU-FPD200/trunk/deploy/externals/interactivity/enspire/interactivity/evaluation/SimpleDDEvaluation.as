import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   class: SimpleDDEvaluation
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.evaluation.SimpleDDEvaluation
	extends SimpleEvaluation
		implements IEvaluation {

	var incorrectDraggers:Array;
	var correctDraggers:Array;
	
	public function SimpleDDEvaluation() {
		
	}
	
	public function getIncorrectDraggers():Array {
		return incorrectDraggers;
	}
	
	public function setIncorrectDraggers(id:Array):Void {
		incorrectDraggers = id;
	}
	
	public function getCorrectDraggers():Array {
		return correctDraggers;
	}
	
	public function setCorrectDraggers(cd:Array):Void {
		correctDraggers = cd;
	}
	
}

