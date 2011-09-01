import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
//
import enspire.core.ICommand;
//
class enspire.core.CommandLibrary{
	// store all librarys create so that we have a single point of global acsess
	private static var lLibrarys:KeyValueList = new KeyValueList();
	// name of the library and a holder for our commands
	private var sName:String;
	private var lCommands:KeyValueList;
	function CommandLibrary(sName:String) {
		this.sName = sName;
		this.lCommands = new KeyValueList();
		lLibrarys.addValueForKey(this, this.sName);
		//Log.info("Library Created", this.toString());
	}
	function getName() : String{
		return this.sName;
	}
	// --------------------------------------------------------- Library functions
	// add takes anything that extends ICommand
	// get returns a command
	// run calls a commands execute funtion and takes a optional args object
	// remove removes a command from the library
	// Kill removes ENTIRE library of 
	public function addCommand(cmd:ICommand) {
		if(!(cmd instanceof ICommand)) {
			//Log.error("addCommand(cmd:Command) - cmd is not Command", this.toString()); 
			return;
		}
		//Log.info("Command Added: "+cmd.getName(), this.toString());
		this.lCommands.addValueForKey(cmd, cmd.getName());
	}
	public function getCommand(sCmd:String) : ICommand {
		var cmd = this.lCommands.getValueForKey(sCmd);
		if(cmd == undefined) {
			//Log.error("Unknown Command: "+sCmd, this.toString());
		}
		return cmd;
	}
	public function hasCommand(sCmd:String) {
		return  (this.lCommands.getValueForKey(sCmd) != undefined);
	}
	public function removeCommand(sName:String) {
		this.lCommands.removeValueForKey(sName);
	}
	public function runCommand(sCmd:String, oArgs:Object) : Void {
		var cmd:ICommand = getCommand(sCmd);
		cmd.execute(oArgs);
	}
	public function clearCommands() {
		this.lCommands = new KeyValueList();
		/*var nTotal = this.lCommands.getCount();
		for(var i:Number = (nTotal - 1); i >= 0; i++) {
			 this.lCommands.removeObjectAtIndex(i);
		}*/
	}	
	public function getCommandList() : Array{
		var cmds = this.lCommands.getArray();
		var a = new Array();
		for(var i=0; i < cmds.length; i++) {
			a.push(cmds[i].key);
		}
		return a;
	}
	public function toString() : String {
		return "CommandLibrary: "+this.sName;
	}
	//------------------------------------------------------------ Static functions
	// get any libary in application
	public static function getLibrary(sName:String) : CommandLibrary {
		var lib = lLibrarys.getValueForKey(sName);
		if(lib == undefined) {
			//Log.error("Unknown Command Library: "+sName, "enspire.core.CommandLibrary");
		}
		return 
	}
}