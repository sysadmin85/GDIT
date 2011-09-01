import enspire.core.Command;
class enspire.core.SimpleCommand extends Command{
	private var aFunc:Function;
	function SimpleCommand(sName:String, aFunc:Function) {
		super(sName);
		this.aFunc = aFunc;
	}
	function execute(oArgs:Object) {
		//trace("execute");
		this.aFunc();
	}
}