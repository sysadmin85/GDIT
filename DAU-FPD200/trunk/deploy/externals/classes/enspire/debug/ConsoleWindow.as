import org.asapframework.util.debug.Log;
import org.asapframework.util.debug.LogEvent;
import org.asapframework.util.FrameDelay;
//
import mx.utils.Delegate;
//
import enspire.debug.ConsoleCheckBox;
import enspire.debug.ConsoleManager;
import enspire.debug.BaseConsole;
//
class enspire.debug.ConsoleWindow extends BaseConsole {
	
	private var tf:TextField;
	private var mcClear:MovieClip;
	private var mcUp:MovieClip;
	private var mcDown:MovieClip;
	private var mcBg:MovieClip;
	private var mcShowAll:MovieClip;
	private var cb1:ConsoleCheckBox;
	private var cb2:ConsoleCheckBox;
	private var cb3:ConsoleCheckBox;
	private var cb4:ConsoleCheckBox;
	private var cb5:ConsoleCheckBox;
	private var cb6:ConsoleCheckBox;
	//
	//
	function ConsoleWindow() {
		super();
		this.mcDown.onPress = Delegate.create(this, pageUp);
		this.mcUp.onPress = Delegate.create(this, pageDown);
		this.mcClear.onPress = Delegate.create(this, clearText);
		this.mcShowAll.onPress = Delegate.create(this, showAll);
		
		this.tf.mouseWheelEnabled = true;
		
		//Log.addLogListener(Delegate.create(this, onLogEvent));
		//Log.debug("INIT HERE", this.toString());
		this.checkForTextLen();
		var fd = new FrameDelay(this, initCheckBoxes);
	}
	public function isOpen() {
		return this.bOpen;
	}
	private function addToText(s:String) {
		this.tf.text += s;
		this.checkForTextLen();
	}
	private function clearText() {

		this.tf.text = "";
		this.checkForTextLen();
	}
	private function checkForTextLen() {
		if (tf.maxscroll<2) {
			this.disableScroll();
		} else {
			this.enableScroll();
		}
	}
	private function pageUp() {
		var nScroll = this.tf.scroll + 5;
		if(nScroll > this.tf.maxscroll) {
			nScroll = this.tf.maxscroll;
		}
		this.tf.scroll = nScroll;
		
	}
	private function pageDown() {
		var nScroll = this.tf.scroll - 5;
		if(nScroll < 0) {
			nScroll = 0;
		}
		this.tf.scroll = nScroll;
	}
	private function enableScroll() {
		this.mcDown.enabled = true;
		this.mcUp.enabled = true;
		this.mcDown._alpha = 100;
		this.mcUp._alpha = 100;
	}
	private function disableScroll() {
		this.mcDown.enabled = false;
		this.mcUp.enabled = false;
		this.mcDown._alpha = 50;
		this.mcUp._alpha = 50;
	}
	private function onLogEvent(e:LogEvent) {
		var bAdd:Boolean = false;
		switch (e.level) {
			case Log.LEVEL_DEBUG :
				if (this.cb1.isSelected()) {
					bAdd = true;
				}
				break;
			case Log.LEVEL_ERROR :
				if (this.cb2.isSelected()) {
					bAdd = true;
				}
				break;
			case Log.LEVEL_FATAL :
				if (this.cb3.isSelected()) {
					bAdd = true;
				}
				break;
			case Log.LEVEL_INFO :
				if (this.cb4.isSelected()) {
					bAdd = true;
				}
				break;
			case Log.LEVEL_STATUS :
				if (this.cb5.isSelected()) {
					bAdd = true;
				}
				break;
			case Log.LEVEL_WARN :
				if (this.cb6.isSelected()) {
					bAdd = true;
				}
				break;
		}
		if (bAdd) {
			var msg = newline+getTimer()+" "+e.level+": "+e.text+" - "+e.sender;
			this.addToText(msg);
		}
	}
	private function showAll() {
		this.cb1.select();
		this.cb2.select();
		this.cb3.select();
		this.cb4.select();
		this.cb5.select();
		this.cb6.select();
	}
	private function initCheckBoxes() {
		this.cb1.init("DEBUG",true);
		this.cb2.init("ERROR",true);
		this.cb3.init("FATAL",true);
		this.cb4.init("INFO",true);
		this.cb5.init("STATUS",true);
		this.cb6.init("WARN",true);
	}
	public function toString() {
		return "enspire.debug.ConsoleWindow";
	}
}