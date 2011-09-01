import org.asapframework.events.Dispatcher;
import org.asapframework.util.debug.Log;
import enspire.accessibility.KeyboardEvent;
import enspire.accessibility.KeyboardCommand;

class enspire.accessibility.Keyboard extends Dispatcher {
 
	private static var instance:Keyboard;
	private static var keys:Object = new Object();;
	// holdes all the keys that are down
	private var bEnabled:Boolean;
	private var down:Object;
	private var oCommands:Object;
	
	private function Keyboard() {
		super();
		this.down = new Object();
		this.oCommands = new Object();
		this.bEnabled = true;
		Key.addListener( this );
	}
	/**
	 * catch the key event
	 */
	private function onKeyDown(  ):Void {
		if(!this.bEnabled) { return; }
		var code:Number = Key.getCode();
		if( down[ code ] == undefined ) {
			down[ code ] = true;
			dispatchEvent( new KeyboardEvent( KeyboardEvent.KEY_DOWN, this, Key.getCode(), Key.getAscii(), Key.isDown( Key.SHIFT ), Key.isDown( Key.CONTROL ) ) );
		}
		if(Key.getCode()!= undefined) {
			this.checkForCommand(Key.getCode())
		}
	}
	private function onKeyUp(  ):Void {
		if(!this.bEnabled) { return; }
		var code:Number = Key.getCode();
		if( down[ code ] ) {
			down[ code ] = undefined;
			dispatchEvent( new KeyboardEvent( KeyboardEvent.KEY_UP, this, Key.getCode(), Key.getAscii(), Key.isDown( Key.SHIFT ), Key.isDown( Key.CONTROL ) ) );
		}
	}

	private function checkForCommand(nKey) {
		for(var elm in this.oCommands) {
			if(oCommands[elm].isDown(nKey)) {
				oCommands[elm].execute();
				//Log.info("Key Command "+oCommands[elm].id+" Execute", "Keybord" );
				break;
			}
		}
	}
	public function addCommand(kc:KeyboardCommand, bReplace:Boolean) {
		if((this.oCommands[kc.id] != undefined) && (!bReplace)) {
			//Log.error("Key Code allready set", "Keyboard");
			//trace(this.oCommands[kc.id]);
			return;
		}
		//Log.error("adding command "+kc.id, "Keyboard");
		this.oCommands[kc.id] = kc;
	}
	public function removeCommand(sID:String) {
		delete this.oCommands[sID];
	}
	public function getCommands() :Array {
		var a:Array = new Array();
		for(var elm in this.oCommands) {
			a.push(oCommands[elm]);
		}
		return a;
	}
	public function setEnabled(b:Boolean) {
		this.bEnabled = b;
	}
	public function getEnabled():Boolean {
		return this.bEnabled;
	}
	/**
	 * returns the Keyboard instance
	 */
	public static function getInstance(  ):Keyboard {
		if( instance == undefined ) {
			instance = new Keyboard();
			initKeyCodes();
		}
		return instance;
	}
	public static function getCode(sKey:String) : Number  {
		if( instance == undefined ) {
			instance = new Keyboard();
			initKeyCodes();
		}
		return keys[sKey] == undefined ? -1 : keys[sKey];
	}
	
