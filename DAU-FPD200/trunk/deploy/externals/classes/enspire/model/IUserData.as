interface enspire.model.IUserData{
	public function getBookmark() : String; 
	public function parseBookmark(sBookmark:String) : Void;
	public function getData(sId:String) : String;
	public function storeData(sId:String, sData:String) : Void; 
	
}