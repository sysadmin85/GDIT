customArgs = {};
customArgs.width = '100%';
customArgs.height = '100%';
customArgs.title = "DAU | Welcome and Introduction";
customArgs.blockWholeScreen = false;
customArgs.bScale = false;

customArgs.iftVisible = true;
customArgs.iftProjectID = -1;
/*
if( screen.width < 1024 || screen.height < 768 )
	alert( 'This course is optimized for 1024x768 screen resolution.  Please adjust screen resolution settings to view this course.' );
*/	
// check browser's minimum requirement

// check for internet explorer
var useragent = navigator.userAgent;
var nMSIE = useragent.indexOf( "MSIE " );	
var nFirefox = useragent.indexOf( "Firefox/" );	
/*if( nMSIE != -1 )
{
	var IEVersion = useragent.substring( nMSIE + 5, useragent.indexOf( ".", nMSIE ) );
	if( IEVersion < 7 )	
		alert( 'Please update to the latest version of Internet Explorer at \nhttp://www.microsoft.com/windows/internet-explorer/' );
}

// check for firefox
if( nFirefox != -1 )
{
	var FFVersion = useragent.substring( nFirefox + 8, useragent.indexOf( ".", nFirefox ) );
	if( FFVersion < 2 )	
		alert( 'Please update to the latest version of Firefox at \nhttp://www.mozilla.com/firefox/' );
}*/



if(customArgs.bScale && typeof screen != "undefined" && customArgs.width!= '100%') {
	if(screen.availHeight < (customArgs.height+30) || screen.availWidth < (customArgs.width+10)) {
		customArgs.width = '100%';
		customArgs.height = '100%';
	}
}

var agt=navigator.userAgent.toLowerCase();
var is_opera = (agt.indexOf("opera") != -1);
var appVer   = navigator.appVersion.toLowerCase();
var is_ie    = ((appVer.indexOf('msie')!=-1) && (!is_opera));
var is_mac   = (agt.indexOf("mac")!=-1);

var is_gecko = (agt.indexOf('gecko')!=-1);



// adjust for scaling on ie when dpi is not default and UseHR registry key is set
// see http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/overview/highdpi.asp
if(is_ie && customArgs.width != "100%" && screen.logicalXDPI != undefined)
{
            customArgs.width = Math.round(customArgs.width * screen.logicalXDPI / screen.deviceXDPI);
            customArgs.height = Math.round(customArgs.height *  screen.logicalYDPI / screen.deviceYDPI);
}


function openAppWindow(url) {
	if(url.indexOf("?") != -1) {
		url = url + "&launched=true";
	}
	else {
		url = url + "?launched=true";
	}
	var features = 'toolbar=no,location=no,status=no,menubar=no,scrollbars=no,left=0,top=0';
	if (is_ie) {
		var width = (customArgs.blockWholeScreen || customArgs.width=="100%") ? (screen.availWidth-14) : customArgs.width;
		var height = (customArgs.blockWholeScreen || customArgs.height=="100%") ? (screen.availHeight-38) : customArgs.height;
		features += ',resizable=yes,width='+width+',height='+height;
	}
	else if(!(is_gecko || is_opera)) {
		// do not allow resizing on netscape < 5 b/c resizing causes the page to reload (including the flash movie)
		var swidth = (customArgs.blockWholeScreen || customArgs.width=="100%") ? ('outerWidth='+screen.availWidth) : ('width='+customArgs.width);
		var sheight = (customArgs.blockWholeScreen || customArgs.height=="100%") ? ('outerHeight='+screen.availHeight) : ('height='+customArgs.height);
		features += ',resizable=no,'+swidth+','+sheight;
	}
	else {
		var swidth = (customArgs.blockWholeScreen || customArgs.width=="100%") ? ('outerWidth='+(is_mac ? (screen.availWidth-30) : screen.availWidth)) : ('width='+customArgs.width);
		var sheight = (customArgs.blockWholeScreen || customArgs.height=="100%") ? ('outerHeight='+(is_mac ? (screen.availHeight-6) : screen.availHeight)) : ('height='+customArgs.height);
		features += ',resizable=yes,'+swidth+','+sheight;
	}
	var w = window.open(url, "_blank", features);
}

