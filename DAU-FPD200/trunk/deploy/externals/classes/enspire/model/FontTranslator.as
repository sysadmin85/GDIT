// xpath
//import com.xfactorstudio.xml.xpath.XPath;
//
//import org.asapframework.util.debug.Log;
//
/* 
XML Example
<font-translations>
	<tag open="&lt;arrow&gt;" close="&lt;/arrow&gt;" font="Symbol">
		<char map="LR" to="«"/>	
		<char map="R" to="®"/>
		<char map="L" to="¬"/>
	</tag>
	
	<tag open="&lt;root&gt;" close="&lt;/root&gt;" font="" prefix="√" suffix=""/>
</font-translations>


*/
class enspire.model.FontTranslator{

	private var aTranslations:Array;
	
	function FontTranslator(xml:XML) {
		if(xml == undefined) {
			//Log.error("No XML defined", this.toString())
		}
		// put nodes into arrays
		this.aTranslations = XPath.selectNodes(xml.firstChild, "tag");
	}


	/**
	* apply the translation to the string
	*
	* @access public
	* @param s String
	* @return String
	*/
	public function applyTo(s:String) : String {
		
		var sParsed = s;
		
		for(var i=0; i<this.aTranslations.length; i++)  {
			sParsed = this.parse(sParsed, this.aTranslations[i]);
		}
		// only log this if we actually did some thing
		if(sParsed != s) {
			//Log.status("FontTranslated: "+s+" / "+ sParsed, this.toString());
		}
		return sParsed;
	
	}

	/**
	* Recursively parse the string according to translation XML
	*
	* @access private
	* @param s String
	* @param xmlTranslation XMLNode
	* @return String
	*/
	private function parse(s:String, oTranslation:XMLNode) : String {
		// scan the string for a node and run the function recursively on it
		var sParsed = new String();
			
		var sOpen = oTranslation.attributes.open;
		var sClose = oTranslation.attributes.close;
		var sFont = oTranslation.attributes.font;
		var sSize = oTranslation.attributes.size != undefined ? ("size=\"" + oTranslation.attributes.size + "\"") : "";
		
		var sFontOpen = sFont != undefined && sFont != "" ? "<font face=\"" + sFont + "\" " + sSize + ">" : "";
		var sFontClose = sFont != undefined && sFont != "" ? "</font>" : "";
		
		
		var sPrefix = oTranslation.attributes.prefix != undefined ? oTranslation.attributes.prefix : "";
		var sSuffix = oTranslation.attributes.suffix != undefined ? oTranslation.attributes.suffix : "";
		
		// Infinite loop occurs if prefix or suffix is the same as the tag you're replacing.
		// ex:  replacign <b> with <font face="My Boldable Font"><b>Bold Text</b></font> will cause endless looping.
		var sPrefixStandIn = (sPrefix != "") ? "{{prefix}}" : "";
		var sSuffixStandIn = (sSuffix != "") ? "{{suffix}}" : "";
		
		var nStart = s.indexOf(sOpen);
		
		// start looking for the close tag right after the open tag using
		// the start index of indexOf
		var nEnd = s.indexOf(sClose, (nStart + sOpen.length));
		
		if(nStart != -1 && nEnd != -1)
		{
			/**
			* Sorry this is a mess of procedures. Here's what's goin' on:
			* - Grab the first part of the string up to the open tag
			* - Add the prefix
			* - Add the font wrapper
			* - Try to map any mapped characters in context of the tag.  Note:  nested tags will have their contents mapped as well.  Oh well.
			* - Add suffix
			* - Close the font wrapper
			* - append the rest of the string
			*/
			sParsed = this.parse(s.slice(0, nStart) + sFontOpen + sPrefixStandIn + this.mapChars(s.slice((nStart + sOpen.length), nEnd), oTranslation.childNodes) + sSuffixStandIn + sFontClose + s.slice((nEnd + sClose.length), (s.length)), oTranslation);
		} else {
			sParsed = s;
		}
		
		
		// turn the prefix and suffix placeholders back into what they should be
		sParsed = sParsed.split(sPrefixStandIn).join(sPrefix);
		sParsed = sParsed.split(sSuffixStandIn).join(sSuffix);
	
		
		return sParsed;
	}

	/**
	* scan through characters and attempt to match to a map node
	*
	* @access private
	* @param s String
	* @param aMaps Array
	* @return String
	*/
	private function mapChars(s:String, aMaps:Array) :String {
		// converts a character to another by following the array of XML map nodes
		var sMapped = s;
		if(aMaps.length == 0){
			// nothing to do
			return s;
		}
		for(var j=0; j<aMaps.length; j++){
			
			var sFind = aMaps[j].attributes.map;
			var sReplace = aMaps[j].attributes.to;
			
			if(sMapped.indexOf(sFind) != -1){
				sMapped = sMapped.split(sFind).join(sReplace);
			}
		}

		return sMapped;
	}
	public function toString() : String {
		return "enspire.model.FontTranslator";
	}
}