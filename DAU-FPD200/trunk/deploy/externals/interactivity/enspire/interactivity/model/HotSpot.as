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
   Class: HotSpot
   Base class implementing the functionality needed for a basic HotSpot 
   
*/
class enspire.interactivity.model.HotSpot 
	extends InteractivityClip {
	
	private var myText:String;
	private var myLabel:String;
	private var visited:Boolean;
	private var bSelected:Boolean;	
	private var popupHolder:MovieClip;
	
	public function HotSpot() {
		super();
		initHandlers();
		visited = false;
		this["mcVisited"]._visible = false;
		this["mcSelected"]._visible = false;
		bSelected = false;
	}
	
	public function setText(t:String) {
		this.myText = t;
	}
	
	public function setPopupHolder(ph:MovieClip) {
		popupHolder = ph;
	}
	
	public function getPopupHolder():MovieClip {
		return popupHolder;
	}
	
	public function setLabel(l:String) {
		this.myLabel = l;
		this["mcText"].tf.htmlText = l;
	}
	
	public function getVisited():Boolean {
		return visited;
	}
	
	public function setVisited(b:Boolean) {
		visited = b;
		if(visited) {
			this["mcVisited"]._visible = true;
			this["mcPulse"]._visible = false;
		} else {
			this["mcVisited"]._visible = false;
		}
	}
	
	public function getText() {
		return this.myText;
	}
	
	public function getLabel() {
		return this.myLabel;
	}
	
	private function initHandlers() {
		this.onPress = function() {
			hotspotPress();
			var de = new HotspotEvent(HotspotEvent.HOTSPOT_PRESS,this);
			notifyListeners(de);
		}
		this.onRelease = this.onReleaseOutside = function() {
			hotspotRelease();
			var de = new HotspotEvent(HotspotEvent.HOTSPOT_RELEASE,this);
			notifyListeners(de);
		}
		this.onRollOver = function() {
			hotspotOver();
			var de = new HotspotEvent(HotspotEvent.HOTSPOT_OVER,this);
			notifyListeners(de);
		}
		this.onRollOut = function() {
			hotspotOut();
			var de = new HotspotEvent(HotspotEvent.HOTSPOT_OUT,this);
			notifyListeners(de);
		}
		this.onMouseMove = function() {
			var de = new HotspotEvent(HotspotEvent.HOTSPOT_MOVE,this);
			notifyListeners(de);
		}
	}
	
	
	private function hotspotPress() {

	}
	
	private function hotspotRelease() {

	}
	
	private function hotspotOver() {
		
	}
	
	private function hotspotOut() {

	}
	
	public function setSelected(bSel)  {
		this.bSelected = bSel;
	}
	
	public function isSelected():Boolean {
		return bSelected;
	}
	
	public function select():Void {
		bSelected = true;
		this["mcSelected"]._visible = true;
		this["mcBg"].mcSelected._visible = true;
	}
	
	public function deselect():Void {
		bSelected = false;
		this["mcSelected"]._visible = false;
		this["mcBg"].mcSelected._visible = false;
	}
	
}

