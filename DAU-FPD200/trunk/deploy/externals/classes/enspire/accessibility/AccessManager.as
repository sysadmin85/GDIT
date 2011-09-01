/*	Class: AccessManager 
	a static class used to implement a tab read order for 508 compliance, note as of right now setGroupOrder() must be set in the begining of the application or ReadGroups will be dropped
	
*/
import org.asapframework.util.debug.Log;
import enspire.accessibility.ReadGroup
import enspire.accessibility.ReadItem;
class enspire.accessibility.AccessManager{
	/* Group: Private Static Vars
	
		Var: aGroups
		this holds the array of groups
	*/
	private static var aGroups:Array = new Array();
	/*	Var: aGroupOrder
		this holds an array or strings used to build the group order
	*/
	private static var aGroupOrder:Array = new Array();;
	
	private static var trace_ID:String = "enspire.accessibility.AccessManager";
	
	/* Group: Public Static Methods
	
		Function: doProto
		this function should be called in begining if 508 is an requirment so that all MovieClips and TextFields are silent and untabable by default
	*/
	public static function doProto() {
		////Log.status("Do initial prototyping", trace_ID);
		// take care of tabbing
		//MovieClip.prototype.tabEnabled = false;
		MovieClip.prototype._accProps = {};
		// mark the accProps as the default
		MovieClip.prototype._accProps.bDefault = true;
		MovieClip.prototype._accProps.silent = true;
		MovieClip.prototype._accProps.forceSimple = true;
		// textfields
		TextField.prototype.tabEnabled = false;
		TextField.prototype._accProps = {};
		TextField.prototype._accProps.silent = true;
		// update accessibility properties
		Accessibility.updateProperties();
	}
	public static function addItem(sGroup:String, item:Object, sName:String, sDescription:String, sShortcut:String) : ReadItem {
		return AccessManager.createGroup(sGroup).addItem(item, sName, sDescription, sShortcut);;
	}
	/* Function: update
		this function reorders the tab order
	*/
	public static function update() {
		//trace("\n\nAccessManager --> update() # groups: "+aGroups.length);
		
		// update group order before we assign indices
		updateGroupOrder();
		
		var nIndex:Number = 1;
		
		for(var i=0; i<aGroups.length; i++){
			//trace("AccessManager --> updating group " +nIndex+ aGroups[i].getId());
			//trace("starting index: "+ nIndex);
			//trace("Group enabled: "+aGroups[i].getEnabled());
			if(aGroups[i].getEnabled()) {
				nIndex += aGroups[i].update(nIndex);
			}
		}
		Accessibility.updateProperties();
	}
	/* Function: createGroup
		creates an instance of a enspire.accessibility.ReadGroup or returns an instance if the group has already been created
		
		Parameters:
			sId -  required, this is the string id of the Read Group
			bSticky - true/false deterines if a group is retained when refresh is called
	*/
	public static function createGroup(sId:String, bSticky:Boolean){
		for(var i=0; i<aGroups.length; i++){
			if(aGroups[i].getId() == sId){
				//trace("returning existing group " + aGroups[i].getId());
				return aGroups[i];
			}
		}
		//trace("CREATING GROUP "+sId+" - "+bSticky);
		var oGroup = new ReadGroup(sId, bSticky);
		aGroups.push(oGroup);
		update();
		
		//////Log.debug("Creating Read group " + aGroups[i].getId()+" is sticky: "+bSticky, trace_ID);
		return oGroup;
	}
	public static function disableGroup(sId:String) {
		var grp = getGroup(sId);
		grp.setEnabled(false);
		update();
	}
	public static function enableGroup(sId:String) {
		var grp = getGroup(sId);
		grp.setEnabled(true);
		update();
	}
	public static function getGroup(sId:String) {
		for(var i=0; i<aGroups.length; i++){
			if(aGroups[i].getId() == sId){
				//trace("returning group " + aGroups[i].getId());
				return aGroups[i];
			}
		}
		return;
	}
	public static function createStickyGroup(sId:String) {
		//trace("CREATE STICKY GROUP"+sId);
		return createGroup(sId, true);
	}

	public static function removeGroupById(sId:String) {	
		for(var i=0; i<aGroups.length; i++){
			if(aGroups[i].getId() == sId){
				aGroups[i].remove();
				aGroups.splice(i, 1);
			}
		}
		update();
	}
	public static function setGroupFocus(sGroup:String, n:Number) {
		//trace("setGroupFocus: "+sGroup);
		getGroup(sGroup).setFocus(n);
	}
	public static function refresh(){
		for(var i=0; i<aGroups.length; i++){
			if(!aGroups[i].isSticky()){
				//trace("AccessManager --> removing unsticky group " + aGroups[i].getId());
				aGroups[i].remove();
				aGroups.splice(i, 1);
				i--;
			}
		}
		update();
	}
	public static function setGroupOrder(aOrder:Array) {
		//trace("AccessManager --> setGroupOrder(" + aOrder + ")");
		
		aGroupOrder = aOrder;
		updateGroupOrder();
	}

	public static function updateGroupOrder() {
		//trace("AccessManager --> updateGroupOrder()");
		
		var sTmp = "";
		for(var i=0; i<aGroups.length; i++) {
			sTmp += aGroups[i].getId() + ", ";
		}
		//trace("AccessManager --> Old Group Order: " + sTmp);
		
		
		var aNewOrder:Array = [];
		var aArbTemp:Array = [];
		var nArbPos:Number;
		
		for(var i=0; i<aGroupOrder.length; i++){
			var sId = aGroupOrder[i];
			//trace("AccessManager --> look for group "+sId);
			// Split off each group from the internal group array one by one as they match ids.
			// If we encounter *, remember its position and skip it for now
			if(sId == "*") {
				nArbPos = i;
				continue;
			}

			for(var j=0; j<aGroups.length; j++){
				
				//trace("AccessManager --> ("+j+") looking for match "+aGroups[j].getId());
				if(aGroups[j].getId() == sId){
					
					aNewOrder.push(aGroups.splice(j, 1)[0]);
					j--;
				}
			}
		}
		
		// at this point, all that should be left is groups that haven't been claimed.
		// we'll insert those at the saved insertion point
		for(var i=0; i<aGroups.length; i++){
			aNewOrder.splice(nArbPos, 0, aGroups.shift());
			i--;
			nArbPos++;
		}

		
		aGroups = aNewOrder;
	
		
		// temp
		var sTmp = "";
		for(var i=0; i<aGroups.length; i++) {
			sTmp += aGroups[i].getId() + ", ";
		}
		//trace("AccessManager --> New Group Order: " + sTmp);
	}
}