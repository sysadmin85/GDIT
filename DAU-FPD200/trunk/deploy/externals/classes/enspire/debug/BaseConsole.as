import org.asapframework.util.debug.Log;
//
import mx.utils.Delegate;
//
import com.mosesSupposes.fuse.ZigoEngine;
//
import enspire.debug.ConsoleManager;

class enspire.debug.BaseConsole extends MovieClip {
	private var nId:Number
	private var mcOpen:MovieClip;
	private var mcBg:MovieClip;
	private var bOpen:Boolean;
	private var bVisible:Boolean;
	private var mcTab:MovieClip;
	function BaseConsole() {
		this.mcTab.onPress = Delegate.create(this, toggleWindow);
		this.close(false);
		this.hideWindow();
		this.mcBg.onRollOver = function() {
			this.useHandCursor = false;
		}
		//Log.status("Created", this.toString());
	}
	public function setTabText(sText:String) {
		this.mcTab.mcText.tf.text = sText.toUpperCase();
	}
	public function setTabPosition(n:Number) {
		this.mcTab._y = n;
	}
	public function getTabHeight() {
		return this.mcTab._height;
	}
	private function toggleWindow() {
		ConsoleManager.openConsole(this.nId);
	}
	public function setId(n:Number) {
		this.nId = n;
	}
	public function close(bTween:Boolean) {
		this.bOpen = false;
		var xPos:Number = this.mcBg._width*-1;
		if(bTween == false) {
			this._x = xPos;
		} else {
			ZigoEngine.doTween(this, "_x", xPos);
		}
		this.mcTab.mcOpen._xscale = 100;
	}
	public function open(bTween:Boolean) {
		this.bOpen = true;
		if(bTween == false) {
			this._x = 0;
		}else{
			ZigoEngine.doTween(this, "_x", 0);
		}
		this.mcTab.mcOpen._xscale = -100;
	}
	public function hideWindow() {
		this.bVisible = false;
		this._visible = false;
		if(this.bOpen) {
			this.close(false);
		}
	}
	public function showWindow() {
		this.bVisible = true;
		this._visible = true;
	}
	public function isShowing() {
		return this.bVisible;
	}
	public function isOpen() {
		return this.bOpen;
	}
	public function toString() {
		return "enspire.debug.BaseConsole";
	}
}