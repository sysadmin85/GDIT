import org.asapframework.util.debug.Log;
import enspire.utils.TextFieldUtils;
import org.asapframework.util.StringUtils
//
class enspire.display.TextBox extends MovieClip{
	private var tf:TextField;
	function TextBox() {
		tf.html = true;
		tf.multiline = true;
		tf.wordWrap = true;
		TextFieldUtils.setStyleSheet(tf)
	}
	function set text(sText:String) {
		// temporary until smilley makes br like <br>
		//sText = StringUtils.replace(unescape(sText), "<br />", "<br>")
		this.tf.htmlText = sText;
		//Log.status("Setting Text: "+sText, this.toString());
	}
	function hide() {
		this._visible = false;
	}
	function show() {
		this._visible = true;
	}
	function get text() {
		return this.tf.htmlText;
	}
	function clear() {
		this.tf.htmlText = " ";
	}
	function toString() {
		return "enspire.display.TextBox";
	}
	
}