class enspire.utils.UrlUtils{
	// 
	public static function parseUrlParams(url)  {
		url = unescape(url);
		var urlParamIdx = url.indexOf("?");
		var params = {};
		if (urlParamIdx != -1) {
			var urlParamStr = url.slice(urlParamIdx+1);   // pull out everything after the '?'
			var paramArr = urlParamStr.split("&");        // split the params into an array of name/value pairs
			for (var i=0; i<paramArr.length; i++) {
				var pair = paramArr[i].split("=");        // split each pair into name and value
				var name = pair[0];
				var value = pair[1];
				params[name] = value;                     // add name/value to the hash
			}
		}
		return params;
	}
	public static function stripUrlOfQueryString(sUrl:String) {
		var temp = (sUrl.lastIndexOf("?") == -1) ? sUrl : sUrl.substring(0, sUrl.lastIndexOf("?"));
		// swf's dropped onto an IE window have '\' as their file separator, so change all those out for '/'
		while(temp.indexOf("\\")!=-1) {
			var idx = temp.indexOf("\\");
			temp = temp.substring(0, idx) + "/" + temp.substring(idx+1);
		}
		return temp;
	}
	public static function getLocation(sUrl:String) {
		return (sUrl.indexOf("http://") == -1 && sUrl.indexOf("https://") == -1) ? "local" : "remote";
	}
}