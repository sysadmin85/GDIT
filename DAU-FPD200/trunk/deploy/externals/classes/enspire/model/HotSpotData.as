class enspire.model.HotSpotData{
	private var nId:Number;
	// 
	var sText:String;
	var sHeader:String;
	var sClose:String;
	var sImage:String;
	var sLabel:String;
	
	var profile:Object;
	
	var bVisited:Boolean;
	var bSelected:Boolean;
	

	var sAlignX:String;
	var sAlignY:String;
	
	var mcSpot:MovieClip;
	
	function HotSpotData(sText:String, nIndex:Number) {
		this.nId = nIndex;
		this.sText = sText;
		this.bVisited = false;
		this.bSelected = false;
	}
	function get nIndex() :Number {
		return this.nId;
	}
	function toString() {
		return "HotSpot "+nIndex+"\nsText: "+sText+"\nsHeader: "+sHeader+"\nsImage: "+sImage+"\n";
	}
}