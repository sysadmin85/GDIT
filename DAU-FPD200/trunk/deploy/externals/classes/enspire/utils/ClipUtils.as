import mx.core.UIObject;
import org.asapframework.util.debug.Log;
import enspire.display.TextBox;
import enspire.utils.ConstructorUtil;
import enspire.display.ContentContainer;
import com.mosesSupposes.fuse.Fuse;


import org.asapframework.util.ObjectUtils;
class enspire.utils.ClipUtils {
	public static function pause(mc:MovieClip, nMax:Number, nInt:Number) {
		nInt = nInt == undefined ? 0 : nInt;
		nMax = nMax == undefined ? 10 : nMax;
		if(nInt == nMax) {
			return;
		}
		nInt++;
		if(typeof mc.isPausable != "boolean" && typeof mc.isPausable != "undefined" && mc.isPausable != "pass") {
			//Log.error("MovieClip.as pause(): invalid value for isPausable '"+mc.isPausable+"' on clip '"+mc+"'");
		}
		if((mc.isPausable == true || mc.isPausable == undefined) && mc.isPausable != "pass") {
			mc.stop();
			mc.isPaused = true;
		}
		// pause all fuse tweens
		if(mc.isTweening) {
			mc.pauseAllTweens();
		}

		if(mc.isPausable || mc.isPausable == undefined || mc.isPausable=="pass") {
			// Recurse through direct children of this clip
			for (var name in mc) {
				// if we have a content container pause it
				var mcSub = mc[name];
				
				if(mcSub instanceof Fuse) {
					mcSub.pause();
					return;
				}
				if(mcSub instanceof UIObject) {
					return;
				}
				
				if(mcSub._parent == mc) {
					ClipUtils.pause(mcSub, nMax, nInt);
				}
			}
		}
	}
	public static function resume(mc:MovieClip, nMax:Number, nInt:Number) {
		nInt = nInt == undefined ? 0 : nInt;
		nMax = nMax == undefined ? 10 : nMax;
		if(nInt == nMax) {
			return;
		}
		nInt++;
		if(mc.isPaused == true && mc._currentframe != mc._totalframes) {
			mc.isPaused = false;
			mc.play();
		}
		// resume fuse tweens
		if(mc.isTweenPaused) {
			mc.resumeAllTweens();
		}
		// Recurse through direct children of this clip
		for (var name in mc) {
			var mcSub = mc[name];
			
			if(mcSub instanceof Fuse) {
				mcSub.resume();
			}
			if(mcSub instanceof UIObject) {
				return;
			}
			
			if(mcSub._parent == mc) {
				
				resume(mcSub, nMax, nInt);

			}
		}
	}
	public static function makeTextBox(mc:MovieClip, sText:String) {
		var oTextBox = ConstructorUtil.createVisualInstance(TextBox, mc);
		oTextBox.text = (sText == undefined) ? "" : sText
		return oTextBox;
	}
	/*	Function: doPrototyping
		sets up enspire style movieclip prototyping for pause play functionality if this function is overrode in subclass make sure to call super.doPrototyping()
	*/
	public static function doPrototyping() {
		// 
		MovieClip.prototype.oldstop = MovieClip.prototype.stop;
		MovieClip.prototype.stop = function() {this.isPausable="pass"; this.oldstop()};
		
		MovieClip.prototype.oldplay = MovieClip.prototype.play;
		MovieClip.prototype.play = function() { this.isPausable=true; this.oldplay()};
	}
}