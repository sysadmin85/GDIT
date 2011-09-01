import enspire.core.Command;
import enspire.core.Server;
import enspire.core.SoundManager;
import enspire.model.State;
class enspire.ile.commands.VideoPlay extends Command{
	var player
	function VideoPlay(p) {
		super("play");
		this.player = p;
	}
	function execute() {
		////trace("\n\nVIDEO PLAY\n\n");
		State.bPaused = false;
		Server.getController("gui").updatePlayPauseState();
		this.player.resumeVideo();
	}
}