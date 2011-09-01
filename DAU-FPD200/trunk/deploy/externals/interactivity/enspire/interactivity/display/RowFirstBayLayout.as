import com.mosesSupposes.fuse.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

/*
   Class: RowFirstBayLayout
   Simple class used to automatically lay out the draggable elements in a d&d bay
*/
class enspire.interactivity.display.RowFirstBayLayout implements IBayLayout {
	
	private var PADDING = 7;
	
	public function RowFirstBayLayout() {
		
	}
	
	public function layout(bay:Bay):Void {
		var bayElements = bay.getElementsInBin();
		var dragger:Dragger;
		var bayDropZone = bay.getZone();
		var xOffset = bay._x + bayDropZone._x;
		var yOffset = bay._y + bayDropZone._y;
		for(var i = 0; i < bayElements.length; i++) {
			dragger = Dragger(bayElements[i]);
			
			ZigoEngine.doTween(dragger,"_x",[xOffset],.25);
			ZigoEngine.doTween(dragger,"_y",[yOffset],.25);
			
			xOffset += dragger._width + PADDING;
			if(xOffset + dragger._width >= bay._x + bayDropZone._x + bayDropZone._width) {
				xOffset = bay._x + bayDropZone._x;
				yOffset += dragger._height + PADDING;
			}
		}
		
		
	}
	
}

