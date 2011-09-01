dynamic class enspire.model.ResourceData{
	
	
	public function toString() {
		var s = "";
		for(var elms in this) {
			if(elms != "toString") {
				s += "\t\t\t"+elms+": "+this[elms]+"\n";
			}
		}
		return s;
	}
}