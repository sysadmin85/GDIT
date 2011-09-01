import org.asapframework.util.debug.Log;
//
import enspire.core.Server;
import enspire.model.Labels;
import enspire.model.State;
import enspire.ile.AppEvents;
import enspire.utils.TextFieldUtils;

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;
//
class enspire.display.panels.TitleBar extends MovieClip {
	var tfTitle:TextField;
	var tfSectionTitle:TextField;
	var tfClipTitle:TextField;
	private var read:ReadItem
	function TitleBar() {
		this.initTextField(tfTitle);
		this.initTextField(tfClipTitle);
		this.initTextField(tfTitle);
		// conect to the Server and add this as a controller
		Server.connect(this, "update", AppEvents.START_SEG);
		
		this.setText(tfTitle, Server.model.getCourseTitle());
		
		//this.read = AccessManager.addItem("gui1", this, "Title", "");
		
		//Log.status("init - course title: "+Server.model.getCourseTitle(), this.toString());
	}
	function update() : Void{    
    	//trace("Update Title Bar:" + this + " | " + Server.model.getCourseTitle());
		var sSectTitle:String = Server.model.section.title;
		var sClipTitle:String = Server.model.clip.title;
		this.setText(tfSectionTitle, sSectTitle);
		this.setText(tfClipTitle, sClipTitle);
		
		// added for 508
		this.read.setDescription( sClipTitle);
		
		//Log.status("Setting Title - Section: "+sSectTitle+", Clip: "+sClipTitle, this.toString());
	}
	private function setText(tf:TextField, sText:String) : Void {
		if(sText == undefined) {
			return;
		}
		tf.htmlText  =  sText
	}
	private function initTextField(tf:TextField) : Void {
		tf.multiline = false;
		tf.autoSize = true;
		tf.html = true;
		tf.text = "";
		TextFieldUtils.setStyleSheet(tf);
	}
	function toString() : String {
		return "enspire.display.TitleBar";
	}
	
}