class enspire.utils.BooleanUtils{
	public static function compare(b1, b2) {
		//trace("Boolean Utils String Compare "+b1+" : "+b2);
		
		//trace(BooleanUtils.getBoolean(b1));
		//trace(BooleanUtils.getBoolean(b2));
		
		if((BooleanUtils.getBoolean(b1)) == (BooleanUtils.getBoolean(b2))) {
			return true;
		}
		return false;
		
	}
	public static function getBoolean(b) {
		if(((b == "true") || (b == true)) && (b != 0)) {
			return true;
		} else{
			return false;
		}
		
	}
}