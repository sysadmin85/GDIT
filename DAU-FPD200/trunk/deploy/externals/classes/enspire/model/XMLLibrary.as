// this is a library to provide one place for xml in a application
import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
//
class enspire.model.XMLLibrary {
	var lXmls:KeyValueList;
	function XMLLibrary() {
		this.lXmls = new KeyValueList();
	}
	// add an xml to the library
	function addXml(sName:String, xml:XML) : Void{
		this.lXmls.addValueForKey(xml, sName);
		//Log.info("XML: "+sName+" added", this.toString());
	}
	// create and empty xml and return it
	function createXml(sName:String) : XML {
		var xml = new XML();
		xml.ignoreWhite = true;
		this.addXml(sName, xml);
		return xml;
	}
	// get an xml use bRemove to remove form memory if you do not need it again
	function getXml(sName:String, bRemove:Boolean) : XML  {
		var xml:XML =  this.lXmls.getValueForKey(sName);
		if(bRemove) {
			this.lXmls.removeValueForKey(sName);
		}
		////Log.info("Returning xml "+sName+":\n"+xml, this.toString());
		return xml;
	}
	function hasXml(sName:String) : Boolean  {
		return (this.lXmls.getValueForKey(sName) != undefined);
	}
	// removes an xml from the libary
	function removeXml(sName:String) : Void {
		this.lXmls.removeValueForKey(sName);
	}
	public function getXmlsList() : Array{
		var xmls = this.lXmls.getArray();
		var a = new Array();
		for(var i=0; i < xmls.length; i++) {
			a.push(xmls[i].key);
		}
		return a;
	}
	// dumps entire contents of library into string this may be processor intensive
	function dump() : String {
		var sFormat:String = "\nxml: %1\n--------- xml start ---------\n%2\n---------  xml end  ---------";
		var sDelim:String = "\n"
		return this.toString() + this.lXmls.stringifyWithFormattedString(sFormat, sDelim);
	}
	// simple //trace
	function toString() : String{
		return "enspire.model.XMLLibrary";
	}
}