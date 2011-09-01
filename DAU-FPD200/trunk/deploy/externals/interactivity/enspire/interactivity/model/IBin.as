import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

/*
   Interface: IBin
   Base class implementing the functionality needed for a basic Bay. 
   
*/
interface enspire.interactivity.model.IBin {
	
	function getID():String;
	function getElementsInBin():Array;
	function getCapacity():Number;
	function setCapacity(c:Number):Void;
	function addElementToBin(e:ISortingElement):Void;
	function removeElementFromBin(e:ISortingElement):Void;
}

