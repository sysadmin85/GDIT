import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;
class enspire.ile.commands.SegPause extends Command{
	function SegPause() {
		super("pause");
	}
	function execute() {
		if(State.bPaused) return;
		Server.getController("gui").getContentArea().pause();
		
		if(!State.bEndedAudio){
			Server.sounds.pause();
		}
		State.bPaused = true;
		Server.getController("gui").updatePlayPauseState();
	}
}