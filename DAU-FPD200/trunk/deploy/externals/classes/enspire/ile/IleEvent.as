import enspire.core.Event;
class enspire.ile.IleEvent extends Event {
	public static var START_SEG:String = "onAfterStartSeg";
	public var args:Object;
	function IleEvent (sType:String, oTarget:Object, oArgs:Object) { 
       super(sType, oTarget) ;
	   this.args = oArgs;
    }
	
}