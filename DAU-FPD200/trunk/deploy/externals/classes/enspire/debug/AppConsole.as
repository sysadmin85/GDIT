import mx.controls.ComboBox;
//
import mx.utils.Delegate;
//
import enspire.debug.ConsoleManager;
import enspire.core.Server;
import enspire.ile.AppEvents;
import enspire.debug.BaseConsole;
import enspire.model.Labels;
import enspire.core.SoundManager;
//INTEGRATE import enspire.interactivity.QuizManager;

class enspire.debug.AppConsole extends BaseConsole{
	private var cbChoices:ComboBox;
	private var tf:TextField;
	private var tfTitle:TextField;
	private var mcScroller:MovieClip;
	function AppConsole() {
		super();
		Server.connect(this, "init", AppEvents.START_APP);
	}
	function init() {
		Server.disconnect(this, AppEvents.START_APP);
		initChoices();
		update();
	}
	private function initChoices() {
		cbChoices.tabEnabled = false;
		cbChoices.addEventListener("change", Delegate.create(this, update));
		cbChoices.addItem({label:"Gui Controls Report", data:"controls"});
		cbChoices.addItem({label:"Structure Object", data:"structure"});
		//INTEGRATE cbChoices.addItem({label:"Quiz Data", data:"quiz"});
		cbChoices.addItem({label:"Panels Report", data:"panels"});
		cbChoices.addItem({label:"Controllers Report", data:"controllers"});
		cbChoices.addItem({label:"Registered Interactivities", data:"activities"});
		cbChoices.addItem({label:"Commands Report", data:"commands"});
		cbChoices.addItem({label:"Sound FXs Report", data:"fxs"});
		cbChoices.addItem({label:"XMLS Report", data:"xmls"});
	}
	function showControls() {
		var ctrls = Server.getController("gui").lControls.getArray();
		var s = "";
		
		for(var i:Number = 0; i < ctrls.length; i++) {
			var sKey = ctrls[i].key;
			var sValue = ctrls[i].value;
			s += "Control "+sKey+"\n";
			s += "\tClip: "+sValue._name+"\n";
			s += "\tPath: "+sValue+"\n";
			s += "\tLabel id: "+sValue.getName()+"\n";
			s += "\tLabel: "+Labels.getLabel(sValue.getName())+"\n";
			s += "\tCommand: "+sValue.getName()+"\n";
			s += "\tCmd avalible : "+(Server.commands.getCommand(sValue.getName()) != undefined)+"\n\n";
			
		}
		setText("CONTROLS", s);
	}
	function showPanels() {
		var panels = Server.getController("gui").lPanels.getArray();
		var s = "";
		
		for(var i:Number = 0; i < panels.length; i++) {
			var sKey = panels[i].key;
			var sValue = panels[i].value;
			s += "Panel "+sKey+"\n";
			s += "\tClip: "+sValue+"\n";
		}
		setText("CONTROLS", s);
	}
	function showControllers() {

		setText("CONTROLLERS", Server.getControllerIds().join("\n"));
	}
	function showCommands() {
		setText("COMMANDS", Server.commands.getCommandList().join("\n"));
	}
	function showXML() {
		var xList = Server.xmls.getXmlsList();
		var sText = "";
		var sNote = "\n\nNOTE: some xmls are deleted when they are parsed so they are not taking up memory, you will not see these in this report\n\n"
		if(xList.length > 0) {
			var sText = xList.join("\n") + sNote+ Server.xmls.dump();
		}else{
			var sText = "No Xmls to display " + sNote;
		}
		setText("XMLS", sText);
	}
	function showFxs() {
		var sText = SoundManager.getInstance().getFxList("\n");
		if(sText == "") {
			sText = "No Sound Fx Added";
		}
		setText("Sound FXs", sText);
	}
	function showActivities() {
		var a = Server.getController("activities").aActivityTypes.getArray();
		var sText = "";
		for(var i:Number = 0; i < a.length; i++) {
			sText += a[i].value.toString() +" \n";
			
		}
		setText("Registered Activities", sText);
		
	}
	function showStructure() {
		setText("Structure (new)", Server.model.structure.toString());
	}
	/* INTEGRATE
	function showQuizData() {
		setText("Quiz Data", QuizManager.dump());
		
	} */
	function update() {
		var sDisplay = cbChoices.selectedItem.data;
		switch(sDisplay) {
			case "controls":
					this.showControls();
				break;
			case "controllers":
					this.showControllers();
				break;
			case "commands":
					this.showCommands();
				break;
			case "activities":
					this.showActivities();
				break;
			case "xmls":
					this.showXML();
				break;
			case "panels":
					this.showPanels()
				break;
			case "fxs":
					this.showFxs();
				break;
			case "structure":
					this.showStructure();
				break;
			/* INTEGRATE
			case "quiz":
					this.showQuizData();
				break;
			*/
				
		}
	}
	function setText(sTitle:String, sText:String) {
		this.tfTitle.text = sTitle;
		this.tf.text = sText;
		this.tf.scroll = 0;
		mcScroller.reinit();
	}
	
}