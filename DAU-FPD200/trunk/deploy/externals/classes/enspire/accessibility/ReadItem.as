import enspire.accessibility.ReadGroup
class enspire.accessibility.ReadItem{
	private var sName:String;
	private var oItem:Object;
	private var rgGroup:ReadGroup;
	function ReadItem(oItem, sName:String, sDescription:String, sShortcut:String) {
		this.oItem = oItem;
		
		this.oItem._focusrect = true;
		this.oItem.focusEnabled = true;
		
		this.setName(sName);
		this.setDescription(sDescription);
		//this.setShortcut(sShortcut);
		this.enable();
		
	}
	public function getAccProps() {	
		if((this.oItem._accProps.bDefault) || (!this.oItem._accProps)) {
			this.oItem._accProps = {};
		}
		return this.oItem._accProps;
	}

	public function getItem(){
		return this.oItem;
	}

	public function setName(sName:String) {
		//trace("ReadItem --> setName(" + sName + ")");
		this.sName = sName;
		this.getAccProps().name = sName;
		Accessibility.updateProperties()
	}

	public function getName() {
		return this.getAccProps().name;
	}
	public function set group(rgGroup:ReadGroup) {
		this.rgGroup = rgGroup;
	}
	public function get group() {
		return this.rgGroup;
	}

	public function setDescription(sDesc:String) {
		this.getAccProps().description = sDesc || "";
		Accessibility.updateProperties()
	}

	public function getDescription() :String{
		return this.getAccProps().description 
	}

	public function setShortcut(sShortcut:String) {
		this.getAccProps().shortcut = sShortcut || "";
		Accessibility.updateProperties()
	}

	public function setTabIndex(nIndex:Number) {
		//trace("ReadItem "+this.getAccProps().name + " --> setTabIndex(" + nIndex + ")");
		this.oItem.tabEnabled = true;
		this.oItem.tabIndex = nIndex;
		
		Accessibility.updateProperties();
	}

	public function enable(){
		this.oItem.tabEnabled = true;
		this.getAccProps().silent = false;
		
		Accessibility.updateProperties()
	}
	public function getEnabled() {
		if(this.oItem.enabled == false) return false
		return true;
	}

	public function disable() {
		//trace("ReadItem "+this.getAccProps().name + "disabled");
		this.oItem.tabEnabled = false;
		this.getAccProps().silent = true;
		
		Accessibility.updateProperties()
	}

	public function select() {
		this.getAccProps().name = "Selected: " + this.sName;
	}

	public function deselect() {
		this.getAccProps().name = this.sName;
	}

	private function unsilentParents() {
		if(this.oItem._parent != undefined && this.oItem._parent != _root)
		{
			this.oItem._parent._accProps.silent = false;
			this.unsilentParents(this.oItem._parent);
		}
	}

	private function silentParents() {
		if(this.oItem._parent != undefined && this.oItem._parent != _root){
			this.oItem._parent._accProps.silent = true;
			this.silentParents(this.oItem._parent);
		}
	}
	
}