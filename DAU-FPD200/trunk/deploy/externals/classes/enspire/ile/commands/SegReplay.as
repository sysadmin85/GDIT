import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;
class enspire.ile.commands.SegReplay extends Command{
	function SegReplay() {
		super("replay");
	}
	function execute() {
		//Server.getController("clipPlayer").mcSkin.mcClip.gotoAndStop(1);
		//Server.getController("clipPlayer").startSegment( Server.getController("clipPlayer").oCurrentSegment.id );
		
		Server.getController("gui").getContainer("clipPlayer").getClip().gotoAndStop(1);
		Server.getController("app").gotoIndex(State.nAbsoluteIndex);
	}
}