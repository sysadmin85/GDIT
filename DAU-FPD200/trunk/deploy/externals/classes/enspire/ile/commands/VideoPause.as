import enspire.core.Command;
import enspire.core.Server;
import enspire.core.SoundManager;
import enspire.model.State;
class enspire.ile.commands.VideoPause extends Command{
	var player
	function VideoPause(p) {
		super("pause");
		this.player = p;
	}
	function execute() {
		//trace("\n\nVIDEO PAUSE\n\n");
		State.bPaused = true;
		Server.getController("gui").updatePlayPauseState();
		this.player.pauseVideo();
	}
}