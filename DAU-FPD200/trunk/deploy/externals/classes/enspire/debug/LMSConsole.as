import mx.controls.ComboBox;
//
import mx.utils.Delegate;
//
import org.asapframework.util.debug.Log;
//
import enspire.debug.BaseConsole;
import enspire.lms.LMSCommands;
import org.asapframework.util.FrameDelay;
//
class enspire.debug.LMSConsole extends BaseConsole{
	private var tfSet:TextField;
	private var tfGet:TextField;
	private var cb1:ComboBox;
	private var cb2:ComboBox;
	private var tfLog:TextField;
	private var mcC1:MovieClip;
	private var mcX1:MovieClip;
	private var mcC2:MovieClip;
	private var mcX2:MovieClip;
	private var mcC3:MovieClip;
	private var mcX3:MovieClip;
	private var mcApi:MovieClip;
	private var mcSet:MovieClip;
	private var mcGet:MovieClip;
	
	function LMSConsole() {
		super();
		this.mcApi.onRelease = Delegate.create(this, checkForApi);
		this.mcSet.onRelease = Delegate.create(this, setValue);
		this.mcGet.onRelease = Delegate.create(this, getValue);
		
		this.cb1.tabEnabled = this.cb2.tabEnabled = false;
		
		this.mcC1._visible = this.mcX1._visible = this.mcC2._visible = this.mcX2._visible = this.mcC3._visible = this.mcX3._visible = false;

		var fd = new FrameDelay(this, initDropDowns);
		 
	}
	
	function checkForApi() {
		var bSuccess = (LMSCommands.apiOK().toString() == "true");
		if(bSuccess) {
			mcC1._visible = true;
			mcX1._visible = false;
		}else{
			mcC1._visible = false;
			mcX1._visible = true;
		}
		writeResultsToLog("API is found "+bSuccess+"\n")
	}
	function setValue() {
		var sData = this.tfSet.text;
		
		
		var sValue = cb2.selectedItem.data;
		var sLabel = cb2.selectedItem.label;
		var message:String;
		switch(sValue) {
			case "started":
				message = LMSCommands.setStarted();
				break;
			case "passed":
				message = LMSCommands.setPassed();
				break;
			case "failed":			
				message = LMSCommands.setFailed();
				break;
			case "bookmark":
				message = LMSCommands.setBookmark(sData);
				break;
			case "score":
				message = LMSCommands.setScore(sData);
				break;
		}
		if((message == null) || (message == "null") || (message == "false")) {
			mcC2._visible = false;
			mcX2._visible = true;
		}else{
			mcC2._visible = true;
			mcX2._visible = false;
		}
		writeResultsToLog("SET "+sLabel+"\n"+message+"\n");
	}
	function getValue() {
		var sValue = cb2.selectedItem.data;
		var sLabel = cb2.selectedItem.label;
		var message:String;
		switch(sValue) {
			case "time":
				message = LMSCommands.getValue("cmi.core.session_time");
				break;
			case "bookmark":
				message = LMSCommands.getBookmark();
				break;
			case "status":
				message = LMSCommands.getValue("cmi.core.lesson_status");
				break;
			case "score":
				message = LMSCommands.getValue("cmi.core.score.raw");
				break;
		}
		this.tfGet.text = message;
		if((message == null) || (message == "null")  || (message == "false")) {
			mcC3._visible = false;
			mcX3._visible = true;
		}else{
			mcC3._visible = true;
			mcX3._visible = false;
		}
		writeResultsToLog("GET "+sLabel+"\n"+message+"\n");
	}
	private function writeResultsToLog(sLog:String) {
		this.tfLog.text += sLog;
		this.tfLog.scroll = this.tfLog.maxscroll;
		this.tfLog.reinit();
	}
	private function initDropDowns() {
		
		cb1.addItem({data:"started"  , label:"Course Status Started"});
		cb1.addItem({data:"passed"   , label:"Course Status Passed"});
		cb1.addItem({data:"failed"   , label:"Course Status Failed"});
		cb1.addItem({data:"score"    , label:"Course Score"});
		cb1.addItem({data:"bookmark" , label:"Suspend Bookmark"});
		

		cb2.addItem({data:"status"  , label:"Course Status"});
		cb2.addItem({data:"bookmark" , label:"Suspend Bookmark"});
		cb2.addItem({data:"time"  , label:"Elapsed Time"});
		cb2.addItem({data:"score"  , label:"Course Score"});
		
	}
}