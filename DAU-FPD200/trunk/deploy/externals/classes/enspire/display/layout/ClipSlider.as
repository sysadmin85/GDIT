import flash.geom.Point;
//
import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
//
import enspire.core.Server;
import enspire.display.layout.SlidePosition;
//
class enspire.display.layout.ClipSlider{
	private var lPositions:KeyValueList;
	private var sName:String;
	private var mcClip:MovieClip;
	private var sEase:String;
	private var nDuration:Number
	private var sCurrentPostion:String
	function ClipSlider(mcClip:MovieClip, sName:String) {
		this.lPositions = new KeyValueList();
		this.mcClip = mcClip;
		this.mcClip.slider = this;
		this.nDuration = 1;
		// remove from slider
		if(sName != undefined) {
			this.sName = sName;
			Server.addController(this.sName, this);
			this.mcClip.onUnload = function() {
				Server.removeController(this.slider.getName());
				delete this.slider
			}
		}
	}
	function addPostion(sPosition:String, nX:Number, nY:Number, nPosDur:Number, sPosEase:String) : Void {
		if(isNaN(nX) && isNaN(nY)) {
			//Log.error("x, y not valid", this.toString());
		}
		//trace("Add position: "+sPosition);
		
		var pos = new SlidePosition(sPosition, nX, nY, nPosDur, sPosEase);
		this.lPositions.addValueForKey(pos, sPosition);
	}
	
	
	function getName() : String {
		return this.sName;
	}
	function getPosition() : String {
		return this.sCurrentPostion;
	}
	function set duration(n:Number) : Void {
		if(!isNaN(n)) {
			this.nDuration = n;
		}
	}
	function set ease(sEase:String) : Void{
		this.sEase = sEase;
	}
	
	function gotoPosition(sPosition:String) : Void{
		var pos = this.lPositions.getValueForKey(sPosition)
		if(pos != undefined) {
			//trace("GOTO: "+sPosition+"\n\tx: "+pos.x+"\n\ty: "+pos.y+"\n\tdurration: "+pos.durration+"\n\tease: "+pos.ease);
			
			var sUseEase = (pos.ease == undefined)      ? this.sEase     : pos.ease;
			var nUseDur  = (pos.duration  == undefined) ? this.nDuration : pos.duration; 
			
			this.mcClip.slideTo(pos.x, pos.y, nUseDur, sUseEase);
			this.sCurrentPostion = sPosition;
		}
	}
	function quickPosition(sPosition:String) {
		var pos = this.lPositions.getValueForKey(sPosition)
		if(pos != undefined) {
			this.mcClip._x = pos.x;
			this.mcClip._y = pos.y;;
			this.sCurrentPostion = sPosition;
		}
	}
	
	function toString() : String {
		var s = "enspire.display.layout.ClipSlider";
		if(this.sName != undefined) {
			s += " - "+this.sName;
		}
		return s;
	}
}