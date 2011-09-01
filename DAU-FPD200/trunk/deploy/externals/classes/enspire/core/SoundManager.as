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

//
class enspire.core.SoundManager{
	private static var instance:SoundManager;
	
	private var mcAudio:MovieClip;
	private var oSound:Sound;
	private var fxs:KeyValueList;
	private var loops:KeyValueList;

	
	private var nStoredVol:Number;
	private var nStoredPos:Number;
	
	
	
	private var bPaused:Boolean;
	private var bPlaying:Boolean;
	private var sDir:String;
	private var sFxDir:String;
	//
	private function SoundManager() {
		this.fxs = new KeyValueList();
		this.loops = new KeyValueList();
		this.oSound = new Sound();
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
	public static function getInstance():SoundManager{
		if ( instance == undefined ) instance = new SoundManager();
		return instance;
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
	
	public function playSound(sSnd:String) {
		this.oSound = new Sound(this.mcAudio);
		this.oSound.onSoundComplete = Delegate.create(this, onSoundComplete);
		var url = this.sDir + sSnd
		this.oSound.loadSound(url, true);
		this.bPaused = false;
		this.bPlaying = true;
		State.bEndedAudio = false;
		
		//Log.status("Play Sound: "+sSnd, this.toString());
		
	}
	public function addEffect(sName:String, sLinkage:String, nVol:Number) {
		var n = this.fxs.getCount();
		var mcFx = this.mcAudio.createEmptyMovieClip("mcFx"+n, n)
		var fxSound = new Sound(mcFx);
		

		if(sLinkage.indexOf("file:///") != -1) {
				
		var url = this.sFxDir + sLinkage.substr(8, (sLinkage.length - 1));
			fxSound.loadSound(url, false);
		}else{
			fxSound.attachSound(sLinkage);
		}
		if(isNaN(nVol) || nVol == undefined) {
			nVol = 100;
		}
		fxSound.setVolume(nVol);
		this.fxs.addValueForKey(fxSound, sName);
		//Log.error("Sound FX Added - id: "+sName + ", url: "+url+", vol "+nVol, this.toString());
	}
	public function playEffect(sName:String, nLoops:Number) {
		if(isNaN(nLoops)) {
			this.fxs.getValueForKey(sName).start();
		}else{
			this.fxs.getValueForKey(sName).start(0, nLoops);
		}
		//Log.info("Playing effect "+sName, this.toString());
	}
	public function stopEffect(sName:String) {
		this.fxs.getValueForKey(sName).stop();
		//Log.info("Sound Fx "+sName, this.toString());
	}
	public function pause() {
		if(!this.bPlaying) {
			return;
		}
		//Log.info("Audio Puased - pos: "+this.nStoredPos, this.toString());
		this.bPaused = true;
		this.bPlaying = false;
		this.nStoredPos = this.oSound.position/1000;
		this.nStoredVol = this.oSound.getVolume();

		this.oSound.setVolume(0);
		this.oSound.stop();	
	}
	public function resume() {
		
		if(!this.bPaused) {
			return;
		}
		this.bPaused = false;
		this.bPlaying = true;
		if(!State.bMute) {
			this.oSound.setVolume(this.nStoredVol);
		}
		//Log.info("Audio Resumed - pos: "+this.nStoredPos, this.toString());
		this.oSound.start(this.nStoredPos);
	}
	public function getFxList(sDelimiter:String) {
		if(sDelimiter == undefined) {
			sDelimiter = ", ";
		}
		var a = this.fxs.getArray()
		var aKeys = new Array()
		for(var i:Number = 0; i < a.length; i++) {
			aKeys.push(a[i].key);
		}
		return aKeys.join(sDelimiter);
	}
	private function onSoundComplete() {
		//Log.info("Audio Ended", this.toString());
		this.oSound.stop();
		this.oSound = undefined;
		this.bPaused = false;
		this.bPlaying = false;
		Server.getController("app").onEndElement("audio");
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
	public function parseSounds(xml:XML) {
		var theXML:XML = XML(xml);
		
		var fxs = XPath.selectSingleNode(theXML.firstChild,"fxs");
		var sfxs = XPath.selectNodes(fxs, "sound");
		
		//Log.info("Parsing sound fxs: "+ sfxs.length, this.toString());
		for(var i:Number = 0; i < sfxs.length; i++) {
			var fx = sfxs[i].attributes;
			var url = fx.url;
			var bExternal = url.indexOf(".mp3") != -1;
			var nVol = parseInt(fx.nVol);
			var sName = fx.id;
			if(bExternal) {
				url = "file:///"+url;
			}
			this.addEffect(sName, url, nVol)
			
		}
		//var loops = XPath.selectNodes(theXML.firstChild, "loops");
	}
	function toString() {
		return "enspire.core.SoundManger";
	}

}