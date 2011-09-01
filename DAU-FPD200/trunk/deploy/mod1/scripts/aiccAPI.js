// Utilities

String.prototype.trim = function()
{
   var strText = this;
   return strText.replace(/^\s*|\s*$/g,"");
}

// Replaces all instances of the given substring.
String.prototype.replaceAll = function( 
	strTarget, // The substring you want to replace
	strSubString // The string you want to replace in.
	){
	var strText = this;
	var intIndexOfMatch = strText.indexOf( strTarget );
	 
	// Keep looping while an instance of the target string
	// still exists in the string.
	while (intIndexOfMatch != -1){
		// Relace out the current instance.
		strText = strText.replace( strTarget, strSubString )
		 
		// Get the index of any next matching substring.
		intIndexOfMatch = strText.indexOf( strTarget );
	}
	 
	// Return the updated string with ALL the target strings
	// replaced out with the new substring.
	return( strText );
}

// Some LMS's (like GeoLearning) take the AiccData and
// put it into an XML document without checking to see
// if the result is valid XML.  Some (like GeoLearning)
// even unencode your encoded stuff before they do that,
// so using standard encoding isn't enough.  These methods
// will remove offending characters and make it so that the 
// suspend data string is sent and recovered exactly as it
// is sent, and it won't cause errors on the LMS.
String.prototype.lmsEncode = function()
{
   var strText = this;
   strText = strText.replaceAll("=",":-:");
   strText = strText.replaceAll("&", ":amp:");
   strText = strText.replaceAll("%", ":perc:");
   
   return ( strText );
}

String.prototype.lmsDecode = function()
{
	var strText = this;
	strText = strText.replaceAll(":-:","=");
   	strText = strText.replaceAll(":amp:","&");
   	strText = strText.replaceAll(":perc:","%");
   
   return ( strText );
}

// The surrogate API object
var API = new Object();
API.LMSInitialize = LMSInitialize;
API.LMSSetValue = LMSSetValue;
API.LMSGetValue = LMSGetValue;
API.LMSCommit = LMSCommit;
API.LMSFinish = LMSFinish;
API.LMSGetLastError = LMSGetLastError;

var useAICCRelayService = false;


// AICC variables
var cmi_core_session_time = new String("00:00:00");
var cmi_core_lesson_status = new String("");
var cmi_suspend_data = new String("");
var cmi_core_student_id = new String("");
var cmi_core_student_name = new String("");
var cmi_core_score_max = new String("");
var cmi_core_score_min = new String("");
var cmi_core_score_raw = new String("");
var cmi_student_data_mastery_score = new String("");
var cmi_core_lesson_location = new String("");


var urlAttributes = new String(document.location.search);
var urlParameters = urlAttributes.split("?");
var aicc_url = "";
var aicc_sid = "";
if (urlParameters.length > 1){
	urlAttributes = urlParameters[1];
	urlParameters = urlAttributes.split("&");

	for (var i=0; i < urlParameters.length; i++){
		
		var param = urlParameters[i].split("=");

		if (param[0].toLowerCase() == "aicc_url"){
			aicc_url = unescape(param[1]);
		}
		
		else if (param[0].toLowerCase() == "aicc_sid"){
			aicc_sid = unescape(param[1]);
		}
		// If there are more custom parameters in the URL, include them here...
	}
}

var launchUrl = new String(document.location.href);
launchUrl = launchUrl.toLowerCase();
var aiccUrl = new String(aicc_url);
aiccUrl = aiccUrl.toLowerCase();


if ((aiccUrl.indexOf("http://") > -1) || (aiccUrl.indexOf("https://") > -1)){
	var position = 0;

	launchUrl = launchUrl.replace("http://", "");
	launchUrl = launchUrl.replace("https://", "");
	position = launchUrl.indexOf("/");	
	
	launchUrl = launchUrl.slice(0, position);
	

	
	aiccUrl = aiccUrl.replace("http://", "");
	aiccUrl = aiccUrl.replace("https://", "");
	position = aiccUrl.indexOf("/");	
	aiccUrl = aiccUrl.slice(0, position);
	
	// remove ports
	position = launchUrl.indexOf(":");
	if (position > -1){
		launchUrl = launchUrl.slice(0, position);
	}
	position = aiccUrl.indexOf(":");	
	if (position > -1){
		aiccUrl = aiccUrl.slice(0, position);
	}
	
	
	// If the domains are the same, we can use a direct AJAX request;
	// if not, we have to use a relay in LMS's that will support it
	if (aiccUrl + "" == launchUrl + ""){
		useAICCRelayService = false;
		launchUrl = new String(document.location.href);
		launchUrl = launchUrl.toLowerCase();
		aiccUrl = new String(aicc_url);
		aiccUrl = aiccUrl.toLowerCase();

		if (aiccUrl.indexOf("http://") > -1){
			if (launchUrl.indexOf("https://") > -1){
				aicc_url = new String(aicc_url);
				aicc_url = aicc_url.replace("http://", "https://") + "";
			}
		}
		else if (aiccUrl.indexOf("https://") > -1){
			if (launchUrl.indexOf("http://") > -1){
				aicc_url = new String(aicc_url);
				aicc_url = aicc_url.replace("https://", "http://") + "";
			}
		}
	}
	else{
		useAICCRelayService = true;
	}
}



