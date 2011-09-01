import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Interface: ISortingElement
   Base class implementing the functionality needed for a basic Bay. 
   
*/
interface enspire.interactivity.model.ISortingElement {
	
	function getID():String;
	function setBin(b:IBin):Void;
	function getBin():IBin;
	
}

