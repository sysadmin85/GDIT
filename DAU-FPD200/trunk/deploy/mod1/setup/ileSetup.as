// this files is to make easy access to application initial file loads and add commands to the application command library
import enspire.core.Server;
import enspire.model.Configs;
import enspire.model.Labels;
import enspire.model.State;
import enspire.model.IleModel;
import enspire.model.SimpleUserData;
import enspire.ile.commands.*;
// interactivity
/* INTEGRATE
import enspire.interactivity.InteractivityManager;
import enspire.interactivity.InteractivityFactory;
import enspire.interactivity.types.*;
import enspire.interactivity.templates.*;
*/
// templates
import enspire.display.TemplateManager;
import enspire.display.TemplateFactory;

Server.model = new IleModel();

// ------------------------------------------------------------------------- User Data

Server.setUserdata(new SimpleUserData());

// need to hold off on this until configs are loaded 
// set our bookmark if we have one
if(app.getBookmark() != undefined) {
	Server.user.parseBookmark(unescape(_root.sData))
}

// ------------------------------------------------------------------------- Do After Content Load
app.onInitContentLoaded = function() {
	// this does the full struct parse and labels parse
	Server.model.createLabels();
	Server.model.createModel();
	Server.model.createResources();
	// this can be changed so if you need to do a login screen or a code enter for modular content
	app.gotoLabel("run");
}


// -------------------------------------------------------------------------- Add Commands For this course
Server.commands.addCommand(new SegNext());
Server.commands.addCommand(new SegBack());
Server.commands.addCommand(new SegPlay());
Server.commands.addCommand(new SegPause());
Server.commands.addCommand(new SegReplay());
Server.commands.addCommand(new SegMute());
Server.commands.addCommand(new SegAutoplay());
Server.commands.addCommand(new CourseExit());

Server.commands.addCommand(new GlossaryOpen());

// -------------------------------------------------------------------------- Interactivity Setup
/* INTEGRATE
var interactivity = InteractivityManager.getInstance()
// register the interactivity factory
interactivity.registerFactory(new InteractivityFactory());
// register activity types
interactivity.register("MultChoice", "Choice", "SimpleChoice", "ChoiceStandard", "DefaultActivity", "MultChoice");
interactivity.register("MultSelect", "Select", "SimpleChoice", "ChoiceStandard", "DefaultActivity", "MultSelect")
interactivity.register("MultChoiceRight", "Choice", "SimpleChoiceRight", "ChoiceStandard", "DefaultActivity", "MultChoice");
interactivity.register("MultSelectRight", "Select", "SimpleChoiceRight", "ChoiceStandard", "DefaultActivity", "MultSelect");
interactivity.register("SimpleMultChoice", "Choice", "StageChoice", "ChoiceStandard", "DefaultActivity", "MultChoice");
interactivity.register("SimpleMultSelect", "Select", "StageChoice", "ChoiceStandard", "DefaultActivity", "MultSelect");
*/
// --------------------------------------------------------------------------  Templates Setup
var templates = TemplateManager.getInstance();
// set the template and alert factory
templates.registerFactory(new TemplateFactory());
// fade is done with Fuse - durration is set in seconds - defualt is .5
templates.setFadeDuration(Configs.getConfig("nFadeDuration"));


State.appState = "initLoad";
Server.loader.addToQueue("base/base.swf", app.getTimeline().mcBase);
Server.loader.addToQueue("xmls/labels.xml", Server.xmls.createXml("labels") );
Server.loader.addToQueue("xmls/audio.xml", Server.xmls.createXml("audio") );
Server.loader.addToQueue("full-struct.xml", Server.xmls.createXml("struct") );
Server.loader.addToQueue("xmls/resources.xml", Server.xmls.createXml("resources") );
Server.loader.addToQueue("xmls/videoCaptions.xml", Server.xmls.createXml("videoCaptions") );
// if we need the ift add it to the preload queue
if(bUseIft()) {
	Server.loader.addToQueue("ift/ift.swf", app.getTimeline().mcIFT);
	Server.loader.addToQueue("ift/ift_project_id.txt", Server.xmls.createXml("ift"));
}
Server.loader.runQueue();


