import org.asapframework.util.debug.Log;
import enspire.core.ICommand;
import enspire.core.Command;
class enspire.core.CompoundCommand extends Command{
	private var aCommands:Array;
	
	function CompoundCommand(sName:String) {
		super(sName);
		this.aCommands = new Array();
	}
	function addCommand(cmd:Command) {
		if(!(cmd instanceof Command)) {
			//Log.error("addCommand(cmd:Command) - cmd is not Command", this.toString()); 
			return;
		}
		this.aCommands.push(cmd);
	}
	public function execute(oArgs:Object) {
		for(var i:Number = 0; i < this.aCommands.length; i++) {	
			
		}
		
	}
	
	
	
	
}