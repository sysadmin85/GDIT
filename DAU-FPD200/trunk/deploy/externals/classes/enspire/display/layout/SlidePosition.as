import flash.geom.Point
class enspire.display.layout.SlidePosition{
	private var pt:Point;
	private var sEase:String;
	private var nDuration:Number;
	private var sId:String;
	function SlidePosition(sId:String, nX:Number, nY:Number, nDuration:Number, sEase:String) {
		this.sId = sId;
		this.pt = new Point(nX, nY);
		this.nDuration = nDuration;
		this.sEase = sEase;
		//trace(sId+"\n\tx: "+pt.x+"\n\ty: "+pt.y+"\n\tdurration: "+this.nDuration+"\n\tease: "+this.sEase);
	}
	function get x() : Number {
		return this.pt.x;
	}
	function get y() : Number {
		return this.pt.y;
	}
	function get id() : String {
		return this.sId;
	}
	function get ease() : String{
		return this.sEase;
	}
	function get duration() {
		return this.nDuration;
	}
}