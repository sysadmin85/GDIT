import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;
class enspire.ile.commands.SegNext extends Command{
	function SegNext() {
		super("next");
	}
	public function execute() : Void {
		var app = Server.getController("app");
		// fire an override if we have one defined
		if(app.fNextOverride != undefined) {
			app.fNextOverride();
			return;
		}
		if(State.bLoadingClip) {
			return;
		}
		// jump to content designated segment from arg
		var sSegFromArgs = Server.model.args["sNextSeg"];
		if((sSegFromArgs != undefined) && (sSegFromArgs != "")) {
			app.startSegment(sSegFromArgs);
			return;
		}
		app.gotoIndex(Server.model.getNext());
	}
}