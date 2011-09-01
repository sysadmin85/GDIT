// these functions were taken from prototype modifacations done in ILE 1 and refactored into static functions I do not know if these are usefull
import enspire.core.Server;
class enspire.utils.TextFieldUtils{
	public static function setStyleSheet(tf:TextField) {
		tf.styleSheet =  Server.textStyle;
	}
	public static function  getHtmlText(sText:String , sArgs:String) {
		var sOpen:String;
		var sClose:String;
		var aTags:Array = sArgs.split(",");
		for(var i=0; i<aTags.length; i++) {
			sOpen += "<" + aTags[i] + ">";
			sClose += "</" + aTags[aTags.length - (i + 1)] + ">";
		}
		return sOpen + sText + sClose;
	}
	public static function setCenteredText(tf:TextField , sText:String, sArgs:String) { 
		tf.html = true;
		tf.htmlText = "<p align='center'>" + TextFieldUtils.getHtmlText(sText, sArgs) + "</p>";
	}
	public static function setText(tf:TextField, sText:String, sArgs:String) {
		tf.html = true;
		tf.htmlText = "<p align='left'>" + TextFieldUtils.getHtmlText(sText, sArgs) + "</p>";
	}
	public static function setRightAlignedText(tf:TextField , sText:String, sArgs:String) { 
		tf.html = true;
		tf.htmlText = "<p align='right'>" + TextFieldUtils.getHtmlText(sText, sArgs) + "</p>";
	}
	public static function setupTextArea(tf:TextField , sText:String) { 
		TextFieldUtils.setStyleSheet( tf );
		tf.autoSize = true;
		tf.multiline = true;
		tf.html = true;
		tf.htmlText = sText;
	}
}