
/*
   Interface: IChoice
   Base class implementing the functionality needed for a basic Bay. 
   
*/
interface enspire.interactivity.model.IChoice {
	
	function getID():String;
	function isSelected():Boolean;
	
	function select():Void;
	function deselect():Void;
}

