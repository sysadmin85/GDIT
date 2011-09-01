import mx.controls.ComboBox;
import mx.utils.Delegate;
import org.asapframework.util.debug.Log;
import enspire.core.Server;
import enspire.model.State;
import enspire.utils.ILE_utils;
import enspire.ile.AppEvents;
//
class enspire.debug.JumpMenu extends MovieClip{
	var cbSegs:ComboBox;
	var cbClips:ComboBox;
	var mcNext:MovieClip;
	var mcBack:MovieClip;
	var bAddSectTitle:Boolean;
	var tfDebug:TextField;
	function JumpMenu() {
		this._visible = false;
	}
	function init() {
		//Log.status("Init", toString());
		// make sure these are not in the tab order
		cbSegs.tabEnabled = cbClips.tabEnabled = false;
		//
		cbSegs.addEventListener("change", Delegate.create(this, gotoSeg));
		cbClips.addEventListener("change", Delegate.create(this, gotoClip));
		this.makeClipList();
		this.makeSegList();
		
		this.mcNext.onRelease = function() {
			Server.run("next");
		}
		this.mcBack.onRelease = function() {
			Server.run("back");
		}
		Server.connect(this, "update", AppEvents.START_SEG);
		Server.addController("debug");
		
		this._visible = true;
	}
	function gotoSeg() {
		Server.getController("app").gotoIndex(cbSegs.selectedItem.data);
	}
	function gotoClip() {
		////Log.status("Goto Clip: "+cbClips.selectedItem.label, toString());
		Server.getController("app").gotoIndex(cbClips.selectedItem.data);
	}
	function update() {
		this.makeSegList();
		this.setSelected();
		this.tfDebug.text = ILE_utils.debugCounter();
	}
	function setSelected() {
		var sLabel = State.sClipId;
		if(bAddSectTitle) {
			sLabel = State.sSectionId + "/" + sLabel;
		}
		for(var i:Number = 0; i < cbClips.length; i++) {
			////trace("LOOKING FOR CLIP - Label: "+cbClips.getItemAt(i).label+" Clip: "+sLabel);
			if(cbClips.getItemAt(i).label == sLabel) {
				cbClips.selectedIndex = i;
				continue;
			}
		}
		for(var i=0; i< cbSegs.length; i++) {
			////trace("LOOKING FOR SEG - Label: "+cbSegs.getItemAt(i).label+" Seg: "+State.sSegmentId);
			if(cbSegs.getItemAt(i).label == State.sSegmentId) {
				cbSegs.selectedIndex = i;
				return;
			}
		}
		
	}
	function makeSegList() {
		cbSegs.removeAll();
		var aSegs =  Server.model.clip.getAllSegs();
		
		//Log.status("Make Seg List "+aSegs.length, toString());
		for(var i=0; i< aSegs.length; i++) {
			cbSegs.addItem({label:aSegs[i].id, data:aSegs[i].nAbsoluteIndex});	
		}	
	}
	function makeClipList() {
		cbClips.removeAll();

		var clips = Server.model.structure.aClips;
		
		var bMultipleChapters = (Server.model.structure.getChapterCount() > 1);
		var bMultipleSections = (!bMultipleChapters &&  !(Server.model.structure.aChapters[0].getSectionCount() == 1));
		////trace("bMultipleChapters: "+bMultipleChapters+"\nbMultipleSections: "+bMultipleSections+"\nServer.model.structure.aChapters[0].getSectionCount(): "+Server.model.structure.aChapters[0].getSectionCount());		
		for(var i:Number = 0; i < clips.length; i++) {
			var clip = clips[i];
			////trace("DEBUG make clip menu "+clips[i]);
			var sID = "";
			if(bMultipleChapters) {
				sID += clip.chapter.id + "/"
			}
			if(bMultipleSections) {
				sID += clip.section.id + "/";
			}
			sID += clip.id;
			
			cbClips.addItem({label:sID, data:clip.getStartSegIndex()});	
			
			
			
		}
	}
	function setPosition(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function toString() {
		return "enspire.debug.JumpMenu";
	}
}










