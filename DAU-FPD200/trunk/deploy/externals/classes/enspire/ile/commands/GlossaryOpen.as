import enspire.core.Command;
import enspire.core.Server;
import enspire.model.State;
import enspire.model.Configs;
import enspire.core.SoundManager;
class enspire.ile.commands.GlossaryOpen extends Command{
	function GlossaryOpen() {
		super("glossary");
	}
	function execute() {
		getURL(Configs.getConfig("sGlossaryUrl"), "_blank")
	}
}