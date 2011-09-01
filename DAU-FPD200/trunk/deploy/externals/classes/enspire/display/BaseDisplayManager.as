/*	Class: enspire.display.BaseDisplayManager
	Any display manager class should extend this class
*/
import enspire.display.ContentContainer;
class enspire.display.BaseDisplayManager{
	/*
	
	*/
	private var cContainer:ContentContainer;
	function BaseDisplayManager() {
		
	}
	
	/*	Group: Utility Functions*/
	public function setContainer(container:ContentContainer) {
		//trace("SETTING CONTAINER: "+container.getClip()+" - "+this.toString());
		this.cContainer = container
	}
	public function get clip() {
		return this.cContainer.getClip();
	}
	public function getWidth() {
		this.cContainer.getWidth();
	}
	public function getHeight() {
		this.cContainer.getHeight();
	}
	public function toString() {
		return "enspire.display.BaseDisplayManager";
	}
	
}