import org.asapframework.util.debug.Log;
import enspire.core.ICommand
class enspire.core.Command implements ICommand{
	private var sName:String;
	function Command(sName:String) {
		if((sName == undefined) || (sName == "")) {
			//Log.error("Commands must have a name", this.toString());
		}
		this.sName = sName;
		////Log.info("Commands created: "+sName, this.toString());
	}
	public function getName() : String {
		return this.sName;
	}
	public function execute(oArgs:Object) : Void {

	}
	public function toString() {
		return "Cmd: "+this.sName;
	}
}