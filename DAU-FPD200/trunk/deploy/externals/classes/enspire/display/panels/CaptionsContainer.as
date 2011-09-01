import org.asapframework.util.debug.Log;

import com.mosesSupposes.fuse.Fuse;
import enspire.utils.TextFieldUtils;
import enspire.display.TextBox;
import enspire.core.Server;
import enspire.ile.AppEvents;

import enspire.accessibility.ReadItem;
import enspire.accessibility.ReadGroup;
import enspire.accessibility.AccessManager;

class enspire.display.panels.CaptionsContainer extends MovieClip {
	private var tf:TextField;
	private var aText:Array;
	private var fQueue:Fuse;
	private var aQueue:Array;
	private var mcText:MovieClip;
	private var read:ReadItem;
	function CaptionsContainer() {
		super();
		Server.connect(this, "update", AppEvents.START_SEG);
		TextFieldUtils.setStyleSheet(this.mcText.tf)
		//this.read = AccessManager.addItem("controls", this.mcText, "Captions", "");
	}
	function runQueue(aText:Array, sTimes:String) {
		//trace("Starting Text Queue");
		//this.refresh();
		var nTime = 0;
		var aTimes = sTimes.split(",");
		// prepare fuse
		this.fQueue = new Fuse();
		this.fQueue.scope = this;
		this.fQueue.autoClear = true;
		// set first line of text
		this.aQueue = aText;
		this.aQueue.reverse();
		this.setNextText();
		//Log.debug("Starting Queue "+this.aQueue.length, this.toString());
		for(var i:Number = 1; i < this.aQueue.length; i++) {
			var nT = parseInt(aTimes[i]);
			var newTime = nT - nTime;
			
			if(!isNaN(nT)) {
				//Log.debug("Setting queue: "+this.aQueue[i]+"\ntime: "+newTime, this.toString());
				this.fQueue.push({delay:newTime});
				this.fQueue.push({func:"setNextText"});
				nTime += nT;
			}else{
				//Log.error("Non number given for delay in text queue", this.toString());
			}
		}
		this.fQueue.start();
	}
	private function setNextText() {
		
		var sText = this.aQueue.pop();
		
		this.mcText.tf.htmlText = sText;
	}
	function update() {
		var args = Server.model.args
		var sCapText = (args.text  ==  undefined) ? " " : args.text;
		
		
		
		this.mcText.tf.htmlText = sCapText;
		//this.read.setDescription( sCapText );
	}
	
	
	function refresh() {
		this.fQueue.destroy();
		this.aQueue = new Array()
	}
	function pause() {
		if(this.fQueue == undefined) return;
		this.fQueue.pause();
	}
	function resume() {
		if(this.fQueue == undefined) return;
		this.fQueue.resume();
	}
	function toString() {
		return "enspire.display.CaptionsContainer";
	}
}