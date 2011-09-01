class enspire.loader.LoadData {

	private var oScope:Object;
	private var sUrl:String;
	private var sName:String;
	private var nBytesTotal:Number;
	private var nBytesLoaded:Number;
	private var fCallback:Function;
	private var oCallbackScope:Object;
	private var nTotal:Number;
	private var nLoaded:Number;

	public function LoadData ( sUrl:String, oLoc:Object,sName:String, fCallback:Function, oCallbackScope:Object) {
		this.oScope = oLoc;
		this.sUrl = sUrl;
		this.sName = sName;
		this.fCallback = fCallback;
		this.oCallbackScope = oCallbackScope;
	}

	public function set location (oLoc:MovieClip) : Object {
		oScope = oLoc;
	}
	public function get location () : Object {
		return oScope;
	}
	
	public function set url(inUrl:String) : Void {
		sUrl = inUrl;
	}
	public function get url() : String {
		return sUrl;
	}
	
	public function set name(inName:String) : Void {
		sName = inName;
	}
	public function get name() : String {
		return sName;
	}
	
	public function set bytesTotal(inTotal:Number) : Void {
		nBytesTotal = inTotal;
	}
	public function get bytesTotal() : Number {
		return nBytesTotal;
	}
	
	public function set bytesLoaded(inLoaded:Number) : Void {
		nBytesLoaded = inLoaded;
	}
	public function get bytesLoaded() : Number {
		return nBytesLoaded;
	}
	// get a lowercse string of the file exstinsion
	public function getType() {
		return this.sUrl.substr((this.sUrl.lastIndexOf(".")+1)).toLowerCase();
	}
	public function doCallback() {
		if((fCallback == undefined) || (oCallbackScope == undefined)) {
			return;
		}
		//trace("Running Callback " + oCallbackScope);
		this.fCallback.apply(this.oCallbackScope.scope);
	}
	public function toString () : String {
		return "LoadData; location=" + oScope + "; url=" + sUrl + "; name=" + sName + "; total bytes=" + nBytesTotal + "; loaded bytes=" + nBytesLoaded;
	}
}
