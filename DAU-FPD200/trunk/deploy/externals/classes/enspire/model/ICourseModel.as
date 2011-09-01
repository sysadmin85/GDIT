interface enspire.model.ICourseModel{
	public function createModel() : Void
	public function dump() : String
	public function getArg(sName:String) : String;
	public function getLabel(sName:String) : String;
	public function getNext() : Object;
	public function getPrev() : Object;
	public function toString() : String;
	
}