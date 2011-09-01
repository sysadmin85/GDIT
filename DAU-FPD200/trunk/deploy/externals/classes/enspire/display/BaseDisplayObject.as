import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;
import enspire.display.LayoutUtils;
import enspire.utils.TextFieldUtils;
dynamic class enspire.display.BaseDisplayObject extends MovieClip {
	/*	Group: Private vars
		
		Var: nW
		number max width of template display area
	*/
	private var nW:Number;
	/*	Var: nH
		number max height of template display area
	*/
	private var nH:Number;
	/*	Var sounds
		a reference to the SoundManager
	*/
	private var sounds;
	/*	Group: Public Vars
	
		Var: args
		reference to current segments args
	*/
	private var read:ReadItem
	public var mcBounds:MovieClip;
	function BaseDisplayObject() {
		super();
		LayoutUtils.addDynamicRegistration(this);
		this.sounds = Server.sounds;
		
		var xReg = 0
		var yReg = 0;
		if(this.mcBounds != undefined) {
			xReg = this.mcBounds._x;
		    yReg = this.mcBounds._y;
		}
		this.setRegistration(xReg, yReg);
	}
	/*	Function: sizeTextField
		set a text fields width
		
		Parrameters:
		tf - (required) textfield to size
		nW - (required) number width
	*/
	public function sizeTextField(tf:TextField, nW:Number) {
		LayoutUtils.applyWidthToTextField(tf, nW);
	}
	public function getBoundRect() {
		return LayoutUtils.getClipBounds(this)
	}
	public function setPosition(x:Number, y:Number) {
		this._x2 = x;
		this._y2 = x;
	}
	public function show() {
		this._visible = true;
	}
	/*	Function: hide
		sets template visibilty to false;
	*/
	public function hide() {
		this._visible = false;
	}
	// to set accesibilty on object
	public function makeReadable(sGroup:String, sName:String, sDescription:String, sShortcut:String) {
		this.read = AccessManager.addItem(sGroup, this, sName, sDescription, sShortcut);
	}
	public function getRead() {
		return this.read;
	}
}