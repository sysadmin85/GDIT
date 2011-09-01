// xpath
import com.xfactorstudio.xml.xpath.XPath;
// asap classes
import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
//
import enspire.model.ResourceData;
import enspire.model.ResourceGroup;
//
class enspire.model.Resources{
	//
	private static var ID:String = "emspire.model.Resourses";
	private static var lResourses:KeyValueList = new KeyValueList();
	//
	public static function parseResources(xml:XML) : Void {
		//Log.status("Parse resources start", ID);
		var theXML:XML = XML(xml);
		var groups = XPath.selectNodes(theXML.firstChild, "group");
		
		////Log.debug("# of groups "+groups.length, ID);
		
		// get resourse groups
		for(var i:Number = 0; i < groups.length; i++) {
			var elm = groups[i].attributes;
			var append = (elm.append == undefined) ? "" : elm.append;
			var grp = new ResourceGroup(elm.id, elm.append);
			
			// add all the resources to groups
			var resource = XPath.selectNodes(groups[i], "resource");
			////Log.debug("# of resources "+resource.length, ID);
			for(var j:Number = 0; j < resource.length; j++) {
				
				var rd = new ResourceData();
				var rNode = resource[j];
				
				//add all attributes on the resources node
				for(var elms in rNode.attributes) {
					rd[elms] = rNode.attributes[elms];
				}
				grp.addResource(rd);
				
			}
			lResourses.addValueForKey(grp, elm.id);
		}
		
		
		//Log.info(toDump(), ID);
	}
	// will recursivily used to get all resources and appended resources
	public static function getResourcesArray(sGroup:String) : Array {
		if(sGroup == undefined) {
			sGroup = "course";
		}
		var resourceArray:Array = new Array();
		var rg:ResourceGroup = lResourses.getValueForKey(sGroup);
		if(rg == undefined) {
			return resourceArray;
		}
		if((rg.getAppend() != undefined) && (rg.getAppend() != "") && (rg.getAppend() != sGroup)) {
			resourceArray = getResourcesArray(rg.getAppend());
		}
		if(resourceArray.length > 0) {
			return resourceArray.concat(rg.getAllResourses());
		}
		return rg.getAllResourses();
	}
	public static function hasResourceGroup(sGroup:String) {
		return (lResourses.getValueForKey(sGroup) != undefined);
	}
	public static function getResource(sGroup:String, n:Number) : ResourceData {
		if(sGroup == undefined) {
			sGroup = "course";
		}
		var rg:ResourceGroup = lResourses.getValueForKey(sGroup);
		return rg.getResourse(n);
	}
	public static function getResourceById(sGroup:String, sId:String) : ResourceData {
		if(sGroup == undefined) {
			sGroup = "course";
		}
		var rg:ResourceGroup = lResourses.getValueForKey(sGroup);
		return rg.getResourseById(sId);
	}
	public static function toDump() : String {
		var sResources = "\n";
		sResources += "\n---------------  Start Resources Dump  -----------------";
		sResources += "\n\t"+ lResourses.stringify(" : ", "\n\t");
		sResources += "\n---------------   End Resources Dump   -----------------\n\n";
		return sResources;
	}
}