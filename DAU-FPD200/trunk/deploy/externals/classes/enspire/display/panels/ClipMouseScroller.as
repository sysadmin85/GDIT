import mx.utils.Delegate;
class enspire.display.panels.ClipMouseScroller{
	public static var AXIS_X:String = "x";
	public static var AXIS_Y:String = "y";
	private var mcClip:MovieClip;
	private var mcMask;
	private var sAxis:String;
	private var nSpeed:Number;
	function ClipMouseScroller(mcClip, mcMask) {
		this.mcClip = mcClip;
		this.mcMask = mcMask;
		this.sAxis = AXIS_Y;
		this.nSpeed = 10;
	}
	function set speed(n:Number) {
		if(!isNaN(n)) {
			this.nSpeed = n;
		}
	}
	function get speed() {
		return this.nSpeed;
	}
	function init() {
		delete this.mcMask.onEnterFrame;
		if(this.sAxis == AXIS_X) {
			this.mcClip._x = this.mcMask._x;
			if(this.mcClip._width > this.mcMask._width) {
				this.mcMask.onEnterFrame = Delegate.create(this, moveX);
			}
		}else{
			this.mcClip._y = this.mcMask._y;
			if(this.mcClip._height > this.mcMask._height) {
				this.mcMask.onEnterFrame = Delegate.create(this, moveY);
			}
		}
	}
	function reset() {
		if(this.sAxis == AXIS_X) {
			this.mcClip._x = this.mcMask._x;
		}else{
			this.mcClip._y = this.mcMask._y;
		}
	}
	function moveX() {
		if(this.mcMask.hitTest(this.mcClip._xmouse , this.mcClip._ymouse)) {
			var topX = this.mcMask._x;
			
			var bottomX = this.mcMask._x + (this.mcMask._width - this.mcClip._width);
			var xpos = - ((this.mcMask._xmouse) - (this.mcMask._width / 2)) / speed;
			var nextX = this.mcClip._x + xpos;

			if (nextX < bottomX) {
				nextX = bottomX;
			} else if (nextX > topX) {
				nextX = topX;
			}
			this.mcClip._x = nextX

		}
		
	}
	function moveY() {
		if(this.mcMask.hitTest(this.mcClip._xmouse, this.mcClip._ymouse)) {
			var topY = this.mcMask._y;
			var speed = 10;
			var bottomY = this.mcMask._y + (this.mcMask._height - this.mcClip._height);
			var ypos = - ((this.mcMask._ymouse) - (this.mcMask._height / 2)) / speed;
			var nextY = this.mcClip._y + ypos;
	
			if (nextY < bottomY) {
				nextY = bottomY;
			} else if (nextY > topY) {
				nextY = topY;
			}
			this.mcClip._y = nextY

		}
		
	}
}