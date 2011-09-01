import enspire.core.Server;
import enspire.model.Labels;
import enspire.ile.AppEvents;
class enspire.display.panels.SimpleProgressDisplay {
	var mcTitle:MovieClip;
	var mcPercent:MovieClip;
	var mcMask:MovieClip;
	function SimpleProgressDisplay() {
		Server.connect(this, "update", AppEvents.START_SEG);
		setTitle();
	}
	function setTitle() {
		this.mcTitle.tf.text = Labels.getLabel("progress");
	}
	function update() {
		var n = Server.model.structure.getProgress()
		this.mcPercent.tf.text = n+"%";
		mcMask._xscale = n;
	}
}