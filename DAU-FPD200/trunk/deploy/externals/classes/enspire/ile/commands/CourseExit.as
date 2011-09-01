import enspire.core.Command;
import enspire.core.Server;
import flash.external.ExternalInterface;
class enspire.ile.commands.CourseExit extends Command{
	function CourseExit() {
		super("exit");
	}
	function execute() {
		ExternalInterface.call("scoClose");
	}
}