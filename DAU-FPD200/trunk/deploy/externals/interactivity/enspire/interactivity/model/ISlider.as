
/*
   Interface: ISlider
   Base class implementing the functionality needed for a basic Bay. 
   
*/
interface enspire.interactivity.model.ISlider {
	
	function getID():String;
	function getPercentage():Number;
	function getValue():Number;
	
	function setMaxValue(max:Number):Void;
	
}

