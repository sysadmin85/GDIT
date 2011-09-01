import enspire.ile.GuiController;
import enspire.display.ContentArea;
import enspire.display.TabSet;
import enspire.model.Labels;
import enspire.display.controls.GuiControl;
import enspire.display.controls.GuiToggle;
import enspire.accessibility.AccessManager;
import enspire.accessibility.Keyboard;
import enspire.accessibility.KeyboardCommand;
import enspire.core.Server;
import enspire.display.panels.*;
import enspire.core.SimpleCommand;

// init the guiController
var gui = GuiController.init(this, "main");

//---------------------------------------------------------------- DO NOT ALTER ABOVE THIS LINE UNLESS YOU ARE ADDING AN IMPORT


var oControllerContainer = this.mcController;
var oNavContainer = this.mcNavigation;
var oCaptionsContainer = this.mcCaptionPanel;
var oResourceContainer = this.mcNavigation;
var oTabsContainer = this.mcNavigation;


//--------------------------------- Content Area ---------------------------------------- //


var cArea = gui.makeContentArea("main", this.mcContent, this.mcContent.mcMask._width, this.mcContent.mcMask._height);
cArea.addContentContainer("clipPlayer");
cArea.addContentContainer("interactivity");
cArea.addContentContainer("templates");

// --------------------------------- Controls --------------------------------------------//

gui.addControl(oControllerContainer.mcNext, GuiControl);
gui.addControl(oControllerContainer.mcPause, GuiControl);
gui.addControl(oControllerContainer.mcPlay, GuiControl);
gui.addControl(oControllerContainer.mcReplay, GuiControl);
gui.addControl(oControllerContainer.mcBack, GuiControl);
gui.addControl(oControllerContainer.mcGlossary, GuiControl);





// ------------------------------------ NAV -----------------------------------------------//

var nav = gui.makeDisplayObject(oNavContainer.mcNavHolder, SimpleClipNav);
Server.addController("nav", nav);

// ------------------------------------ PANELS ----------------------------------------------//


// make page number display
gui.addPanel("pgnum", this.mcPage, PageNumberDisplay);
// make title bar
gui.addPanel("titlebar", this.mcTitle, TitleBar);
// make the naration container
gui.addPanel("captions", oCaptionsContainer, CaptionsContainer);


// -----------------------------------Tab Group --------------------------------------------//

// add tabs and tabable panel clips
gui.addTab("tabs", oTabsContainer.mcNavTab, oNavContainer.mcNavHolder);
gui.addTab("tabs", oTabsContainer.mcCaptionsTab, oCaptionsContainer.mcCaptions);
gui.addTab("tabs", oTabsContainer.mcResourcesTab, oResourceContainer.mcResourcesHolder);
gui.selectTab("navtab", "tabs");

// ----------------------------------------------------------------------------------------------- do not change below 


gui.togglePausePlay(false);
gui.initControls();

Server.loader.addToQueue("interactivity/interactivity.swf", gui.getContainer("interactivity").getClip());
Server.loader.addToQueue("base/templates.swf", gui.getContainer("templates").getClip());
Server.loader.runQueue();


this.stop();