// Create the HTTP request object and return it
function getXMLHttpRequestObject()
{
	// from http://en.wikipedia.org/wiki/XMLHttpRequest
	if( typeof XMLHttpRequest == "undefined" )
  		XMLHttpRequest = function() {
    try { return new ActiveXObject("Msxml2.XMLHTTP.6.0") } catch(e) {}
    try { return new ActiveXObject("Msxml2.XMLHTTP.3.0") } catch(e) {}
    try { return new ActiveXObject("Msxml2.XMLHTTP") }     catch(e) {}
    try { return new ActiveXObject("Microsoft.XMLHTTP") }  catch(e) {}
    	throw new Error( "This browser does not support XMLHttpRequest or XMLHTTP." )
  	};
 
	var request = new XMLHttpRequest(); // No conditionals necessary.
	return request;

}








// Function to retrieve the error code and message from the LMS
function GetAICCErrorMessage(core){
	var offset = 0;
	var sError = new String("");
	var aiccCoreUpper = core.toUpperCase();

	if (core.length > 0)
	{
		nOffset = aiccCoreUpper.indexOf("ERROR=");
		if (nOffset != -1)
		{
			nDirStart = nOffset + 5;

			nDirEnd = core.indexOf("\r\n", nDirStart);
			if (nDirEnd == -1)
				nDirEnd = core.indexOf("\r", nDirStart);
				if (nDirEnd == -1)
				nDirEnd = core.indexOf("\n", nDirStart);
			if (nDirEnd != -1)
			{
				sError = "Error Number: " + core.substring(nDirStart + 1, nDirEnd);
			}
		}

		nOffset = aiccCoreUpper.indexOf("ERROR_TEXT=");
		if (nOffset != -1)
		{
			nDirStart = nOffset + 10;

			nDirEnd = core.indexOf("\r\n", nDirStart + 1);
						if (nDirEnd == -1)
				nDirEnd = core.indexOf("\r", nDirStart + 1);
				if (nDirEnd == -1)
				nDirEnd = core.indexOf("\n", nDirStart + 1);

			if (nDirEnd != -1)
			{
				sError = sError + "\nError Text: " + core.substring(nDirStart + 1, nDirEnd);
			}
		}
	}

	return sError;
}

// Function to check to see the if there any errors in the parameters
function CheckAICCError(aiccParams)
{
	var aiccParamsUpper = "";
	var offset = 0;
	var core = new String("");

	if ((aiccParams + "" == "") || (aiccParams + "" == "undefined")){
		return(true);
	}
	else{
		aiccParamsUpper = aiccParams.toUpperCase();

		if (aiccParams.length > 0)
		{
			nOffset = aiccParamsUpper.indexOf("[CORE]");
			if (nOffset != -1)
			{
				nDirStart = nOffset + 6;

				nDirEnd = aiccParamsUpper.indexOf("[CORE_LESSON]", nDirStart + 1);

				if (nDirEnd == -1)
				{
					core = "";
					return(true);
				}
			}
			else{
				nOffset = aiccParamsUpper.indexOf("ERROR");
				if (nOffset != -1)
				{
					errorMessage = GetAICCErrorMessage(aiccParams);

					if (errorMessage + "" !== ""){
						return(true);
					}
					else{
						return(true);
					}
				}
				else{
					return(true);
				}
			}
		}
	}
	return(false);
}

