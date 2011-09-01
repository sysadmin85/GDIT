import mx.utils.Delegate;
//
import enspire.debug.ConsoleManager
import enspire.core.Server;
import enspire.ile.AppEvents;
import enspire.model.Configs;
import enspire.model.Labels;
import enspire.model.State;
import enspire.model.Resources;

import enspire.debug.BaseConsole;
import enspire.utils.ILE_utils;
//
class enspire.debug.ArgsConsole extends BaseConsole{
	private var tf:TextField;
	private var tfSeg:TextField;
	private var tfInst:TextField;
	private var tfArg:TextField;
	private var tfValue:TextField;
	private var mcScroller:MovieClip;
	private var sDisplay:String;
	private var mc1:MovieClip;
	private var mc2:MovieClip;
	private var mc3:MovieClip;
	private var mc4:MovieClip;
	private var mc5:MovieClip;
	private var mc6:MovieClip;
	private var mc7:MovieClip;
	private var currentSegId;
	function ArgsConsole() {
		super();
		Server.connect(this, "update", AppEvents.START_SEG);
		Server.connect(this, "end", AppEvents.END_SEG);
		
		
		this.mc1.onRelease = Delegate.create(this, showArgs);
		this.mc2.onRelease = Delegate.create(this, showConfigs);
		this.mc3.onRelease = Delegate.create(this, showLabels);
		this.mc4.onRelease = Delegate.create(this, showResources);
		this.mc5.onRelease = Delegate.create(this, showState);
		this.mc6.onRelease = Delegate.create(this, showStyles);
		this.mc7.onRelease = Delegate.create(this, updateArgs);
		this.sDisplay = "args";
		
	}
	public function showArgs() {
		sDisplay = "args";
		var sTitle = "Args "+this.currentSegId;
		var sText = Server.model.argsToString();
		this.setText(sTitle, sText);
	}
	public function showConfigs() {
		sDisplay = "cfgs";
		var sTitle = "Course Configs";
		var sText = Configs.toDump();
		this.setText(sTitle, sText);
		
	}
	public function showResources() {
		sDisplay = "res";
		var sTitle = "Course Resources";
		var sText = Resources.toDump();
		this.setText(sTitle, sText);
	
	}
	public function showLabels() {
		sDisplay = "lbs";
		var sTitle = "Course Labels";
		var sText = Labels.toString();
		this.setText(sTitle, sText);
	}
	public function showState() {
		sDisplay = "state";
		var sWhen = State.bSegEnded ? "Ended" : "Started ";
		var sTitle = "Segment "+ sWhen + "State "+this.currentSegId;
		var sText = ILE_utils.doStateDump();
		this.setText(sTitle, sText);
	}
	public function showStyles() {
		sDisplay = "style";
		var styleNames:Array = Server.textStyle.getStyleNames();
		var sText = "";
        if (!styleNames.length) {
            sText = "There are no styles defined, add styles to css/app.css";
        } else {
            for (var i = 0; i<styleNames.length; i++) {
                var styleName:String = styleNames[i];
               	sText += "Style "+styleName+":\n";
                var styleObject:Object = Server.textStyle.getStyle(styleName);
                for (var propName in styleObject) {
                    var propValue = styleObject[propName];
                    sText += "\t"+propName+": "+propValue + "\n";
                }
            }
        }
		var sTitle = "Course CSS Styles";
		this.setText(sTitle, sText);
	}
	function updateArgs() {
		var arg = this.tfArg.text;
		if(arg == "") {
			return;
		}
		
		Server.model.args[arg] = this.tfValue.text;
		update();
	}
	function setText(sTitle:String, sText:String) {
		this.tfSeg.text = sTitle;
		this.tf.text = sText;
		this.tf.scroll = 0;
		mcScroller.reinit();
	}
	public function update() {
		this.currentSegId = ILE_utils.getLocationAsString();
		this.tfInst.text = "Change/Add Arg for Segment "+this.currentSegId;
		
		if(sDisplay == "args") {
			this.showArgs();
		}else if(sDisplay == "state"){
			showState();
		}
	}
	public function end() {
		if(sDisplay == "state"){
			this.showState();
		}
	}
	public function toString() {
		return "enspire.debug.ArgsConsole";
	}
}