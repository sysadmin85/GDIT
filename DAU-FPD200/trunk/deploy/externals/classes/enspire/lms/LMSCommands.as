import enspire.utils.TimeUtils;
import enspire.model.State;
import flash.external.ExternalInterface
class enspire.lms.LMSCommands{
	public static function setStarted() {
		//fscommand("CMISetStarted");
		
		return ExternalInterface.call("SCOSetValue", "cmi.core.lesson_status", "incomplete");
	}
	public static function setElapsedTime() {
		// send an elapsed time session value to the LMS with the format "PT[n]S" (elapsed time in seconds)
		var rightNow = new Date();
		var elapsedRaw = rightNow.getTime() - State.startTime.getTime();
		
		return ExternalInterface.call("SCOSetValue", "cmi.core.session_time", TimeUtils.millisToString(elapsedRaw));
		
		//fscommand("CMISetTime", TimeUtils.millisToString(elapsedRaw));
	}
	public static function setBookmark(sBookmark:String) {
		return ExternalInterface.call("SCOSetValue", "cmi.suspend_data", escape(sBookmark));
		//fscommand("CMISetData", escape(sBookmark));
	}
	public static function getBookmark() {
		return ExternalInterface.call("SCOGetValue", "cmi.suspend_data");
	}
	public static function setScore(n:Number) {
		if(isNaN(n)) {
			//trace("ERROR: LMSCommands setScore "+n+" isNaN");
			return;
		}
		return ExternalInterface.call("SCOSetValue", "cmi.core.score.raw", n);
	}
	public static function setComplete() {
		return ExternalInterface.call("SCOSetStatusCompleted");
	}
	public static function commit() {
		return ExternalInterface.call("SCOCommit");
	}
	public static function setFailed() {
		return ExternalInterface.call("SCOSetValue", "cmi.core.lesson_status", "failed");
	}
	public static function setPassed() {
		return ExternalInterface.call("SCOSetValue", "cmi.core.lesson_status", "passed");
		
	}
	public static function getValue(sValue:String) {
		return ExternalInterface.call("SCOGetValue", sValue);
	}
	public static function apiOK() {
		return ExternalInterface.call("APIOK")
	}
}