import mx.utils.Delegate;
import org.asapframework.util.debug.Log;
import org.asapframework.util.ObjectUtils;
import org.asapframework.util.ArrayUtils;
import enspire.accessibility.Keyboard;
import enspire.core.Command;

class enspire.accessibility.KeyboardCommand extends Command {
	private var aKeys:Array;
	private var sName:String;
	private var fAction:Function;
	private var checkInt:Number;
	
	function KeyboardCommand(sKeyCombo:String, func:Function) {
		super(sKeyCombo);
		this.sName = sKeyCombo;
		this.fAction = func;
		this.evalCode(sKeyCombo);

	}
	
	private function evalCode(s:String) {
		if(s.length == 0) {
			//Log.error("Empty code submitted", this.toString());
			return;
		}
		this.aKeys = new Array();
		var aCodeParts = s.split("+");
		for(var i:Number = 0; i < aCodeParts.length; i++) {
			var nKey:Number = Keyboard.getCode(aCodeParts[i]);
			if(isNaN(nKey)) {
				//Log.error("aCodeParts[i] is a uwknown key", this.toString());
			}else{
				this.aKeys.push(nKey);
			}
		}
		//ObjectUtils.//traceObject(this.aKeys);
	}
	public function isDown(nKey:Number) {
		////trace("Checking is down "+nKey);
		if(ArrayUtils.findElement(this.aKeys, nKey) == -1) { return false; }
		////trace("Calling is down "+ this.aKeys.length);
		for(var i:Number = 0; i < this.aKeys.length ; i++) {
			////trace(this.sName+ " Checking for key down "+Key.isDown(this.aKeys[i])+" key - "+this.aKeys[i]);
			if(!Key.isDown(this.aKeys[i])) {
				return false;
			}
			
		}
		return true;
	}
	public function get id() {
		return this.sName;
	}
	public function execute() : Void {
		//Log.info("execute", this.toString());
		this.fAction()
	}
	public function toString() : String {
		return "KeyboardCommand "+this.sName;
	}
	
}