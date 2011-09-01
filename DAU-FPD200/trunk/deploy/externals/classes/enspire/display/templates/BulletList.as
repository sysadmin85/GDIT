import enspire.display.templates.BaseTemplate;

import com.mosesSupposes.fuse.Fuse;
import org.asapframework.util.debug.Log;
import org.asapframework.util.StringUtilsTrim;
import enspire.core.Server;
class enspire.display.templates.BulletList extends BaseTemplate{
	private static var FLAG:String = "list";
	private var mcHeader:MovieClip;
	private var mcBody:MovieClip;
	private var mcBulletHolder:MovieClip;
	public var fBullets:Fuse;
	private var aBullets;
	private static var FRAMES_PER_SECOND:Number = 24;
	
	function BulletList() {
		super();
		Server.addFlag(FLAG);
		
	}
	function draw() {
		
		var aDelayArgs = this.args["nBulletDelay"].split(",");
		var aDelays = new Array();
		aBullets = new Array();
		// the args are a list of frame numbers of when the bullet should appear.  convert to delays and from frames to seconds
		for( var m = 0; m < aDelayArgs.length; m++ )
		{
			var tempValue:Number = 0;
			aDelayArgs = this.getDelays(aDelayArgs);
			
			if( m == 0 )  {
				tempValue = Number( aDelayArgs[ 0 ] ) / FRAMES_PER_SECOND ;
			}
			else  {
				tempValue = ( Number( aDelayArgs[ m ] ) - Number( aDelayArgs[ m - 1 ] ) - 12 ) / FRAMES_PER_SECOND;
			}
			aDelays.push(tempValue);
		}		
		fBullets = new Fuse();
		//fBullets.scope = this;
		// create header
		this.mcHeader.mcText.tf.html = true;
		this.mcHeader.mcText.tf.autoSize = true;
		this.mcHeader.mcText.tf.htmlText = this.args["sHeader"];
		this.mcHeader.mcBg._height = this.mcHeader.mcText._height + (this.mcHeader.mcText._y*2);
		this.mcBulletHolder._y = this.mcHeader._y + this.mcHeader._height + getHolderSpace();
		
		//aBullets = getBullets();
		getBullets();
		if(aBullets.length > 0) {
			var nY:Number = 0;
			var nDepth = 0;
			for(var i:Number = 0; i < aBullets.length; i++) {
				var bulletData = aBullets[i];
				var bullet = this.mcBulletHolder.attachMovie(getBulletItemLink(), "mcBullet"+i, nDepth);
				
				bullet.mcText.tf.autoSize = true;
				bullet.startAnim = function () {
					this.gotoAndPlay("show");
					this.fSubBullets.start();
				}
				
				bullet.mcText.tf.htmlText =  aBullets[i].sText	
				//testing for subBullets
				if(bulletData.bSubs) {
					//bullet.fSubBullets.scope = bullet;
					bullet.fSubBullets = new Fuse();
					var nSubY = bullet._y + bullet._height + 5;
					for(var j=0; j<bulletData.subBullets.length; j++){
						var subBullet = bullet.attachMovie(getSubBulletItemLink(), "mcSubBullet"+j, nDepth);
						subBullet.mcText.tf.htmlText = bulletData.subBullets[j].sText;
						subBullet.startAnim = function () {
							this.gotoAndPlay("show");
						}
						
						//subBullet.gotoAndPlay("show");
						subBullet._y = nSubY;
						nSubY += subBullet._height + 5;
						nDepth++;
						bullet.fSubBullets.push({target:subBullet, scope:subBullet, func:"startAnim"});				
					}
						
				}
				
				bullet._y = nY;
				nY += bullet._height + getBulletSpacing();
				//trace("nY: "+nY);
				nDepth++;
				//trace( "Bullet: " + bullet + " waiting:  " + aDelays[i] + " subBullets? " + bulletData.bSubs );
				if(aDelayArgs == undefined) {
					fBullets.push({target:bullet, scope:bullet, func:"startAnim", delay:.5});
				}else {
					fBullets.push({target:bullet, scope:bullet, func:"startAnim", delay:aDelays[i]});
				}
			}
		}
		
		var fEnd = function() {
			//trace("BulletList calling fEnd");
			Server.getController("gui").enableControl("next");
			Server.getController("gui").enableControl("back");
			Server.getController("app").onEndElement("seg");
			Server.getController("app").onEndElement(FLAG);
		}
		fBullets.push({func: fEnd});
		//moving start to timeline so bullets won't begin until after header animation is completed
		//fBullets.start();
		this.show();
		this.gotoAndPlay("show");
	}
	function getBullets() {
		for(var i in this.args) {
			if(i.indexOf("sBullet") != -1) {
				var aSubBullets = new Array();

				var nIndex = i.substring( 7, i.length );
				var nSubIndex = i.indexOf("_");
				var bSub = false;
				if(nSubIndex == -1) {
					//finding if there are relevant sub bullets
					for(var j in this.args) {
						if(j.indexOf("sBullet") != -1) {
							var nSubTest = j.indexOf("_")-2;
							//nSubTest = nSubTest - 1;
							sSubTest = j.substr(nSubTest, 2);
							if(j.indexOf("_") != -1 && sSubTest == nIndex){					
								bSub = true;
								var subIndex = getNewIndex(j.substring(subInd+1, j.length));
								
								aSubBullets.push({sText: args[j], index:  subIndex});
								//trace("I've found a relevant sub! " +args[j]);
								
							}
											
						}
					}
					
				//only dealing with bullets
					//nIndex = getNewIndex(ind);
					aBullets.push({bNum: i, sText: args[i], index:  nIndex, bSubs: bSub, subBullets: aSubBullets});
					//trace("Checking for Bullet |  ind: " + ind + " text: " + args[i] + " bSubs: " + bSub + " subBullets: " + aSubBullets);
			
				}
				
			}
		}
		aSubBullets.sortOn("index");
		aBullets.sortOn("index");
		//return aBullets;
	}

	
	function getBulletItemLink() {
		return "BulletList_Item";
		
	}
	function getSubBulletItemLink() {
		return "BulletList_SubItem";
		
	}
	
	
	
	function getHolderSpace() {
		if(isNaN(this.profile["nHolderSpacing"])) {
			var spacing = 20;
		} else {
			if(Server.model.args.nHolderSpacing != undefined)  {
				var spacing = Number(Server.model.args.nHolderSpacing);
			} else  {
				var spacing = this.profile["nHolderSpacing"];
			}
		}
		return spacing
	}
	

	function getBulletSpacing() {
		if(isNaN(this.profile["nBulletSpacing"])) {
			var spacing = 15;
		} else {
			if(Server.model.args.nBulletSpacing != undefined)  {
				var spacing = Number(Server.model.args.nBulletSpacing);
			} else  {
				var spacing = this.profile["nBulletSpacing"];
			}
		}
		return spacing
	}

	function getNewIndex(nRef) {
		if( nRef < 10 ){
			nIndex = "0" + nRef;
		}
		else {
			nIndex = "" + nRef;
		}
		return nIndex;
	}
	function toString() {
		return "enspire.display.templates.BulletList";
	}
	
	public function getDelays(aDelays:Array):Array  {
		var aTemp:Array = new Array();
		for(var i:Number = 0; i < aDelays.length; i++)  {
			var sTrimmed:String = StringUtilsTrim.trim(aDelays[i]);
			aTemp[i] = sTrimmed;
		}
		return aTemp;
	}
}