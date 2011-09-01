import org.asapframework.util.StringUtilsTrim
class enspire.utils.StringUtils{
	public static function getNumericChars(sText:String, bPreserveType:Boolean) {
		var sFiltered:String = "";
		for(var i:Number = 0; i < sText.length; i++){
			if(!isNaN(sText.charAt(i)))
			{
				sFiltered += sText.charAt(i);
			}
		}
		return (bPreserveType) ? sFiltered : parseInt(sFiltered);
	}
	public static function replace(s:String, sReplace:String, replaceWith:String){
	 var sb = new String();
	 var found = false;
	 for (var i = 0; i < s.length; i++)
		{
		 if(s.charAt(i) == sReplace.charAt(0))
			{   
			 found = true;
				for(var j = 0; j < sReplace.length; j++)
				{
				 if(!(s.charAt(i + j) == sReplace.charAt(j)))
					{
					 found = false;
						break;
					}
	   }
				if(found)
				{
				 sb += replaceWith;
					i = i + (sReplace.length - 1);
					continue;
				}
	  }
			sb += s.charAt(i);
	 }
		return sb;
	}
	public static function getArrayFromArg(sArg:String, sDelimiter:String)  {
		if(sDelimiter == undefined) {
			sDelimiter =  ",";
		}
		
		var args = sArg.split(sDelimiter);
		////trace("Parsing arg: "+sArg+" found "+args.length);
		var stripedArgs = new Array();
		for(var i:Number = 0; i < args.length; i++) {
			////trace(" arg pre strip: "+args[i]);
			stripedArgs[i] = StringUtilsTrim.trim(args[i]);
			////trace(" arg post strip: "+stripedArgs[i]);
		}
		return stripedArgs;
	}
}