import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
import enspire.accessibility.AccessManager;
import enspire.accessibility.ReadGroup;
import enspire.display.ContentArea;
import enspire.display.controls.BaseControl;
import enspire.display.controls.ControlGroup;
import enspire.display.controls.ServerControlWrapper;
import enspire.display.TabControl;
import enspire.display.TabSet;
import enspire.model.Labels;
import enspire.model.State;
import enspire.utils.ConstructorUtil;
//
class enspire.display.BaseGui{
	private var mcTimeline:MovieClip;
	private var sName:String;
	private var lAreas:KeyValueList;
	public var lControls:KeyValueList;
	public var lGroups:KeyValueList;
	public var lTabSets:KeyValueList;
	public var lPanels:KeyValueList;
	private var rgControls:ReadGroup;

	//
	public function BaseGui(inTimeline:MovieClip, sName:String) {
		this.mcTimeline = inTimeline;
		this.sName = sName;
		this.lControls = new KeyValueList();
		this.lGroups = new KeyValueList();
		this.lTabSets = new KeyValueList();
		this.lAreas = new KeyValueList();
		this.lPanels = new KeyValueList();
		if(State.bAccessible) {
			AccessManager.createGroup("controls", true);
		}
	}
	
	public function addPanel(sName:String, mcPanel, fPanel:Function) : Void {
		if(fPanel != undefined) {
			var newPanel = ConstructorUtil.createVisualInstance(fPanel, mcPanel);
			this.lPanels.addValueForKey(newPanel, sName);
		}else{
			this.lPanels.addValueForKey(mcPanel, sName);
		}	
	}
	public function getPanel(sName:String) {
		return this.lPanels.getValueForKey(sName);
	}
	public function hasPanel(sName:String) : Boolean {
		return (this.lPanels.getValueForKey(sName) == undefined);
	}
	public function removePanel(sName:String) : Void {
		this.lPanels.removeValueForKey(sName) ;
	}
	// to do late make gui store groups so we can disable entire groups at one time and ass assess ability
	public function addControl(mcControl, fControl:Function, sGroup:String, sShortcut:String) : Void {
		if(fControl == undefined) {
			fControl = BaseControl;
		}
		// set the buttons class
		var control = ConstructorUtil.createVisualInstance(fControl, mcControl);
		control.init();
		// add control to controls list
		var sName = control.getName();
		this.lControls.addValueForKey(control, sName);
		
		if(sGroup != undefined) {
			this.addToGroup("all", control);
		}
		this.addToGroup(sGroup, control);
		// if we are accessibile add to read group
		if(State.bAccessible) {
			var sDescription = Labels.getLabel(sName+"_desc");
			control.makeReadable("controls", sName, sDescription);
		}
		
		//Log.info("Control created: " + sName+" "+control.toString(), toString());
	}
	public function getControl(sName:String) {
		return this.lControls.getValueForKey(sName);
	}
	public function hasControl(sName:String) : Boolean {
		return (this.lControls.getValueForKey(sName) == undefined);
	}
	public function removeControl(sName:String) : Void{
		this.lControls.removeValueForKey(sName) ;
	}
	public function makeContentArea(sArea:String, mcArea:MovieClip, nW:Number, nH:Number) {
		var cArea = new ContentArea(sArea, mcArea, nW, nH);
		this.lAreas.addValueForKey(cArea, sArea);
		return cArea;
	}
	public function getContainer(sName:String, sArea:String) {
		return this.getContentArea(sArea).getContainer(sName);
	}
	public function getContentArea(sArea:String) {
		if(sArea == undefined) {
			sArea = "main";
		}
		return this.lAreas.getValueForKey(sArea);
	}
	public function getContentAreaHeight(sArea:String) {
		return this.lAreas.getValueForKey(sArea).getHeight();
	}
	public function getContentAreaWidth(sArea:String) {
		return this.lAreas.getValueForKey(sArea).getHeight();
	}
	public function addTab(sGroup:String, mcTab:MovieClip, mcPanel:MovieClip, fTab:Function, sShortcut:String) {
		var tGroup = this.lTabSets.getValueForKey(sGroup);
		var rgTabs:ReadGroup;
		if(tGroup == undefined) {
			tGroup = new TabSet(sGroup)
			this.lTabSets.addValueForKey(tGroup, sGroup);
			if(State.bAccessible) {
				AccessManager.createGroup(sGroup, true);
			}
		}
		if(fTab == undefined) {
			fTab = TabControl;
		}
		// set the buttons class
		var tab = ConstructorUtil.createVisualInstance(fTab, mcTab);
		tab.init();
		tab.setTabSet(tGroup);
		tab.setPanel(mcPanel);
		
		tGroup.addTab(tab);
		
		// add to read group
		if(State.bAccessible) {
			var sDescription = Labels.getLabel(tab.getName()+"_desc");
			tab.makeReadable(sGroup, tab.getName(), sDescription, sShortcut);
		}
	}
	public function getTabset(sGroup) {
		if(sName == undefined) {
			sName = "tabs";
		}
		return this.lTabSets.getValueForKey(sName);
	}
	public function selectTab(sTab:String, sGroup:String) {
		if(sGroup == undefined) {
			sGroup = "tabs";
		}
		this.getTabset(sGroup).selectTab(sTab);
		//Log.status("setTab: "+sTab, this.toString());
	}
	public function disableControl(sName:String) {
		this.getControl(sName).setEnabled(false);
	}
	public function enableControl(sName:String) {
		this.getControl(sName).setEnabled(true);
	}
	public function pulseControl(sName:String) {
		this.getControl(sName).pulse()
	}
	public function resetControl(sName:String){
		this.getControl(sName).reset();
	}
	public function disableGroup(sName:String) {
		this.lGroups.getValueForKey(sName).setEnabled(false);
	}
	public function enableGroup(sName:String) {
		this.lGroups.getValueForKey(sName).setEnabled(true);
	}
	public function getBaseTimeline() {
		return this.mcTimeline;
	}
	private function addToGroup(sGroup:String, control:BaseControl) {
		var cGroup = this.lGroups.getValueForKey(sName);
		if(cGroup == undefined) {
			cGroup = this.lGroups.addValueForKey(new ControlGroup(sName), sName);
		}
		cGroup.addControl(control);
	}
	public function makeDisplayObject(mc:MovieClip, fClass:Function) {
	 	return ConstructorUtil.createVisualInstance(fClass, mc);
	
	}
	public function toString() {
		return "enspire.display.BaseGui";
	}
}