function GetAICCCore(aiccData){
	var aiccDataUpper = new String(aiccData);
	aiccDataUpper = aiccDataUpper.toUpperCase();
	var core = "";
	var nOffset = 0;
	var nStart = 0;
	var nEnd = 0;
	
	nOffset = aiccDataUpper.indexOf("[CORE]");
	if (nOffset != -1)
	{
		nStart = nOffset + 6;

		nEnd = aiccDataUpper.indexOf("\r\n[", nStart);
			
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\r[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\n[", nStart);
		if (nEnd == -1){
			nEnd = aiccDataUpper.length;
		}

		core = aiccData.substring(nStart + 1, nEnd);
	}
	return (core);	
}

function GetAICCCoreLesson(aiccData){
	var aiccDataUpper = new String(aiccData);
	aiccDataUpper = aiccDataUpper.toUpperCase();
	var coreLesson = "";
	var nOffset = 0;
	var nStart = 0;
	var nEnd = 0;
	
	nOffset = aiccDataUpper.indexOf("[CORE_LESSON]");
	if (nOffset != -1)
	{
		nStart = nOffset + 13;

		nEnd = aiccDataUpper.indexOf("\r\n[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\r[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\n[", nStart);

		if (nEnd == -1){
			nEnd = aiccDataUpper.length;
		}

		coreLesson = aiccData.substring(nStart + 1, nEnd);
		
		// Get rid of any leading return characters
		while ((coreLesson.substring(0, 1) == "\n") || (coreLesson.substring(0, 1) == "\r")){
			coreLesson = coreLesson.substring(1, coreLesson.length);
		}
		
		if ((coreLesson == "\r\n") || (coreLesson == "\n")){
			coreLesson = "";
		}
	}
	return (coreLesson);	
}

function GetAICCStudentData(aiccData){
	var aiccDataUpper = new String(aiccData);
	aiccDataUpper = aiccDataUpper.toUpperCase();
	var sAICCStudentData = "";
	var nOffset = 0;
	var nStart = 0;
	var nEnd = 0;
	
	nOffset = aiccDataUpper.indexOf("[STUDENT_DATA]");
	if (nOffset != -1)
	{
		nStart = nOffset + 13;

		nEnd = aiccDataUpper.indexOf("\r\n[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\r[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\n[", nStart);

		if (nEnd == -1){
			nEnd = aiccDataUpper.length;
		}

		sAICCStudentData = aiccData.substring(nStart + 1, nEnd);
	}
	return (sAICCStudentData);	
}

function GetAICCCoreVendor(aiccData){
	var aiccDataUpper = new String(aiccData);
	aiccDataUpper = aiccDataUpper.toUpperCase();
	var sAICCVendor = "";
	var nOffset = 0;
	var nStart = 0;
	var nEnd = 0;
	
	nOffset = aiccDataUpper.indexOf("[CORE_VENDOR]");
	if (nOffset != -1)
	{
		nStart = nOffset + 13;

		nEnd = aiccDataUpper.indexOf("\r\n[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\r[", nStart);
		if (nEnd == -1)
			nEnd = aiccDataUpper.indexOf("\n[", nStart);

		if (nEnd == -1){
			nEnd = aiccDataUpper.length;
		}

		sAICCVendor = aiccData.substring(nStart + 1, nEnd);
		
		if ((sAICCVendor == "\r\n") || (sAICCVendor == "\n")){
			sAICCVendor = "";
		}
	}
	return (sAICCVendor);	
}

var aicc_error = false;
function CheckAICCResponseForError(aiccData){
	if ((aiccData.indexOf("error=0") == -1) && (!aicc_error)){
		aicc_error = true;
	}
}

function removeEqualsSpaces(theString)
{
	return(theString.replaceAll(" =", "=").replaceAll("= ", "=").replaceAll("  =", "=").replaceAll("=  ", "="));
}

function ExecuteAICCCommand(aicc_url, aicc_sid, command, aicc_data){
	var httpRequest = getXMLHttpRequestObject();
	var theParams = "command=" + command + "&version=" + escape("3.0") + "&session_id=" + escape(aicc_sid) + "&aicc_data="
	var aiccData = "";
	
	//alert("Execute Command: " + aicc_url + "?" + theParams + aicc_data);
	
	// If our domains are not the same we need to use the AICC server-side relay service
	if (!useAICCRelayService){
		theParams = theParams + escape(aicc_data);
		
		try{
			httpRequest.open("POST", aicc_url, false);
			httpRequest.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			httpRequest.send(theParams);
			
			aiccData = removeEqualsSpaces(httpRequest.responseText);
			
		}
		catch(e){
			//alert("There was a problem communicating with the LMS.\n\nPlease exit the training, check your internet connection and try again.");
		}
		//alert(theParams);
	}
	else{
		//alert("Other");
		// This means we have to also pass the true aicc_url and escape the data
		theParams = "command=" + command + "&version=" + escape("3.0") + "&session_id=" + escape(aicc_sid) + "&aicc_data="
		theParams = theParams + escape(aicc_data) + "&aicc_url=" + escape(aicc_url);
		try{
			var relayLocation = new String(document.location.href);
			relayLocation = relayLocation.toLowerCase();
			relayLocation = relayLocation.replace("http://", "");
			relayLocation = relayLocation.substring(relayLocation.indexOf("/"), relayLocation.indexOf("aicc_launch.html"));
			httpRequest.open("POST", relayLocation + "aicc_redirect.asp", false);
			httpRequest.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			httpRequest.send(theParams);
			
			aiccData = removeEqualsSpaces(httpRequest.responseText);
		}
		catch(e){
			//alert("There was a problem communicating with the LMS.\n\nPlease exit the training, check your internet connection and try again.");
		}
		//alert("Other Execute Command: " + httpRequest.responseText);
	}
	
	httpRequest = null;
	
	CheckAICCResponseForError(aiccData);
	
	//alert("Command: " + command + "\naiccData: " + aiccData);
	
	return(aiccData);
}

function PutAICCData()
{
	var aiccLLocString = new String(unescape(cmi_core_lesson_location));
	aiccLLocString = aiccLLocString.lmsEncode(); // replace all =, &, % etc
	
	cmi_core_lesson_location = aiccLLocString + "";

	var aiccData = "[Core]\r\n";
	aiccData = aiccData + "Lesson_Location=" + cmi_suspend_data.lmsEncode() + "\r\n";
	aiccData = aiccData + "Score=" + cmi_core_score_raw + "," + cmi_core_score_max + "," + cmi_core_score_min + "\r\n";
	aiccData = aiccData + "Lesson_Status=" + cmi_core_lesson_status + "\r\n";
	aiccData = aiccData + "Time=" + cmi_core_session_time + "\r\n";
	aiccData = aiccData + "[Core_Lesson]\r\n";
	aiccData = aiccData + cmi_suspend_data.lmsEncode() + "\r\n";
	
	aiccData = ExecuteAICCCommand(aicc_url, aicc_sid, "PutParam", aiccData);
	
	//alert("PUT : " + aiccData);
	
	if (aiccData + "" == ""){
		return "false";
	}
	else{
		return "true";
	}
}

// Function to retrive a core keyword
function getAiccKeyword(core, keyword, defaultVal){
	var offset = 0;
	var sSearch = new String(defaultVal);
	var aiccCoreUpper = new String(core);
	keyword = keyword.toUpperCase();
	aiccCoreUpper = aiccCoreUpper.toUpperCase();
	//alert("here is core : " + core);
	//alert("looking for " + keyword);

	if (core.length > 0)
	{
		var nOffset = aiccCoreUpper.indexOf(keyword + "=");
		//alert("nOffset is " + nOffset);
		
		if (nOffset != -1) //found keyword=
		{
			var nDirStart = nOffset + keyword.length;  // loc of = after keyword
			//alert("nDirStart = " + nDirStart);

			var nDirEnd = aiccCoreUpper.indexOf("\r\n", nDirStart);
			if (nDirEnd == -1)
				nDirEnd = aiccCoreUpper.indexOf("\r", nDirStart);
			if (nDirEnd == -1)
				nDirEnd = aiccCoreUpper.indexOf("\n", nDirStart);
				
			//alert("nDirEnd = " + nDirEnd);


		 if (nDirEnd != -1)
			{
				sSearch = core.substring(nDirStart + 1, nDirEnd).trim();
				//alert("found nDirEnd; sSearch is " + sSearch);
			}
			else{
				sSearch = core.substring(nDirStart + 1, core.length).trim();
				//alert(" no found nDirEnd; sSearch is " + sSearch);
			}
		}
	}

	if (sSearch.trim() + "" == ""){
		sSearch = defaultVal;
	}

	return sSearch;
}

function GetAICCData()
{
	var aiccData = ExecuteAICCCommand(aicc_url, aicc_sid, "GetParam", "");
	
	//alert("GET : " + aiccData);
	if (aiccData + "" == ""){
		return "false";
	}
	
	var aiccCore = new String(GetAICCCore(aiccData));
	var aiccCoreLesson = new String(GetAICCCoreLesson(aiccData));
	var aiccCoreVendor = new String(GetAICCCoreVendor(aiccData));
	var aiccStudentData = new String(GetAICCStudentData(aiccData));
	cmi_core_score_raw = new String(getAiccKeyword(aiccCore, "SCORE", "0"));
	scoresArray = cmi_core_score_raw.split(",");

	if (scoresArray.length > 2){
		cmi_core_score_raw = scoresArray[0];
		cmi_core_score_max = scoresArray[1];
		cmi_core_score_min = scoresArray[2];
	}
	else if (scoresArray.length > 1){
		cmi_core_score_raw = scoresArray[0];
		cmi_core_score_max = scoresArray[1];
		cmi_core_score_min = 0;
	}
	else{
		cmi_core_score_max = "100";
		cmi_core_score_min = "0";
	}
	
	
	cmi_core_lesson_status = getAiccKeyword(aiccCore, "LESSON_STATUS", "incomplete");
	
	if (cmi_core_lesson_status == "Not Attempted") {
						cmi_core_lesson_status = "Incomplete";						
	}
	
	cmi_core_lesson_location = new String(getAiccKeyword(aiccCore, "LESSON_LOCATION", ""));


	var aiccLLocString = new String(unescape(cmi_core_lesson_location));
	aiccLLocString = aiccLLocString.lmsDecode();

	cmi_core_lesson_location = aiccLLocString + "";

	cmi_student_data_mastery_score = getAiccKeyword(aiccStudentData, "MASTERY_SCORE", "70");
	cmi_core_student_id = getAiccKeyword(aiccCore, "STUDENT_ID", "");
	cmi_core_student_name = getAiccKeyword(aiccCore, "STUDENT_NAME", "");
	cmi_suspend_data = cmi_core_lesson_location;

	
	return "true";
}



function scormToAicc(theTime){
	var newTime = new String(theTime);
	
	if (newTime.indexOf(":") == 4){
		newTime = newTime.substring(2, newTime.length)
	}
	
	if (newTime.indexOf(".") != -1){
		newTime = newTime.substring(0, newTime.length - 3);
	}
	
	return(newTime);
}

function LMSInitialize()
{
	//alert("LMSInitialize");
	return "true";
}

function LMSGetValue(theElement)
{
	//alert("Get Value of element: " + theElement);
	switch (theElement){
		case "cmi.core.lesson_location":
			//alert("returning: " + cmi_core_lesson_location);
			return cmi_core_lesson_location;
		break;
		
		case "cmi.suspend_data":
			//alert("returning: " + cmi_suspend_data);
			return cmi_suspend_data;
		break;
		
		case "cmi.core.lesson_status":
			//alert("returning lesson_status : " + cmi_core_lesson_status);
			return cmi_core_lesson_status;
		break;
		
		case "cmi.core.student_name":
			//alert("returning student_name");
			return cmi_core_student_name;
		break;
		
		case "cmi.core.student_id":
			//alert("returning student_id");
			return cmi_core_student_id;
		break;
		
		case "cmi.core.score.raw":
			//alert("returning score.raw");
			return cmi_core_score_raw;
		break;
		
		case "cmi.core.score.max":
			//alert("returning score.max");
			return cmi_core_score_max;
		break;
		
		case "cmi.core.score.min":
			//alert("returning score.min");
			return cmi_core_score_min;
		break;
		
		case "cmi.student_data.mastery_score":
			//alert("returning score.raw");
			return cmi_student_data_mastery_score;
		break;
		
		default:
			return "true";
		break;
	}
}

function LMSSetValue(theElement, theValue)
{
	//alert("in aiccAPI: LMSSetValue of element: " + theElement + " value: " + theValue);
	switch (theElement){
		case "cmi.core.lesson_location":
			//alert("Setting lesson_location" + " value: " + theValue);
			cmi_core_lesson_location = theValue.lmsDecode();
		break;
		
		case "cmi.suspend_data":
			//alert("Setting suspend_data" + " value: " + theValue);
			cmi_suspend_data = theValue.lmsDecode();
		break;
		
		case "cmi.core.session_time":
			//alert("Setting session_time: " + theValue);
			cmi_core_session_time = scormToAicc(theValue);
		break;
		
		case "cmi.core.lesson_status":
			//alert("Setting lesson_status" + " value: " + theValue);
			cmi_core_lesson_status = theValue;
		break;
		
		case "cmi.core.score.raw":
			//alert("Setting lesson_location" + " value: " + theValue);
			cmi_core_score_raw = theValue;
		break;
		
		case "cmi.core.score.max":
			//alert("returning score.max" + " value: " + theValue);
			cmi_core_score_max = theValue;
		break;
		
		case "cmi.core.score.min":
			//alert("returning score.min" + " value: " + theValue);
			cmi_core_score_min = theValue;
		break;
		
		default:
			//alert("Default");
			return "true";
		break;
	}
	
	return "true";
}

function LMSCommit()
{
	//alert("LMSCommit called");
	PutAICCData();
	
	return "true";
}

function LMSFinish()
{
	//alert("LMSFinish called");
	PutAICCData();
	aiccData = ExecuteAICCCommand(aicc_url, aicc_sid, "ExitAU", "");
	
	return "true";
}

function LMSGetLastError()
{
	return "";
}




GetAICCData();
