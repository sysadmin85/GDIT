import enspire.display.layout.BoxLayout;
import enspire.model.ChoiceData;
class DisplayManager {
	public var mcClip;
	public var layout;
	public var activity;
	public var controller;
	public var args:Object
	public var profile:Object;
	
	function DisplayManager(mcClip:MovieClip) {
		trace("DisplayManager Init");
		this.mcClip = mcClip;
	}
	function draw() {
		trace("Draw Display");
		this.layout = new BoxLayout(this.mcClip.mcHolder);
		
		// replace with profile choice skin
		var sLink = "Choice";
		
		// get the choice data from the controller and make mcChoices or use the ones on the stage
		var aChoices = controller.getChoices();
		for(var i:Number = 0; i < aChoices.length; i++) {
			var mcChoice = mcClip.mcHolder["mcChoice"+i];
			if(mcChoice == undefined) {
				mcChoice = attachElement("Choice", i);
			}
			this.makeChoice(mcChoice, aChoices[i], i) 
		}
		
		this.layout.setOffset(5)
		layout.update();
	}
	function init() {
		var a = this.layout.getElements();
		for(var i:Number = 0; i < a.length; i++) {
			a[i].init();
			trace(a[i]+"display init");
		}
		this.mcClip.init();
		this.update();
		
	}
	public function enable() {
		var a = this.layout.getElements();
		for(var i:Number = 0; i < a.length; i++) {
			a[i].disable();		}
	}
	public function disable() {
		var a = this.layout.getElements();
		for(var i:Number = 0; i < a.length; i++) {
			a[i].enable();
		}
	}
	public function showCorrects(bCorrect:Boolean) {
		if(bCorrect) {
			this.mcClip.markCorrect();
		}else{
			this.mcClip.markIncorect();
		}
		var a = this.layout.getElements();
		for(var i:Number = 0; i < a.length; i++) {
			a[i].enable();
		}
	}
	function update() {
		this.layout.update();
		if(this.mcClip.mcBg != undefined) {
			this.mcClip.mcBg._height = this.mcClip.mcHolder._height + (this.mcClip.mcHolder._y * 2);
		}
		trace("Update Layout");
	}
	private function makeChoice(mcChoice:MovieClip, oChoice:ChoiceData, nOrder:Number) {
		mcChoice.template = this;
		mcChoice.choice = oChoice;
		mcChoice.activity = activity;
		mcChoice.controller = this.controller;
		mcChoice.args = activity.args;
		mcChoice.sLetter = String.fromCharCode(nOrder + 65);
		mcChoice.nOrder = nOrder;
		mcChoice.nIndex = oChoice.getIndex();
		mcChoice.updateAfterEvent()
		this.layout.addElement(mcChoice);
		trace("MAking Choice: "+mcChoice+oChoice.toString());
	}
	private function attachElement(sLinkage:String, n:Number) {
		var mc = this.mcClip.mcHolder.attachMovie(sLinkage, "mcChoice"+n, n);
		trace("CHOICE CLIP CREATED: "+mc); 
		return mc;
	}
}