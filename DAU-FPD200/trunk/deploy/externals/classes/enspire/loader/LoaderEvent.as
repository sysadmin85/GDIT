import enspire.loader.ILoader;
import enspire.loader.LoadData;
class enspire.loader.LoaderEvent{
	
	public static var ON_LOAD_PROGRESS:String= "onLoadProgress";
	public static var ON_LOAD_ERROR:String = "onLoadError";
	public static var ON_LOADED:String = "onLoaded";
	
	public var type:String; 
	public var data:LoadData;
	public var loader:ILoader;
	public var isBackground:Boolean
	public var status:String;
	
	function LoaderEvent(sType:String, lData:LoadData, oLoader:ILoader, sStatus:String) {
		////trace("\nLoaderEvent."+sType);
		this.type = sType;
		this.data = lData;
		this.loader = oLoader;
		this.status = sStatus;
	}
}