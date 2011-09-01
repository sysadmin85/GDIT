import com.mosesSupposes.fuse.Fuse;
import enspire.display.templates.BaseTemplate;
import org.asapframework.util.debug.Log;
import enspire.core.Server;
class enspire.display.templates.ListSimpleBullet extends BaseTemplate{
	private static var FLAG:String = "list";
	private var mcHeader:MovieClip;
	private var mcBody:MovieClip;
	private var padding:Number = 5;
	function ListSimpleBullet() {
		super();
		mcHeader._alpha = 0;
		mcBody._alpha = 0;
		Server.getController("gui").disableControl("next");
		Server.getController("gui").disableControl("back");
		Server.addFlag(FLAG);
		
	}
	function draw() {
		// create header
		var spacing  = isNaN(this.profile["nBulletSpacing"]) ? 0 :this.profile["nBulletSpacing"];
		var nDelay = isNaN(this.profile["nBulletSpeed"]) ? .5 : this.profile["nBulletSpeed"];
		
		var f = new Fuse();
		f.scope = this;
		f.push({delay: .5});
		

		this.mcHeader.tf.html = true;
		this.mcHeader.tf.htmlText = this.args["sHeader"];
		
		f.push({target:mcHeader, alpha:100, time:.5});
		
		
		//position body
		this.mcBody._y = this.mcHeader._height + padding;
		
		f.push({target:mcBody, alpha:100, time:.5});
		
		var aBullets = getBullets();
		var bHolder = this.mcBody.createEmptyMovieClip("mcBullets", this.getNextHighestDepth());
		bHolder._y = 10;
		bHolder._x = 10;
		
		if(aBullets.length > 0) {
			var nY:Number = 0;
			var nDepth = 0;
			for(var i:Number = 0; i < aBullets.length; i++) {
				
				
				
				// add line
				
				if(args["sDivider"+i] == "line") {
					var line = bHolder.attachMovie("bl_divider", "mcDivider"+i, nDepth);
					line._alpha = 0;
					line._x = -10;
					line._y = nY;
					nY += line._height + spacing;
					nDepth++;
					f.push({target:line, alpha:100, x:0, time:.5, delay:nDelay});
				}
				
				// add sub text
				if(args["sSubhead"+i] != undefined) {
					var sub = bHolder.attachMovie("bl_sub", "mcSub"+i, nDepth);
					sub.tf.multiline = true;
					sub.tf.autoSize = true;
					sub.tf.html = true;
					sub.tf.htmlText =  args["sSubhead"+i]
					sub._alpha = 0;
					sub._x = -10;
					sub._y = nY;
					nY += sub._height + spacing;
					nDepth++;
					f.push({target:sub, alpha:100, x:0, time:.5,  delay:nDelay});
				}
				
				// add bullet
				var bullet = bHolder.attachMovie("bl_bullet", "mcBullet"+i, nDepth);
				bullet.tf.multiline = true;
				bullet.tf.autoSize = true;
				bullet.tf.html = true;
				bullet.tf.htmlText =  aBullets[i].sText
				bullet._alpha = 0;
				bullet._x = -10;
				bullet._y = nY;
				nY += bullet._height + spacing;
				nDepth++;
				f.push({target:bullet, alpha:100, x:0, time:.5,  delay:nDelay});
				
				
				// add footer if we need one
				if(args["sFooter"+i] != undefined) {
					var footer = bHolder.attachMovie("bl_sub", "mcSub"+i, nDepth);
					footer.tf.multiline = true;
					footer.tf.autoSize = true;
					footer.tf.html = true;
					footer.tf.htmlText =  args["sFooter"+i]
					footer._alpha = 0;
					footer._x = -10;
					footer._y = nY;
					nY += footer._height + spacing;
					nDepth++;
					f.push({target:footer, alpha:100, x:0, time:.5,  delay:nDelay});
				}
				
			}
		}
		this.mcBody.mcBg._height = (bHolder._y * 2) + bHolder._height;
		
		
		var fEnd = function() {
			Server.getController("gui").enableControl("next");
			Server.getController("gui").enableControl("back");
			Server.getController("app").onEndElement(FLAG);
		}
		
		f.push({func: fEnd});
		f.start();
		this.show();
		
	}
	function getBullets() {
		var aBullets = new Array();
		for(var i in this.args) {
			//trace("Checking for Bullet");
			if(i.indexOf("sBullet") != -1) {
				aBullets.push({bNum: i, sText: args[i]});
			}
		}
		aBullets.sortOn("bNum");
		return aBullets;
	}
}