	private static function initKeyCodes() {
		keys["backspace"] = 8;
		keys["enter"] = 	13;
		keys["shift"] =  	16;
		keys["Ctrl"] =  	17;
		keys["alt"] =  	 	18;
		keys["capslock"] =  20;
		keys["esc"] =  	 	27;
		keys["space"] =  	32;
		keys["0"] =  	 	48;
		keys["1"] =  	 	49;
		keys["2"] =  	 	50;
		keys["3"] =  	 	51;
		keys["4"] =  	 	52;
		keys["5"] =  		53;
		keys["6"] =  	 	54;
		keys["7"] =  	 	55;
		keys["8"] =  	 	56;
		keys["9"] =  	 	57;
		keys["a"] =  	 	65;
		keys["b"] =  	 	66;
		keys["c"] =  	 	67;
		keys["d"] =  	 	68;
		keys["e"] =  	 	69;
		keys["f"] =  	 	70;
		keys["g"] =  	 	71;
		keys["h"] =  	 	72;
		keys["i"] =  	 	73;
		keys["j"] =  	 	74;
		keys["k"] =  	 	75;
		keys["l"] =  	 	76;
		keys["m"] =  	 	77;
		keys["n"] =  	 	78;
		keys["o"] =  	 	79;
		keys["p"] =  	 	80;
		keys["q"] =  	 	81;
		keys["r"] =  	 	82;
		keys["s"] =  	 	83;
		keys["t"] =  	 	84;
		keys["u"] =  	 	85;
		keys["v"] =  	 	86;
		keys["w"] =  	 	87;
		keys["x"] =  	 	88;
		keys["y"] =  	 	89;
		keys["z"] =  	 	90;
		keys[";"] =  	 	186;
		keys["="] =  	 	187;
		keys[","] =  	 	188;
		keys["-"] =  	 	189;
		keys["."] =  	 	190;
		keys["/"] =  	 	191;
		keys["`"] =  	 	192;
		keys["["] =  	 	219;
		keys['\\'] =  	 	220;
		keys["]"] =  	 	221;
		keys["'"] =  	 	222;
		keys[")"] =  	 	48;
		keys["!"] =  	 	49;
		keys["@"] =  	 	50;
		keys["#"] =  	 	51;
		keys["$"] =  	 	52;
		keys["%"] =  	 	53;
		keys["^"] =  	 	54;
		keys["&"] =  	 	55;
		keys["*"] =  	 	56;
		keys["("] =  	 	57;
		keys["A"] =  	 	65;
		keys["B"] =  	 	66;
		keys["C"] =  	 	67;
		keys["D"] =  	 	68;
		keys["E"] =  	 	69;
		keys["F"] =  	 	70;
		keys["G"] =  	 	71;
		keys["H"] =  	 	72;
		keys["I"] =  	 	73;
		keys["J"] =  	 	74;
		keys["K"] =  	 	75;
		keys["L"] =  	 	76;
		keys["M"] =  	 	77;
		keys["N"] =  	 	78;
		keys["O"] =  	 	79;
		keys["P"] =  	 	80;
		keys["Q"] =  	 	81;
		keys["R"] =  	 	82;
		keys["S"] =  	 	83;
		keys["T"] =  	 	84;
		keys["U"] =  	 	85;
		keys["V"] =  	 	86;
		keys["W"] =  	 	87;
		keys["X"] =  	 	88;
		keys["Y"] =  	 	89;
		keys["Z"] =  	 	90;
		keys[":"] =  	 	186;
		keys["plus"] =  	187;
		keys["<"] =  	 	188;
		keys["_"] =  	 	189;
		keys[">"] =  	 	190;
		keys["?"] =  	 	191;
		keys["~"] =  	 	192;
		keys["{"] =  	 	219;
		keys["|"] =  	 	220;
		keys["}"] =  	 	221;
		keys['"'] =  	 	222;
		keys["pause"] =  	19;
		keys["pageup"] =  	33;
		keys["pagedown"] =  34;
		keys["end"] =  	 	5;
		keys["home"] =  	36;
		keys["ins"] =  	 	45;
		keys["delete"] =  	46;
		keys["scrolllock"] =145;
		keys["left"] =  	37;
		keys["up"] =  	 	38;
		keys["right"] =  	39;
		keys["down"] =  	40;
		keys["f1"] =  	 	112;
		keys["f2"] =  	 	113;
		keys["f3"] =  	 	114;
		keys["f4"] =  	 	115;
		keys["f5"] =  	 	116;
		keys["f6"] =  	 	117;
		keys["f7"] =  	 	118;
		keys["f8"] =  	 	119;
		keys["f9"] =  	 	120;
		keys["f10"] =  	 	121;
		keys["f11"] =  	 	122;
		keys["f12"] =  	 	123;
	}
}