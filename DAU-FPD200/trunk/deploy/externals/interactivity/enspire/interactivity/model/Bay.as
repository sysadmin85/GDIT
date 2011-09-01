import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.*;

/*
   Class: Bay
   Base class implementing the functionality needed for a basic Bay. 
   
*/
class enspire.interactivity.model.Bay 
	extends InteractivityClip 
		implements IBin {
	
	private var draggers:Array;
	private var capacity:Number;
	
	private var text:String;
	
	private var layout:RowFirstBayLayout;
	
	private var id:String;
	
	public function Bay() {
		super();
		draggers = new Array();
		layout = new RowFirstBayLayout();
	}
	
	public function setText(t:String) {
		this["mcText"].tf.htmlText = t;
	}
	
	public function setCapacity(c:Number):Void {
		this.capacity = c;
	}
	
	public function getZone() {
		return this["mcZone"];
	}
	
	public function applyLayout():Void {
		layout.layout(this);
	}
	
	public function getCapacity():Number {
		return this.capacity;
	}
	
	public function addElementToBin(d:ISortingElement):Void {
		if(ArrayUtils.findElement(draggers,d) == -1) {
			draggers.push(d);
			d.setBin(this);
		}
		if(draggers.length >= capacity) {
			this.gotoAndStop("disabled");
		}
	}
	
	public function removeElementFromBin(d:ISortingElement):Void {
		ArrayUtils.removeElement(draggers,d);
		d.setBin(undefined);
		if(draggers.length < capacity) {
			this.gotoAndStop("up");
		}
	}
	
	public function getDraggers() {
		return draggers;
	}
	
	public function getElementsInBin():Array {
		return draggers;
	}
	
}

