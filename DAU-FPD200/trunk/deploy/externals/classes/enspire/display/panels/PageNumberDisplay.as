import org.asapframework.util.debug.Log;
//
import enspire.core.Server;
import enspire.display.TextBox;
import enspire.ile.AppEvents;
import enspire.model.State;
import enspire.model.Configs;
import enspire.model.Labels;

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;

class enspire.display.panels.PageNumberDisplay extends TextBox {
	private var sDiv:String;
	private var sPre:String;
	private var sPost:String;
	private var read:ReadItem
	// we add listener for seg start and add controller to server
	function PageNumberDisplay() {
		super()
		// make sure that this updates on the start of ever seg
		Server.connect(this, "update", AppEvents.START_SEG);
		//
		this.sDiv = this.getLabelText("pgNumberingDivider", "/")
		this.sPre = this.getLabelText("pgNumberingPreText", "");
		this.sPost= this.getLabelText("pgNumberingPostText", "");
		// clear any text in the textfield
		this.text = "";
		
		
		//this.read = AccessManager.addItem("gui1", this, "Page Number", "Page Number");
		//Log.status("init instance: "+this._name, this.toString());
	}
	// this function gets calles on the start of ever seg
	function update() {
		// empty text as defualt
		var sPageNumber = "";
		// check to see if we have a over ride comming from the args
		if(Server.model.args.sPageNumber != undefined) {
			sPageNumber = Server.model.args.sPageNumber;
		}else if((!State.bFirstSegInClip) && (Configs.getConfig("bTitleSeg")) && (!State.bBranching)){
			sPageNumber = this.sPre + Server.model.seg.nPageNumber + this.sDiv + (State.nTotalSegments - 1) + this.sPost;
		}
		
		this.read.setDescription(sPageNumber);
		this.text = sPageNumber;
	}
	private function getLabelText(sLabel:String, sDefault:String) : String {
		var s = Labels.getLabel(sLabel);
		if(s == undefined) {
			return sDefault;
		}
		return s;
	}
	public function show() {
		this._visible = true;
	}
	public function hide() {
		this._visible = false;
	}
	public function toString() {
		return "enspire.display.PageNumberDisplay";
	}
}