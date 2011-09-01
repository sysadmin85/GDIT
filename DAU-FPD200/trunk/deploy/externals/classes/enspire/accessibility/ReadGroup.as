import enspire.accessibility.AccessManager;
import enspire.accessibility.ReadItem;
class enspire.accessibility.ReadGroup{
	private var sId:String;
	private var bSticky:Boolean;
	private var aItems:Array;
	private var bEnabled:Boolean;
	
	public function ReadGroup(sId:String, bSticky:Boolean) {
		this.sId = sId;
		this.bSticky = bSticky || false;
		this.aItems = new Array();
		this.bEnabled = true;
	}
	public function setFocus(n:Number) {
		if(isNaN(n)) n = 0;
		var item = this.aItems[n].getItem();
		//trace("**************   SETING FOCUS ************* "+item);
		if(item) Selection.setFocus(item);
	}
	public function getItems(){
		return this.aItems;
	}
	public function length() {
		return this.aItems.length;
	}

	public function getId() {
		return this.sId;
	}

	public function isSticky(){
		//trace("ReadGroup "+this.sId+" isSticky() returning " + this.bSticky);
		return this.bSticky;
	}

	public function addItem(mItem, sName:String, sDescription:String, sShortcut:String, nPosition:Number) {	
		//trace("ReadGroup --> addItem(" + sName + ")");
		
		var oItem = new ReadItem(mItem, sName, sDescription, sShortcut);
		oItem.group = this;
		// add to bottom of stack or insert to the middle
		if(nPosition == undefined)
		{
			this.aItems.push(oItem);
		}
		else
		{
			this.aItems.splice(nPosition, 0, oItem);
		}
		
		AccessManager.update();
		return oItem;
	}

	public function addItemAfter(mExistingItem, mItem, sName:String, sDescription:String, sShortcut:String){
		for(var i=0; i<this.aItems.length; i++) {
			if(this.aItems[i] == mExistingItem) {
				return this.addItem(mItem, sName, sDescription, sShortcut, (i + 1));
			}
		}
	}

	public function addItemToTop(mItem, sName:String, sDescription:String, sShortcut:String){
		return this.addItem(mItem, sName, sDescription, sShortcut, 0);
	}

	public function removeItem(mItem) {
		for(var i=0; i<this.aItems.length; i++)
		{
			if(this.aItems[i].getItem() == mItem)
			{
				this.aItems[i].disable();
				this.aItems.splice(i, 1);
			}
		}
	}

	/**
	 * Fetch the ReadStackItem for a particular object
	 *
	 */
	public function getItem(mItem) {
		if(mItem == undefined) {
			return;
		}
		
		//trace("ReadGroup --> getItem(" + mItem._name + ")");
		
		for(var i=0; i<this.aItems.length; i++) {
			//trace("checking " + this.aItems[i].getItem()._name);
			
			if(this.aItems[i].getItem() == mItem) {
				//trace("returning item " + this.aItems[i].getName());
				return this.aItems[i];
			}
		}
		// else create it
		return this.addItem(mItem);
	}

	public function update(nStartIndex:Number){
		var nIndex = (nStartIndex == undefined) ? 1 : nStartIndex;
		var cnt = 0;
		
		var s = []
		for(var i=0; i<this.aItems.length; i++){
			if(this.aItems[i].getEnabled()) {
				this.aItems[i].setTabIndex(nIndex);
				s.push(this.aItems[i].getName());
				nIndex++;
				cnt++;
			}
		}
		//trace(this.sId + " ReadGroup --> update(" + nStartIndex + ")\n"+s.join(", "));
		return cnt;
	}

	public function remove() {
		for(var i=0; i<this.aItems.length; i++){
			this.aItems[i].disable();
		}
	}

	public function select(mItem) {
		this.getItem(mItem).select();
	}

	public function deselect(mItem) {
		this.getItem(mItem).deselect();
	}
	public function setEnabled(b:Boolean) {
		
		this.bEnabled = b;
		for(var i=0; i<this.aItems.length; i++){
			if(this.bEnabled) {
				this.aItems[i].enable();
			}else{
				this.aItems[i].disable();
			}
		}
		
		AccessManager.update();
	}
	public function getEnabled() {
		return this.bEnabled;
	}
}