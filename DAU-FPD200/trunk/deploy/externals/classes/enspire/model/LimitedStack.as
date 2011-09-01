class enspire.model.LimitedStack{
	private var aStack:Array;
	private var nLimit:Number
	private static var DEFUALT_LIMIT:Number = 20;
	function LimitedStack(nLimit:Number) {
		this.aStack = new Array();
		this.nLimit = isNaN(nLimit) ? DEFUALT_LIMIT : nLimit;
	}
	public function pop() {
		return this.aStack.pop();
	}
	public function push(obj) {
		if(getCount() == this.nLimit) {
			discard();
		}
		this.aStack.push(obj);
	}
	private function discard() {
		return this.aStack.shift();
	}
	public function getCount() {
		return this.aStack.length;
	}
	public function toString() : String {
		var s = "START STACK:\n";
		for(var i:Number = 0; i < this.aStack.length; i++) {
			s+="\t["+i+"] "+ this.aStack[i]+"\n";
		}
		s += "END STACK";
		return s;
	}
}