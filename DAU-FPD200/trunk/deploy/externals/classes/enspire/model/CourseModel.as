import enspire.model.Labels;
import enspire.model.State;
import enspire.model.Resources;
import enspire.model.ICourseModel
import enspire.core.Server
import enspire.ile.Release;

class enspire.model.CourseModel implements ICourseModel{
	public static var LABELS:String = "labels";
	public static var RESOURCES:String = "resources";
	public static var IFT:String = "IFT";
	private var oArgs:Object;

	function CourseModel() {
		
	}
	// empty function overwrite in sub class
	public function createModel() : Void {
		
	}
	// most of these are just empty functions to be extended for different models so we can use the ICourseModel Interface to type class
	
	// seperating this out so you have access to labels before you build the model
	public function createLabels() {
		if(Server.xmls.hasXml( LABELS )) {
			Labels.parseLabels( Server.xmls.getXml( LABELS , true) );
		}
	}
	public function createResources() {
		if(Server.xmls.hasXml( RESOURCES )) {
			Resources.parseResources( Server.xmls.getXml( RESOURCES , true) );
		}
	}
	private function setArgs(o:Object) : Void {
		this.oArgs = o;
	}
	public function get args() : Object {
		return this.oArgs;
	}
	public function dump() : String{
		return;
	}
	public function getArg(sName:String) : String {
		return this.oArgs[sName];
	}
	public function getTextArg(sName:String) : String {
		var arg = this.oArgs[sName];
		if(arg == undefined) {
			if(State.sRelease != Release.FINAL) {
				return "Missing Arg: "+sName;
			}else{
				return "";
			}
		}
		return arg; 
	}
	public function getLabel(sName:String) : String{
		var sLabel = Labels.getLabel(sName);
		if(sLabel == undefined) {
			if(State.sRelease != Release.FINAL) {
				return "Missing Label "+sName;
			}else{
				return "";
			}
		}
		return sLabel;
	}
	public function getResource(sName:String) {
		
	}
	public function getNext() : Object {
		return;
	}
	public function getPrev() : Object {
		return;
	}
	public function toString() : String{
		return "enspire.model.CourseModel";
	}
}