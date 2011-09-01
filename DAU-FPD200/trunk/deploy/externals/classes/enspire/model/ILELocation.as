class enspire.model.ILELocation{
	public var nChapter:Number;
	public var nSection:Number;
	public var nClip:Number;
	public var nSegment:Number;
	
	function ILELocation(nChapter:Number, nSection:Number, nClip:Number, nSegment:Number) {
		this.nChapter = nChapter;
		this.nSection = nSection
		this.nClip = nClip
		this.nSegment = nSegment
	}
	public function encode() {
		return this.nChapter+"."+this.nSection+"."+this.nClip+"."+this.nSegment;
	}
	
	public function toString() {
		return "enspire.model.ILELocation: chapter "+this.nChapter+", section: "+this.nSection+", clip: "+this.nClip+", seg: "+this.nSegment;
	}
	public static function parseEncodedLocation(s:String) {
		var a = s.split(".");
		
		var nChapter = parseInt(a[0]);
		var nSection = parseInt(a[1]);
		var nClip    = parseInt(a[2]);
		var nSegment = parseInt(a[3]);
		
		return new  ILELocation(nChapter, nSection, nClip, nSegment);
	}
}