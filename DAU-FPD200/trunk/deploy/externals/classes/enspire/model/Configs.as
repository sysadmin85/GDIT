// asap classes
import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
import org.asapframework.util.BooleanUtils;
import org.asapframework.util.StringUtils;
import org.asapframework.util.StringUtilsTrim;
import org.asapframework.util.ObjectUtils;
// xpath
import com.xfactorstudio.xml.xpath.XPath;
//
class enspire.model.Configs{
	private static var CONFIG_ID:String = "Configs";
	private static var lConfig:KeyValueList = new KeyValueList();
	private static var bConfigs:Boolean = false;
	//
	public static function parseConfigs(xml:XML) : Void {
		// make sure we do not overwrite configs
		////Log.debug(xml.toString(), CONFIG_ID);
		if(bConfigs) {
			//Log.error("Already added configs", CONFIG_ID);
			return;
		}
		//Log.status("Parse configs start", CONFIG_ID);
		var theXML:XML = XML(xml);
		var configs = XPath.selectNodes(theXML.firstChild, "config");
		////Log.debug("# of configs "+configs.length, CONFIG_ID);
		// get single configs
		for(var i:Number = 0; i < configs.length; i++) {
			var elm = configs[i].attributes;
			var bAddedTwice:Boolean = checkConfigExists(elm.name);
			if(bAddedTwice) {
				//Log.error( prop.name + " added: twice" ,  CONFIG_ID);
			}
			var val = getTypedConfig(elm.value)
			addConfig( elm.name , val );
		}
		// get config profiles
		var profiles = XPath.selectNodes(theXML.firstChild, "profile");
		////Log.debug("# of profiles "+profiles.length, CONFIG_ID);
		for(var i:Number = 0; i < profiles.length; i++) {
			var prop = profiles[i].attributes;
			var bAddedTwice:Boolean = checkConfigExists(prop.name);
			if(bAddedTwice) {
				//Log.error( prop.name + " added: twice" ,  CONFIG_ID);
			}
			var lGroup = new KeyValueList();
			var configProps = XPath.selectNodes(profiles[i], "config");
			if(configProps.length > 0) {
				for(var j:Number = 0; j < configProps.length; j++) {
					var elm = configProps[j].attributes;
					var val = getTypedConfig(elm.value)
					if((elm.name != "") && (elm.name != undefined) || (val != undefined)) {
						lGroup.setValueForKey( val , elm.name);
						
					}else{
						//Log.warn("Empty or undefined Config in profile "+prop.name, CONFIG_ID);
					}
				}
				addConfig( prop.name , lGroup );
			}else{
				//Log.error("Empty or profile", CONFIG_ID);
			}
		}
		bConfigs = true;
		//
	}
	public static function addConfig(sName:String, sValue) : Void {
		if((sName == undefined) || (sName == "")) {
			//Log.error("No Name ", CONFIG_ID);
			return;
		}
		if(sValue == undefined) {
			//Log.error("Empty Config Object", CONFIG_ID);
			return;
		}
		// make sure we are not trying to set a config that is allread set
		if(checkConfigExists(sName)) {
			//Log.error(sName+" Config Already Exists", CONFIG_ID);
			return;
		}
		lConfig.addValueForKey(sValue, sName);
	}
	private static function getTypedConfig(sValue:String) {
		if((sValue == "true") || (sValue == "false")) {
			return  (sValue == "true");
		}else if(!isNaN(parseInt(sValue.toString()))) {
			return  parseInt(sValue.toString());
		}else if((sValue.charAt(0) == "[") && (sValue.indexOf(",") != -1)) {
			
			sValue = StringUtils.remove(sValue, "[");
			sValue = StringUtils.remove(sValue, "]");
			var aVals = new Array();
			var aSubVals = new Array();
			aVals = sValue.toString().split(",");
			for(var i:Number = 0; i < aVals.length; i++) {
				
				aSubVals[i] = getTypedConfig(aVals[i]);
				
			}
			return aSubVals;
		}else {
			
			return sValue.toString();
			
		}
	}
	public static function getConfig(sName:String) {
		var config = lConfig.getValueForKey(sName);
		if(config instanceof KeyValueList) {
			return getProfile(sName);
		}
		return  config
	}
	public static function getProfile(sName:String) : Object {
		var profile = lConfig.getValueForKey(sName);
		var arr = profile.getArray();
		var o = new Object();
		for( var i:Number = 0; i < arr.length; i++)  {
			var key = arr[i].key;
			////trace("Adding prop: "+key+" value: "+arr[i].value);
			o[key] = arr[i].value
		}
		return  o;
	}
	public static function checkConfigExists(sName:String) : Boolean {
		return (!(lConfig.getValueForKey(sName) == undefined));
	}
	public static function toDump() : String {
		var sConfigs = "";
		sConfigs += "\n---------------  Start Configs Dump  -----------------";
		sConfigs += "\n\t"+ lConfig.stringify(" : ", "\n\t");
		sConfigs += "\n---------------   End Configs Dump   -----------------\n";
		
		return sConfigs;
		
	}
	public static function toString() : String {
		return CONFIG_ID;
	}	
}