import enspire.display.templates.BaseTemplate;
import enspire.core.Server;;
import enspire.ile.commands.VideoPause;
import enspire.ile.commands.VideoPlay;
import mx.video.*;
class enspire.display.templates.VideoController extends BaseTemplate{
	
	private var sPath:String;
	private var mcVideoPlayer:FLVPlayback;
	private var mcPlayer:MovieClip;
	private var mcCaptions:MovieClip;
	
	function VideoController() {
		super();
		Server.addController("video", this);
		Server.addFlag("video");		
		Server.overrides.addCommand(new VideoPlay(this));
		Server.overrides.addCommand(new VideoPause(this));
		
		//trace("OVERRIDES: "+Server.overrides.getCommandList());
	}
	public function draw() {
		//Calling the init from the stage to allow for animation. Uncomment below to have it initialize from code.
		//init();
		this.show();
		this.gotoAndPlay("show");
		//mcVideoPlayer.play();		
	}
	public function init() {
		sPath = Server.model.getArg("sPath");
		mcVideoPlayer.contentPath="videos/"+sPath;
		mcVideoPlayer.seekBar = mcPlayer.mcSeekBar;
		mcCaptions = Server.getPanel("captions");
		
		//mcCaptions.setText(" ");
		//trace("Video initted! mcCaptions: " + mcCaptions.mcText);
		mcCaptions.mcText.tf.htmlText = " ";
		this.aCaptions = new Array();
		var xCaptions=Server.xmls.getXml("videoCaptions").firstChild.childNodes;
		for(var i=0; i<xCaptions.length; i++){
			if(xCaptions[i].attributes.vidName == sPath) {
				this.aCaptions.push({vidName:xCaptions[i].attributes.vidName, timeStamp:parseInt(xCaptions[i].attributes.timeStamp), captionText:xCaptions[i].attributes.captionText});
			}
		}
		
		var playerListener = new Object();
		playerListener.controller = this;
		playerListener.playheadUpdate = function(){
			this.controller.updateCaption();
			this.controller.mcPlayer.tf.text = this.controller.toMin(this.controller.mcVideoPlayer.playheadTime)+" / "+this.controller.toMin(this.controller.mcVideoPlayer.totalTime);
		}
		playerListener.complete=function(){
			Server.commands.runCommand("next");
			Server.removeFlag("video");
		}
		
		/*
		listenerObject.ready=function(){
			//mcPlayer._visible=true;		
			//mcPlayer.tfTime.text=toMin(mcVideoPlayer.playheadTime)+" / "+toMin(mcVideoPlayer.totalTime);
			//mcPlayer.mcSeekBar.progress_mc._width=652*(mcVideoPlayer.playheadTime/mcVideoPlayer.totalTime);
		}
		*/
		//mcVideoPlayer.addEventListener("ready", playerListener);
		mcVideoPlayer.addEventListener("playheadUpdate",playerListener);
		mcVideoPlayer.addEventListener("complete",playerListener);
		
		mcVideoPlayer.play();		
		
	}
	
	function updateCaption(){
		for(var i=0; i<this.aCaptions.length; i++){		
			if(this.aCaptions[i].timeStamp < mcVideoPlayer.playheadTime){					
				if(this.currentCap!=this.aCaptions[i].captionText){									
					this.currentCap=this.aCaptions[i].captionText;
				}
			}
		}
		//mcCaptions.setText(this.currentCap);
		mcCaptions.mcText.tf.htmlText = this.currentCap;
		////trace("Current cap is >> " + this.currentCap);
		
	}
	public function pauseVideo(){
		mcVideoPlayer.pause();
	}
	
	public function resumeVideo(){
		mcVideoPlayer.play();
	}
	
	function toMin(nTime){
		var sMin=("0"+Math.floor(nTime/60).toString()).substr(-2);
		var sSec=("0"+Math.floor(nTime%60).toString()).substr(-2);
		return sMin+":"+sSec;
	}

	function toString() {
		return "enspire.display.templates.VideoController";
	}
}