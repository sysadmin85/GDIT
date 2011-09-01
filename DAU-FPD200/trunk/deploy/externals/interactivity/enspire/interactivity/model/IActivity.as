import enspire.interactivity.evaluation.*;
import enspire.interactivity.model.*;
import enspire.interactivity.events.*;


/*
   Interface: IActivity
   Base class implementing the functionality needed for a basic Bay. 
   
*/
interface enspire.interactivity.model.IActivity {
	
	function setActivityArgs(args:Object):Void;
	function setActivityProfile(profile:Object):Void;
	function setupActivityDisplay(clip:MovieClip):Void;
	function evaluateActivity():IEvaluation;
	function reportScore(e:IEvaluation):Void;
	function init():Void;
	function destroy():Void;
	function resume():Void;
	
}

