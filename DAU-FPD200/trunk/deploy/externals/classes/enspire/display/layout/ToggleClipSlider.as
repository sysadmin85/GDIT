import flash.geom.Point;
//
import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
//
import enspire.core.Server;
import enspire.display.layout.ClipSlider;
//
class enspire.display.layout.ToggleClipSlider extends ClipSlider{
	function ToggleClipSlider(mcClip:MovieClip, sName:String) {
		super(mcClip, sName);
	}
	function setOpen(nX:Number, nY:Number, nPosDur:Number, sPosEase:String) {
		this.addPostion("open", nX, nY, nPosDur, sPosEase);
	}
	function setClose(nX:Number, nY:Number, nPosDur:Number, sPosEase:String) {
		this.addPostion("close", nX, nY, nPosDur, sPosEase);
	}
	function open() : Void {
		this.gotoPosition("open");
	}
	function close() : Void{
		this.gotoPosition("close");
	}
	function quickOpen() : Void {
		this.quickPosition("open");
	}
	function quickClose() : Void{
		this.quickPosition("close");
	}
	function isOpen() : Boolean{
		return (this.getPosition() == "open");
	}
	function toString() : String {
		var s = "enspire.display.layout.ClipSlider";
		if(this.sName != undefined) {
			s += " - "+this.sName;
		}
		return s;
	}
}