import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;
class enspire.ile.commands.SegAutoplay extends Command{
	function SegAutoplay() {
		super("autoplay");
	}
	function execute() {
		//trace("seg AutoPlay");
		State.bAutoplay = !State.bAutoplay;
		Server.getController("gui").setAutoplay(State.bAutoplay);
	}
}