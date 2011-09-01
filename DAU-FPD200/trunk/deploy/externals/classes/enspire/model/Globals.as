class enspire.model.Globals{
	// app and gui left untyped intentionaly
	public static var APP;
	public static var GUI;

	public static function dump() : String {
		var s:String = "\n-------------------------- Start Globals Dump -------------------------------\n";
		for(var elm:String in Globals) {
			if(typeof Globals[elm] != "function") {
				s += "\n" + elm + ": " + Globals[elm];
			}
		}
		s += "\n--------------------------  End Globals Dump  -------------------------------\n";
		return s;
	}
}