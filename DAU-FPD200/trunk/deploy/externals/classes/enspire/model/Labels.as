import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
// xpath
import com.xfactorstudio.xml.xpath.XPath;
//
class enspire.model.Labels {
	private static var oLabels:KeyValueList = new KeyValueList(); 
	
	public static function parseLabels(xml:XML) {
		var theXML:XML = XML(xml);
		var lbs = XPath.selectNodes(theXML.firstChild, "label");
		for(var i:Number = 0; i < lbs.length; i++) {
			var sId = lbs[i].attributes.id;
			var sVal = lbs[i].firstChild.nodeValue;
			addLabel(sId, sVal);
		}
		//Log.info(toString(), "enspire.model.Labels");
	}
	
	public static function addLabel(sId:String, sValue:String) {
		if((sId == undefined) || (sId == "")) {
			//Log.error("no name given for addLabel()", "cigna.data.Labels");
			return;
		}
		if((sValue == undefined) || (sValue == "")) {
			//Log.error("no value given for addLabel()", "cigna.data.Labels");
			return;
		}
		oLabels.addValueForKey(sValue, sId);
		////Log.info("Label added " + sId + " : " +  sValue, "cigna.data.Labels");
	}
	public static function getLabel(sId:String) {
		var my_label = oLabels.getValueForKey(sId);

		////Log.debug("GET Label " +  sId + ":" +  my_label, "cigna.data.Labels");
		return my_label ;
	}
	public static function toString() {
		var sLabels = "";
		sLabels += "\n\n--------------- Labels Dump ------------------\n\n\t";
		for( var name in oLabels ){ 
			sLabels += oLabels.stringify(": ", "\n\t");
		}
		sLabels += ("\n\n------------- end Labels Dump ---------------\n\n");
		return sLabels;
	}
	
}