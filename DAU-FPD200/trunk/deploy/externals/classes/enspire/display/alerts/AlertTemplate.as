import enspire.display.templates.BaseTemplate;
import enspire.display.alerts.IAlertTemplate;
import enspire.display.TemplateManager;
import enspire.model.State;
import mx.utils.Delegate

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;


class enspire.display.alerts.AlertTemplate extends BaseTemplate implements IAlertTemplate{
	private var mcAlert:MovieClip;
	private var mcAligner:MovieClip;
	private var mcText:MovieClip;
	private var mcContinue:MovieClip;
	private var sT:String
	private var sD:String;
	private var fCallback;
	
	private var read:ReadItem
	private var read1:ReadItem;
	
	public function AlertTemplate() {
		super();
		
	}
	function init() {
		this.gotoAndPlay("in");
	}
	public function setText(sText:String) {
		var tf = mcAlert.mcText.tf;
		this.setTextStyle(tf);
		tf.autoSize = true;
		tf.multiline = true;
		tf.html = true;
		tf.htmlText = sText;
		sD = sText;
		this.update()
	}
	public function addButton(sButtonText:String, fCallback:Function) {
		this.fCallback = fCallback;
		this.mcAlert.mcButton.mcText.tf.htmlText = sButtonText;
		this.mcAlert.mcButton.manager = this;
		this.mcAlert.mcButton.onRollOver = function() {
			this.gotoAndPlay("over");
		}
		this.mcAlert.mcButton.onRollOut = function() {
			this.gotoAndPlay("out");
		}
		this.mcAlert.mcButton.onPress = function() {
			this.gotoAndPlay("down");
		}
		this.mcAlert.mcButton.onRelease = function() {
			this.gotoAndPlay("up");
			this.manager.endAlert();
		}
		this.mcAlert.mcButton.onReleaseOutside = function() {
			this.gotoAndPlay("up");
		}
		sT = sButtonText
		this.update()
	}
	private function update() {
		
		
		this.mcAligner._width = this.nWidth;
		this.mcAligner._height = this.nHeight;
		this.mcAlert.mcButton._y = (this.mcAlert.mcText._y * 2) + this.mcAlert.mcText._height
		this.mcAlert.mcBg._height =  this.mcAlert.mcButton._y + this.mcAlert.mcButton._height + this.mcAlert.mcText._y;

		
	}
	public function allowAccess() {
		AccessManager.disableGroup("content");
		this.read = AccessManager.addItem("alert", mcAlert.mcText, sD );
		this.read1 = AccessManager.addItem("alert", this.mcAlert.mcButton, sT);
		Selection.setFocus(this.mcAlert.mcText);
	}
	function endAlert() {
		this.fCallback();
		TemplateManager.getInstance().hideBlocker();
		AccessManager.enableGroup("content");
		
		
		trace("State.sAccGroup: "+State.sAccGroup);
		
		if(State.sAccGroup != undefined) AccessManager.setGroupFocus(State.sAccGroup);
		
		this.removeMovieClip();
	}
	
}