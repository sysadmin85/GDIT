import enspire.core.Server
import enspire.ile.AppEvents;
import enspire.display.layout.ToggleClipSlider;

class enspire.display.panels.SimpleClipMenu extends MovieClip{
	private var menuItems:Array;
	public static var MENU_PADDING = 0;

	function SimpleClipMenu() {
		this.menuItems = new Array();
	}
	public function initMenu() {
		var nY = 0;
		var aClips = Server.model.structure.aClips;
		// loop through clips
		////trace("CourseMenu: calling initNav() number of clips: "+aClips.length);
		for(var i:Number = 0; i < aClips.length; i++) {
			var mcClipTitle = this.attachMovie("mainMenu_clipTitle", "mcClipTitleTitle"+i, i);
			////trace("MenuItem Added");
			mcClipTitle._y = nY;
			nY += MENU_PADDING;
			nY += mcClipTitle._height;
			
			
			mcClipTitle.mcText.tf.htmlText = aClips[i].title;
			mcClipTitle.mcText.tf.html = true;
			mcClipTitle.mcText.tf.autoSize = true;
			mcClipTitle.bSelected = false;
			mcClipTitle.bCurrent = false;

			mcClipTitle.nSegIndex = aClips[i].getStartSegIndex();
			mcClipTitle.bVisited = false;
			mcClipTitle.navMenu = this;
			
			mcClipTitle.onRelease = function() {
				Server.getController("app").gotoIndex(this.nSegIndex);
				this.bSelected = true;
			}
			mcClipTitle.onRollOver = function() {
				if(!this.bSelected) {
					this.gotoAndStop("over")
				}else{
					this.gotoAndStop("selected");
				}
				
			}
			mcClipTitle.onRollOut = mcClipTitle.onReleaseOutside = function() {
				if(!this.bSelected) {
					this.gotoAndStop("out");
				}else{
					this.gotoAndStop("selected");
				}
			}			
			this.menuItems.push(mcClipTitle);
		}
		this.displayNav(0, 0, 0);
		
	}
	public function displayNav(secId:Number, clipId:Number, segId:Number) {
		////trace("DISPLAY MENU  "+clipId+" LOOPING THROUGH "+menuItems.length);
		for(var i = 0; i < menuItems.length; i++) {
			if(i == clipId) {
				////trace("SELECT: "+menuItems[i]);
				menuItems[i].bSelected = true;
				menuItems[i].gotoAndStop("selected");
			}else {
				////trace("DESELECT: "+menuItems[i]);
				menuItems[i].gotoAndStop("up");
				menuItems[i].bSelected = false;
			}
		}
	}
	public function toString() {
		return "enspire.display.panels.CourseMenu";
	}
}