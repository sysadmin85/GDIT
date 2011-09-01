import enspire.model.ResourceData;
class enspire.model.ResourceGroup{
	private var id:String;
	private var aResources:Array;
	private var sAppend:String;
	public function ResourceGroup(id:String, sAppend:String) {
		this.id = id
		this.sAppend = sAppend;
		this.aResources = new Array();
	}
	public function getId() {
		return this.id;
	}
	public function getAppend() {
		return this.sAppend;
	}
	public function addResource(rd:ResourceData) {
		this.aResources.push(rd)
	}
	public function getResourse(nResource:Number) {
		return this.aResources[nResource];
	}
	public function getResourseById(sId:String) : ResourceData {
		for(var i:Number = 0; i < this.aResources.length; i++) {
			if(this.aResources[i]["id"] == sId) {
				return this.aResources[i];
			}
		}
		return undefined;
	}
	public function getAllResourses() {
		return this.aResources;
	}
	public function toString() {
		var s = "";
		if(this.sAppend != "") {
			s += "\n\tappend: "+this.sAppend+"\n";
		}
		for(var i:Number = 0; i < this.aResources.length; i++) {
			s += "\t\tResource: "+id+" "+i+"\n"+this.aResources[i].toString()+"\n";
		}
		return s;
	}
}