import enspire.loader.LoadData;
class enspire.loader.PreloaderEvent{
	
	public static var ON_LOAD_START:String = "onLoadStart";
	public static var ON_LOAD_PROGRESS:String= "onLoadProgress";
	public static var ON_LOADED:String = "onLoaded";
	public static var ON_LOAD_ERROR:String = "onLoadError";
	public static var ON_ALL_LOADED:String = "onAllLoaded";
	
	public var type:String;
	public var data:LoadData;
	public var progress:Number;
	
	function PreloaderEvent(sType:String, lData:LoadData, nProgress:Number) {
		////trace("\nPreloaderEvent."+sType+"\nData: "+lData);
		this.type = sType;
		this.data = lData;
		this.progress = nProgress;
	}
	
}