import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State
class enspire.ile.commands.SegBack extends Command{
	function SegBack() {
		super("back");
	}
	public function execute() : Void {
		var app = Server.getController("app");
		// fire a override function
		if(app.fBackOverride != undefined) {
			app.fBackOverride();
			return;
		}
		if(State.bLoadingClip) {
			return;
		}
		// jump to content designated segment from arg
		var sSegFromArgs = Server.model.args["sBackSeg"];
		if((sSegFromArgs != undefined) && (sSegFromArgs != "")) {
			app.startSegment(sSegFromArgs);
			return;
		}
		app.gotoIndex(Server.model.getPrev());
	}
}