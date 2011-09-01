import enspire.display.layout.ILayout
import enspire.display.layout.Frame;
//
class enspire.display.layout.BaseLayout implements ILayout{
	// call back hooks to be defined by user
	public var onUpdate:Function;
	public var onUnload:Function;
	// array to hold all layout elements
	private var aElements:Array;
	// a frame to provide boundries and a place to sink to
	private var fFrame:Frame;
	public var mcTimeline:MovieClip
	
	function BaseLayout(mc:MovieClip) {
		super();
		this.mcTimeline = mc;
		this.aElements = new Array();
	}
	public function update() : Void {
		this.onUpdate();
	}
	function setFrame( f:Frame ) {
		this.fFrame = f;
	}
	function addElement(e) : Void {
		this.aElements.push(e);
		//trace("Add element "+this.aElements.length+" - "+e._name);
	}
	function getElementCount() : Number{
		return this.aElements.length;
	}
	function getElement(n:Number) {
		return this.aElements[n];
	}
	function getElements() {
		return this.aElements;
	}
	function removeElements() {
		for(var i:Number = 0; i < this.aElements.length; i++) {
			this.aElements[i].removeMovieClip();
		}
		this.aElements = new Array();
	}
	 
}