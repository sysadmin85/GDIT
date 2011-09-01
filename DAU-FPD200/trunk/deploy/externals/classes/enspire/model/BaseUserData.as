import org.asapframework.data.KeyValueList;
import enspire.model.IUserData;
import enspire.model.Configs;

class enspire.model.BaseUserData implements IUserData{
	private var lData:KeyValueList;
	private static var DELIMITER:String = "|";
	function BaseUserData() {
		this.lData = new KeyValueList();
	}
	public function getBookmark() : String{
		return this.makeBookmark();
	}
	public function parseBookmark(sBookmark:String) : Void {
		var aSaveData = sBookmark.split(DELIMITER);
		var aSaveOrder = Configs.getConfig("aSaveOrder");
		for(var i:Number = 0; i < aSaveOrder.length; i++) {
			var sData = aSaveData[i] == undefined ? "" : aSaveData[i];
			
			this.lData.addValueForKey(sData , aSaveOrder[i]);
		}
	}
	public function getData(sId:String) : String {
		return this.lData.getValueForKey(sId);
	}
	public function storeData(sId:String, sData:String) : Void {
		this.lData.setValueForKey(sData, sId);
	}
	private function makeBookmark() {
		//use config array to make suspend string
		var aOrder = Configs.getConfig("aSaveOrder");
		var aSaveData = new Array();
		for(var i:Number = 0; i < aOrder.length; i++) {
			aSaveData[i] = this.lData.getValueForKey(aOrder[i]);
		}
		return aSaveData.join(DELIMITER); 

	}
	
}