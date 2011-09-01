class enspire.core.Event {
    public var type:String;
    public var target:Object;

    function Event (sType:String, oTarget:Object) {
        type = sType;
        target = oTarget;
    }
}
