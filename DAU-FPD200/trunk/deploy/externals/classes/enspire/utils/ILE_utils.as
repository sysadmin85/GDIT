/* Class: ILE_utils
	This is a static class to hold some standard functionallity for ILE projects
	
*/
import flash.external.ExternalInterface;
import enspire.core.VersionInfo;
import enspire.model.ILELocation;
import enspire.model.State;
import enspire.model.Configs;
import enspire.core.Server
import enspire.utils.TimeUtils

class enspire.utils.ILE_utils{
	public static function debugCounter(){
		var pre = (Configs.getConfig("sModId") == undefined) ? "" : Configs.getConfig("sModId") + "/";
		return pre + State.sSectionId + "/" + State.sClipId + "/" +  padSegId(State.sSegmentId);;
	}
	public static function padSegId(sId){
		var sSegNum = new Number(sId.substring(1));
		if((sSegNum != NaN) && (sSegNum < 10)) {
			sId = sId.substring(0,1) + "0" + sId.substring(1);
		}
		return sId;
	}
	public static function getCurrentSeg() {
		return Server.getController("clipPlayer").oCurrentSegment;
	}
	public static function getCurrentClip() {
		return Server.getController("clipPlayer").oClipData
	}
	public static function setCurrentSegComplete() {
		Server.model.seg.setComplete();
	}
	public static function getLocationAsString() {
		return State.sSectionId + " " + State.sClipId +" "+ State.sSegmentId;
	}
	public static function isStartOfClip() {
		return (State.nSegment == 0);
	}
	// have some questions about this function 
	public static function getPreloadClips() {
		//
		var aPreloadClips = [];
		for(var h:Number = 0; h < _global.ILE.app.oStructure.aChapter.length; h++) {
			
			for (var i:Number = 0; i < _global.ILE.app.oStructure.aChapter[h].aSection.length; i++) {
				
				for(var j:Number = 0; j< _global.ILE.app.oStructure.aChapter[h].aSection[i].aClip.length; j++) {
					
					if(_global. ILE.app.oStructure.aChapter[h].aSection[i].aClip[j].url != undefined) {	
						// there was an empty clip during testing of this during development
						aPreloadClips.unshift({url: _global.ILE.app.oStructure.aChapter[h].aSection[i].aClip[j].url, userData: aPreloadClips.length + 1, userData2: false});
						// store the absolute order of this clip on the clip data
						_global.ILE.app.oStructure.aChapter[h].aSection[i].aClip[j].nAbsoluteOrder = aPreloadClips.length;
						
						// preload audio
						var aSegments = _global.ILE.app.oStructure.aChapter[h].aSection[i].aClip[j].aSegment;
						var k:Number = ((Configs.getConfig("bTitleSeg")) && (Configs.getConfig("bTitleAudio"))) ? 0 : 1;
						
						for(k; k < aSegments.length; k++){
							
							if(aSegments[k].args.noAudio != "true" || aSegments[k].args.hasAudio == "true") {
								
								var sUrl = "audio/" + _global.ILE.app.oStructure.aChapter[h].aSection[i].id + "_" + _global.ILE.app.oStructure.aChapter[h].aSection[i].aClip[j].id + "_" + aSegments[k].id +".swf";
								aPreloadClips.unshift({url: sUrl, userData: aPreloadClips.length + 1, userData2: true});
							}
						}
					}
				}
			}
		}
		return aPreloadClips;
	}
	public static function updateBackgroundPreload(){
		_global.ILE.Preloader.stopCurrentBackgroundPreload();
		var nCurrent = Server.getController("clipPlayer").oClipData.nAbsoluteOrder;	// timeline var for sort function
		// order the background loads, starting with the audio for this clip and then the clip after
		// unless audio is turned off, then sort all clips first and then do the audio (just in case they turn audio back on)
		_global.ILE.Preloader.aBackgroundQueue.sort(
			function(a,b) {
				if(!State.bAudio) {
					if(a.userData2 && !b.userData2) {
						return 1;
					} else if(!a.userData2 && b.userData2) {
						return -1;
					}
				}
				
				var aPos = a.userData;
				var bPos = b.userData;
				if((aPos > nCurrent && bPos > nCurrent) ||(aPos <= nCurrent && bPos <= nCurrent)) {
					return aPos < bPos ? -1 : aPos > bPos ? 1 : 0;
				}
				else {
					// one is above nCurrent, one is below it
					return aPos > bPos ? -1 : aPos < bPos ? 1 : 0;
				}
			}
		);
	}
	
	public static function traceObject(obj:Object) {
		var sObj = "";
		for( var name in obj ){ 
			sObj += "\n\t" + name + " : " +  obj[name]; 
		}
		//trace(sObj);
	}
	public static function doStateDump() {
		var s:String = "\n------------------------ Start State Dump ----------------------------";
		for(var elm:String in State) {
				s += "\n\t" + elm + ": " + State[elm];
		}
		s += "\n-----------------------  End State Dump  ----------------------------\n";
		return s;
	}
	public static function getVersionInfo() {
		var s:String = "\n---------------------- Version Info ---------------------------";
		for(var elm:String in VersionInfo) {
				s += "\n\t" + elm + ": " + VersionInfo[elm];
		}
		s +=  "\n---------------------------------------------------------------\n";
		return s;
	}
		
}