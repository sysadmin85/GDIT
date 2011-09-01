import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;

class enspire.ile.commands.SegMute extends Command{
	function SegMute() {
		super("mute");
	}
	function execute() {
		//trace("mute pressed");

		Server.sounds.setMute(!State.bMute)
		Server.getController("gui").getControl("autoplay").setEnabled(Server.sounds.isMute());

	}
}