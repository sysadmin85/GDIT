import enspire.utils.ClipUtils
import org.asapframework.util.debug.Log;
import enspire.display.LayoutUtils;
class enspire.display.ContentContainer{
	private var sName:String;
	private var mcContainer:MovieClip;
	private var mcMask:MovieClip;
	
	private var nW:Number;
	private var nH:Number;
	private var bActive:Boolean;
	private var bPauseable:Boolean
	
	function ContentContainer(sName:String, mcContainer:MovieClip, nW:Number, nH:Number, mcMask:MovieClip, bPausable:Boolean) {
		this.sName       = sName;
		this.mcContainer = mcContainer;
		this.mcContainer.container = this;
		this.mcMask   = mcMask;
		this.nW = nW;
		this.nH = nH;
		this.bPauseable = (bPauseable == undefined) ? true : false;
		if(this.bPauseable) {
			this.mcContainer.isPausable = "pass"
		}else{
			this.mcContainer.isPausable = false;
		}
		this.setActive(true);
	}
	function setClipPosition(x:Number, y:Number) {
		this.mcContainer._x = x;
		this.mcContainer._y = y;
	}
	function setWidth(n:Number) {
		if(isNaN(n)) return;
		this.nW = n;
	}
	function setHeight(n:Number) {
		if(isNaN(n)) return;
		this.nH = n;
	}
	function getHeight() {
		return this.nH;
	}
	function getWidth() {
		return this.nW;
	}
	function getClip() {
		return mcContainer;
	}
	function getMask() {
		return mcMask;
	}
	function get name() {
		return this.sName;
	}
	function setActive(b:Boolean) {
		if(b == bActive) {
			return;
		}
		if(b) {
			this.show();
			this.resume();
		}else{
			this.hide();
			this.pause();
		}
		this.bActive = b;
		////Log.debug("Setting Container Active: "+this.bActive, toString());
	}
	function getBounds() {
		return LayoutUtils.makeBounds(this.mcContainer._x, this.nW, this.mcContainer._y, this.nH);
	}
	function isActive() {
		return this.bActive;
	}
	function hide() {
		this.mcContainer._visible = false;
	}
	function show() {
		this.mcContainer._visible = true;
	}
	function pause() {
		if(this.bPauseable) {
			ClipUtils.pause(this.mcContainer);
		}
	}
	function resume() {
		if(this.bPauseable) {
			ClipUtils.resume(this.mcContainer);
		}
	}
	function toString() {
		return "ContentContainer: "+this.name;
	}
	
}