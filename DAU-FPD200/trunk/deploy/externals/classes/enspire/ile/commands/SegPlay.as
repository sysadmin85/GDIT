import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;
class enspire.ile.commands.SegPlay extends Command{
	function SegPlay() {
		super("play");
	}
	function execute() {
		if(!State.bPaused) return;
		Server.getController("gui").getContentArea().resume();
		
		if(!State.bEndedAudio){
			Server.sounds.resume();
		}	
		State.bPaused = false;
		Server.getController("gui").updatePlayPauseState();
		// do not know if this line is needed?
		//Server.getController("clipPlayer").broadcastMessage("onResume");
	}
}