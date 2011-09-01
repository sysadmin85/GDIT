import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;


/*
   Interface: IBayLayout
   BayLayout implementations must implement the layout() function
*/
interface enspire.interactivity.display.IBayLayout {
	
	function layout(bay:Bay):Void;
	
}