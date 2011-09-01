import org.asapframework.data.KeyValueList;
import org.asapframework.util.debug.Log;
//
import mx.utils.Delegate;
// xpath
import com.xfactorstudio.xml.xpath.XPath;
//
import enspire.model.State;
import enspire.model.Configs;
import enspire.core.Server;

import enspire.audio.*;

class enspire.audio.SoundManager{
	private var mcAudio:MovieClip;
	private var oSound:Sound;
	private var fxs:KeyValueList;
	private var loops:KeyValueList;
	private var clips:KeyValueList;

	private var nStoredVol:Number;
	private var nStoredPos:Number;
	private var nSoundCnt:Number;
	
	private var bPaused:Boolean;
	private var bPlaying:Boolean;
	private var sDir:String;
	private var sFxDir:String;
	
	private var currClip:ClipSound;
	
	function SoundManager() {
		this.fxs = new KeyValueList();
		this.loops = new KeyValueList();
		this.clips = new KeyValueList();
		this.oSound = new Sound();
		this.nSoundCnt = 0;
		this.sDir = "audio/";
		this.sFxDir = "audio/fxs/";
		this.bPaused = false;
		this.bPlaying = false;
		State.bEndedAudio = true;
	  	State.bMute = false;
		
	}
	
	public function setSoundDirectory(sDir:String) {
		this.sDir = sDir;
	}
	public function setFxDirectory(sFxDir:String) {
		this.sFxDir = sFxDir;
	}
	
	public function setContainer( mc:MovieClip, depth:Number ):Void{
		if(mc == undefined) {
			mc = _root;
		}
		if(depth == undefined) {
			depth = 66666;
		}
		
		this.mcAudio = mc.createEmptyMovieClip("mcAudio",  depth);
		////trace("SOUND CONTAINER CREATED: "+this.mcAudio)
	}
	public function setVolume(n:Number) {
		if(n < 0) {n = 0};
		if(n > 100) {n = 100};
		this.oSound.setVolume(n);
		nStoredVol = n;
	}
	public function getVolume() {
		return this.oSound.getVolume();
	}
	public function playEffect(sName:String, nLoops:Number) {
		var fx = this.fxs.getValueForKey(sName)
		fx.play();
		//Log.info("Playing effect "+fx.toString(), this.toString());
	}
	public function stopEffect(sName:String) {
		this.fxs.getValueForKey(sName).stop();
		//Log.info("Sound Fx "+sName, this.toString());
	}
	public function playClipSound(sName:String) {
		this.currClip = this.clips.getValueForKey(sName);
		this.currClip.play();
		//Log.info("Playing clip sound "+sName, this.toString());
	}
	public function stopClipSound(sName:String) {
		this.clips.getValueForKey(sName).stop();
	}
	public function removeClipSound(sName:String) {
		var cSound = this.clips.getValueForKey(sName)
		cSound.stop();
		cSound.remove();
		this.clips.removeValueForKey(sName)
		//Log.info("Sound Fx "+sName, this.toString());
	}
	public function clearClipsSounds() {
		var a = this.clips.getArray();
		for(var i:Number = 0; i < a.length; i++) {
			a[i].value.stop();
			a[i].remove();
		}
	}
	public function playLoop(sName:String, nLoops:Number) {
		if(isNaN(nLoops)) {
			this.fxs.getValueForKey(sName).play();
		}else{
			this.fxs.getValueForKey(sName).play(0, nLoops);
		}
		//Log.info("Playing effect "+sName, this.toString());
	}
	public function stopLoop(sName:String) {
		this.fxs.getValueForKey(sName).stop();
		//Log.info("Stop Loop "+sName, this.toString());
	}
	
	public function pause() {
		//Log.info("Audio Paused - pos: "+this.nStoredPos, this.toString());
		this.bPaused = true;
		this.bPlaying = false;
		
		this.currClip.pause();
		//this.oSound.setVolume(0);
		//this.oSound.stop();	
	}
	public function resume() {
		this.bPaused = false;
		this.bPlaying = true;
		/*if(!State.bMute) {
			this.oSound.setVolume(this.nStoredVol);
		}
		//Log.info("Audio Resumed - pos: "+this.nStoredPos, this.toString());*/
		this.currClip.resume();
	}
	
	public function getLoopList() {
		return this.getList(this.loops);
	}
	public function getFxList() {
		return this.getList(this.fxs);
	}
	private function getList(lList:KeyValueList) {
		var a = lList.getArray()
		var aKeys = new Array()
		for(var i:Number = 0; i < a.length; i++) {
			aKeys.push(a[i].key);
		}
		return aKeys;
	}
	public function setMute(b:Boolean) {
		if(b) {
			this.nStoredVol = this.oSound.getVolume();
			this.oSound.setVolume(0);
		}else{
			this.oSound.setVolume(this.nStoredVol);
		}
		State.bMute = b;
	}
	public function isMute() {
		return State.bMute;
	}
	
	private function makeClip() {
		var n = this.nSoundCnt++;
		return this.mcAudio.createEmptyMovieClip("mcSound"+n, n);
	}
	public function addClipSound(sName:String, url:String, nVol:Number) {
		var cSound = new ClipSound(sName, this.makeClip());
		cSound.setUrl(this.sDir+url);
		cSound.setVolume(nVol);
		this.clips.addValueForKey(cSound, sName);
		
		//Log.info("ClipSound Added - id: "+sName + ", url: "+url+", vol "+nVol, this.toString());
	}
	public function addSoundFx(sName:String, url:String, nVol:Number) {
		var fx:FxSound = new FxSound(sName, this.makeClip());
		fx.setUrl(this.sFxDir+url);
		fx.setVolume(nVol);
		this.fxs.addValueForKey(fx, sName);
		//Log.info("FxSound Added - id: "+sName + ", url: "+url+", vol "+nVol, this.toString());
	}
	public function addSoundLoop(sName:String, url:String, nVol:Number) {
		var loop:LoopSound = new LoopSound(sName, this.makeClip());
		loop.setUrl(url);
		loop.setVolume(nVol);
		this.loops.addValueForKey(loop, sName);
		//Log.info("LoopSound Added - id: "+sName + ", url: "+url+", vol "+nVol, this.toString());
	}
	
	
	
	public function parseSounds(xml:XML) {
		var theXML:XML = XML(xml);
		
		var fxs = XPath.selectSingleNode(theXML.firstChild,"fxs");
		var sfxs = XPath.selectNodes(fxs, "sound");
		
		////Log.info("Parsing sound fxs: "+ sfxs.length, this.toString());
		for(var i:Number = 0; i < sfxs.length; i++) {
			var fx = sfxs[i].attributes;
			var nVol = isNaN(parseInt(fx.nVol)) ? 100 : parseInt(fx.nVol);
			this.addSoundFx(fx.id, fx.url, parseInt(nVol))
		}
		
		
		var loops = XPath.selectNodes(theXML.firstChild, "loops");
		var sfxs = XPath.selectNodes(fxs, "sound");
		for(var i:Number = 0; i < sfxs.length; i++) {
			var fx = sfxs[i].attributes;
			var nVol = isNaN(parseInt(fx.nVol)) ? 100 : parseInt(fx.nVol);
			this.addSoundLoop(fx.id, fx.url, parseInt(nVol))
		}
	}
	
	
	
}