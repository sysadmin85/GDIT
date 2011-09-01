import org.asapframework.util.debug.Log;
//
import org.asapframework.util.StringUtilsTrim;
//
import enspire.utils.ConstructorUtil;
import enspire.core.Server;
//
import enspire.debug.ConsoleWindow
import enspire.debug.ArgsConsole
import enspire.debug.BaseConsole;
import enspire.debug.LMSConsole;
import enspire.debug.AppConsole;
import enspire.debug.SoundConsole;
//
class enspire.debug.ConsoleManager{
	private static var CONSOLE_DEPTH:Number = 80000;
	private static var aConsoles:Array;
	private static var mcConsoles:MovieClip;
	private static var PADDING:Number = 10;
	public static function init(sConsoles:String, mcClip:MovieClip, nDepth:Number) {
		aConsoles = new Array();
		var a = sConsoles.split(",");
		
		// dontdo anything if we do not have it
		if(a.length < 1) {
			return;
		}
		
		var n = isNaN(nDepth) ? CONSOLE_DEPTH : nDepth;
		var clip = (mcClip == undefined) ? _root : mcClip;
		mcConsoles = clip.createEmptyMovieClip("mcConsoles", n);
		
		var nY:Number = PADDING;
		
		for(var i:Number = 0; i < a.length; i++) {
			var console_id = StringUtilsTrim.trim(a[i]);
			var console = attachConsole(console_id, i);
			console.setId(i);
			
			aConsoles.push(console);
			
			console.setTabText(console_id);
			
			console.setTabPosition(nY);
			nY += console.getTabHeight() + PADDING;
			
			console.showWindow();
		}
	}
	public static function openConsole(nConsole:Number) {
		var console = aConsoles[nConsole];
		if(console.isOpen()) {
			console.close();
			return;
		}else{
			console.open();
			moveToTop(console);
		}
	}
	private static function moveToTop(console:BaseConsole) {
		var topDog;
		var topDepth:Number =  -1;
		for(var i = 0; i < aConsoles.length; i++) {
			if(aConsoles[i].getDepth() > topDepth) {
				topDepth = aConsoles[i].getDepth();
				topDog = aConsoles[i];
			}
		}
		if(console.getDepth() < topDepth) {
			console.swapDepths(topDog);
		}
	}
	private static function attachConsole(sName:String, nId:Number) {
		var console;
		var sLinkage = sName+"_console";
		var mc = mcConsoles.attachMovie(sLinkage, "mcConsole"+nId, nId);
		
		switch(sName) {
			case "log":
				console = ConstructorUtil.createVisualInstance(ConsoleWindow, mc);
				break;
			case "args":
				console = ConstructorUtil.createVisualInstance(ArgsConsole, mc);
				break;
			case "lms": 
				console =  ConstructorUtil.createVisualInstance(LMSConsole, mc);
				break;
			case "app":
				console =  ConstructorUtil.createVisualInstance(AppConsole, mc);
				break;
			case "snd": 
				console = ConstructorUtil.createVisualInstance(SoundConsole, mc);
				break;
		}
		////Log.debug("CONSOLE ATTACHED "+sName, toString());
		return console;
	}
	public static function toString() {
		return "enspire.debug.ConsoleManager";
	}
}