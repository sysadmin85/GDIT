class enspire.utils.TimeUtils{
	public static function millisToString(time:Date) {
		var seconds:Number = Math.floor((time/1000) % 60);
		var minutes:Number = Math.floor((time/60000) % 60);
		var hours:Number = Math.floor((time/3600000) % 24);
		
		var secondsStr = (seconds<10 ? "0" : "")+seconds;
		var minutesStr = (minutes<10 ? "0" : "")+minutes;
		var hoursStr = (hours<10 ? "0" : "")+hours;
		
		return hoursStr+":"+minutesStr+":"+secondsStr;
	}
	
	public static function millisToStringNoHours(time:Date){
		var seconds:Number = Math.floor((time/1000) % 60);
		var minutes:Number = Math.floor((time/60000) % 60);
		
		var secondsStr:String = (seconds<10 ? "0" : "")+seconds;
		var minutesStr:String = (minutes<10 ? "0" : "")+minutes;
		
		return minutesStr+":"+secondsStr;
	}
	
	
}