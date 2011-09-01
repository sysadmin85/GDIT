import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

/*
   Interface: IActivityDisplay
   All activity displays must implement this interface. The corresponding controller for any given
   activity will make a call to <showActivity> to kick off the display of the interactivity. Each
   time that an activity is evaluated, the resulting <IEvaluation> is passed to the display, and it
   is the display's job to appropriately display the results of the evaluation.
*/
interface enspire.interactivity.display.IActivityDisplay {
	
	/* Function: showActivity
       Called by the corresponding activity controller to kick off the displaying of the interactivity.
	   Normally, the implementation of this function should result in the attaching of clips (choices, etc), 
	   or the assignment of classes and functionality to on-stage assets (looping over mcDraggers, etc).
    */
	function showActivity():Void;
	
	/* Function: displayEvaluation
       After evaluating the state of an activity, we want the display to act appropriately upon the findings. We send
	   the resulting <IEvaluation> to the display, and the implementation of this function should appropriately
	   change the appearance of the activity. For example, in a drag and drop style activity. The evaluation will
	   contain references to the draggers that are incorrectly placed. It is the responsibility of the activity display
	   to return those draggers to their initial positions.
    */
	function displayEvaluation(e:IEvaluation):Void;
	
	/* Function: getClip
       Returns the movie clip that contains all of the assets for this activity.
    */
	function getClip():MovieClip;
	
	
}

