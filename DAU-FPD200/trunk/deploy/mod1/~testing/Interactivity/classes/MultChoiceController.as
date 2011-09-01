import org.asapframework.util.debug.Log;
import org.asapframework.util.ArrayUtils;

import enspire.interactivity.SelectionManager;
import enspire.interactivity.ChoiceEvaluator;
import enspire.model.ChoiceData;

class MultChoiceController  {
	public var display
	public var template
	public var activity;
	public var evaluator:ChoiceEvaluator;
	public var selector:SelectionManager;
	public var args:Object
	public var profile:Object;
	private var aChoices:Array;
	private var nIndex:Number;
	private var sMode:String;
	private var bCorrect:Boolean;
	
	public function MultChoiceController(sData:String, nIndex:Number) {
		trace("MultChoiceController Created");
		// create selector or
		this.aChoices = new Array();
		this.restoreSaveData(sData);
		this.evaluator = new ChoiceEvaluator();
		this.selector = new SelectionManager(false);
		this.nIndex = nIndex;
		this.sMode = "active";
		this.bCorrect = false;
	}
	// call init on display may need to do some stuff based on mode
	function init() {
		trace("INIT CONTROLLER");
		this.display.init();
	}
	// go and get our model for the args
	function buildModel() {
		trace("MultChoiceController build model");
		
		// loop through choices will need to refactor to get args on a multiple skin
		var i:Number = 0;
		while(this.args["sChoice" + i] != undefined) {
			var bCorrect:Boolean = (this.args["nCorrect"].indexOf(i.toString()) != -1)
			var sText = this.args["sChoice" + i];
			var oChoice = new ChoiceData(sText, bCorrect, i)
			this.aChoices.push(oChoice);
			i++;
			Log.info("Added Choice:\n"+oChoice.toString()+"\n", this.toString());
		}
		// check to see if we need to randomize
		if(this.profile.bRandomizeChoices) {
			ArrayUtils.randomize(this.aChoices)
		}
		this.evaluator.setCorrect(this.args["nCorrect"]);
		this.display.draw();
	}
	
	// returns the mode the activity. The mode is in is set by activity
	public function get mode() {
		return this.sMode;
	}
	
	// get the array of choices
	public function getChoices() : Array {
		return this.aChoices;
	}
	
	// get a choice data object
	public function getChoice(n:Number) : Object {
		return this.aChoices[n];
	}
	
	// runs choice eavluator and return outcome to activity
	public function isCorrect() {
		var sSelected = this.selector.getSelectedIds();
		return this.evaluator.check(sSelected);
	}
	
	// check to make sure we have at leaset one selected could refactor to use profile to allow no selections
	public function isReadyForSubmit() {
		return !this.selector.isNoneSelected();
	}
	// attch a displat manager for this interactivity
	public function setDisplay(display) {
		this.display = display;
		this.display.controller = this;
	}
	// gets the selection id is for use in feedback selection
	public function getSelectionId() {
		return this.selector.getSelectedString();
	}
	
	// set the mode to either inactive active or review
	public function setMode(sMode:String) {
		this.sMode = sMode;
		switch(this.sMode) {
			case Activity.MODE_INACTIVE:
				this.display.diable();
				break;
			case Activity.MODE_ACTIVE:
				this.display.enable();
				break;
			case Activity.MODE_REVIEW:
				this.display.diable();
				this.display.showCorrects(this.isCorrect());
				break;
		}
	}
	// manager our selecteion
	function setSelected(mc:MovieClip) {
		this.selector.select(mc);
		if(this.sMode == Activity.MODE_ACTIVE) {
			this.activity.setSubmitReady(this.isReadyForSubmit(), this.nIndex);
		}
	}
	// get and restore data 
	public function restoreSaveData(sData:String) {
		
	}
	// gets the saved selections as a . delemited string
	public function getSaveData() {
		return this.selector.getSelectedString(".");
	}
	function submit() {
		var sSelected = this.selector.getSelectedIds();
		return this.evaluator.check(sSelected);
	}
	
	
}