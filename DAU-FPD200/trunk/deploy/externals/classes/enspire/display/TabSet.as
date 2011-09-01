import org.asapframework.util.debug.Log;
import org.asapframework.data.KeyValueList;
import enspire.utils.ConstructorUtil;
import enspire.display.TabControl;
class enspire.display.TabSet {
	private var lTabs:KeyValueList;
	private var mcSelectedTab:MovieClip;
	private var sName:String;

	public var onTabSelected:Function;
	public var onTabDeselected:Function;
	
	function TabSet(sName:String) {
		this.sName = sName;
		this.lTabs = new KeyValueList();
		//Log.info("Tabset created "+this.sName, toString());
	}
	// need to add panel classing and stuff
	public function addTab(tab:TabControl) {
		//Log.info("Tabset Tab Added "+tab.getName(), toString());
		this.lTabs.addValueForKey(tab, tab.getName());
	}
	public function setSelected(sName:String){
		var tab = this.getTab(sName);
		this.onTabDeselected(this.mcSelectedTab)
		this.onTabSelected(tab);
		this.mcSelectedTab.deselect()
		this.mcSelectedTab = tab;
		this.mcSelectedTab.select();
	}
	public function selectTab(sTab:String){
		var tab = this.getTab(sTab);
		if(tab != undefined) {
			if(tab == this.mcSelectedTab) {
				return;
			}
			tab.onRelease();
			return;
		}
		//Log.error("TabSet: ERROR - "+sTab+" is not a registerd tab", this.toString());
	}
	public function getName() {
		return this.sName;
	}
	function getTab(sName:String) {
		return this.lTabs.getValueForKey(sName);
	}
	function hasTab(sName:String) : Boolean {
		return (this.lTabs.getValueForKey(sName) == undefined);
	}
	function removeTab(sName:String) : Void{
		this.lTabs.removeValueForKey(sName) ;
	}
	function toString() {
		return "TabGroup: "+this.sName;
	}
}