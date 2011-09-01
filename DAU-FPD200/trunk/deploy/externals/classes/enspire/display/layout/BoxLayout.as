import enspire.display.layout.BaseLayout;
import org.asapframework.util.debug.Log;
class enspire.display.layout.BoxLayout extends BaseLayout {
	public static var AXIS_X:String = "x";
	public static var AXIS_Y:String = "y";
	private var sAxis:String;
	private var nOffset:Number
	private var nStart:Number
	private var aOffsets:Array;
	private var bAlign:Boolean;
	function BoxLayout(mc:MovieClip) {
		super(mc);
		this.setAxis(AXIS_Y);
		this.nOffset = 0;
		this.nStart = 0;
		this.setAlign(false);
		////trace("New box layout");
	}
	public function setAxis(s:String) {
		if(s == AXIS_X) {
			this.sAxis = AXIS_X;
		}else{
			this.sAxis = AXIS_Y;
		}
	}
	public function getAxis() {
		return this.sAxis;
	}
	// purpously untyped so it can be a number or an array
	public function setOffset( off ) {
		if(off instanceof Array) {
			this.aOffsets = off;
		}else if(!isNaN(parseInt(off))) {
			this.nOffset = off;
		}else{
			//Log.error("invalid offset", this.toString());
		}
	}
	public function setStartPos(n:Number) {
		this.nStart = n;
	}
	public function setAlign(b:Boolean) {
		////trace("Set Align "+b);
		this.bAlign = b;
	}
	public function update() : Void {
		// loop through and make list
		var nPos:Number = nStart;
		////trace("Start update on " + this.aElements.length+" clips -  force align: "+this.bAlign);
		for(var i:Number = 0; i < this.aElements.length; i++) {
			var nSpace = (this.aOffsets[i] == undefined) ? this.nOffset : this.aOffsets[i];
			////trace("Pos "+this.aElements[i]._name+ " spacing: "+nSpace);
			if(this.sAxis == AXIS_Y) {
				this.aElements[i]._y = nPos;
				nPos += (this.aElements[i]._height + nSpace);
				if(this.bAlign) {
					this.aElements[i]._x = this.aElements[0]._x;
					////trace("Align to "+this.aElements[0]._x);
				}
			}else{
				this.aElements[i]._x = nPos;
				nPos += (this.aElements[i]._width + nSpace);
				if(this.bAlign) {
					this.aElements[i]._y = this.aElements[0]._y;
				}
			}
		}
		super.update();
	}
	public function toString() {
		return "enspire.display.layout.BoxLayout";
	}
}