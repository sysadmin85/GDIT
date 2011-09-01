import org.asapframework.util.debug.Log;
import org.asapframework.util.types.Point;
import org.asapframework.util.types.Rectangle;
import org.asapframework.util.RectangleUtils;
import enspire.display.LayoutUtils;
import com.mosesSupposes.fuse.Fuse;
import enspire.model.Configs;

class enspire.display.Tooltip{

	private static var mcHolder:MovieClip;
	private static var mcTip:MovieClip;
	private static var profile:Object;
	private static var fTip:Fuse;
	
	public static function init(mc:MovieClip, nDepth:Number) {
		var nD = isNaN(nDepth) ? 60000 : nDepth;
		mcHolder = mc.createEmptyMovieClip("mcTooltipHolder", nD);
	}

	public static function create(mc:MovieClip, sTip:String, sAlign:String, sProfile) {
		destroy();
		if(sProfile == undefined) {
			sProfile = "Tooltip";
		}
		profile = Configs.getProfile(sProfile);
		var sSkin = (profile["sSkin"] == undefined) ? "Tooltip" : profile["sSkin"];
		mcTip = mcHolder.attachMovie("Tooltip", sSkin, 500);
		mcTip.mcText.tf.multiline = false;
		mcTip.mcText.tf.autoSize = true;
		mcTip.mcText.tf.text = sTip;

		var currentOff = 0;
		if(!isNaN(profile["nMaxTipWidth"]) && (mcTip.mcText._width > profile["nMaxTipWidth"])) {
			currentOff = mcTip.mcBg._height - mcTip.mcText._height
			LayoutUtils.applyWidthToTextField(mcTip.mcText.tf, profile["nMaxTipWidth"]);
			mcTip.mcBg._height = mcTip.mcText._height + currentOff + mcTip.mcText._x;
		}
		mcTip.mcBg._width = mcTip.mcText._width + (mcTip.mcText._x * 2);
		
		// set dynamic registration
		LayoutUtils.addDynamicRegistration(mcTip);
		var xReg = isNaN(profile["nPosX"]) ? 0 : profile["nPosX"];
		var yReg = (isNaN(profile["nPosY"]) ? 0 : profile["nPosY"]) + currentOff;
		mcTip.setRegistration(xReg, yReg);
		
		// position tool tip
		var nY:Number;
		var nX:Number;
		var useAlign = (sAlign == undefined) ? profile["sAlign"] :  sAlign;
		switch(useAlign) {
			case "follow":
				nY = mcHolder._ymouse;
				nX = mcHolder._xmouse;
				break;
			case "right":
				// get local point 
				var r1 = getLocalRectangle(mc);
				// get bounds rectangle
				nX = r1.right;
				nY = r1.top;
				break;
			case "left":
				// get local point 
				var r1 = getLocalRectangle(mc);
				nX = r1.topLeft.x;
				nY = r1.topLeft.y;
				break;
			case "center":
				// get local point 
				var r1:Rectangle = getLocalRectangle(mc);
				var p1:Point = RectangleUtils.getCenter(r1);
				nX = p1.x;
				nY = p1.y;
			break;
			case "defualt":
				nX = mcHolder._xmouse;
				nY = mcHolder._ymouse;
			
		}
		
		// uses dynamic registration
		mcTip._x2 = nX;
		mcTip._y2 = nY;
		
		if(useAlign == "follow") {
			mcTip.onEnterFrame = function() {
				this._x2 = this._parent._xmouse;
				this._y2 = this._parent._ymouse;
			}
		}
		// do fade in if we need to
		if(profile["bFade"] == true) {
			// check to see if we have a delay
			
			var nFadeSpeed = (isNaN(profile["nFadeSpeed"])) ? .5 : profile["nFadeSpeed"];
			// make fuse
			fTip = new Fuse();
			fTip.autoClear = true;
			fTip.push({target:mcTip, alpha:100, start_alpha:0, time:nFadeSpeed,  delay:profile["bDelay"]});
			fTip.start();
		}
	}

	public static function destroy() {
		// destroy fuse
		fTip.destroy();
		delete mcTip.onEnterFrame();
		mcTip.removeMovieClip();
	}
	private static function getLocalPoint(mc:MovieClip, nX:Number , nY:Number) : Point {
		var p1:Point = new Point(nX, nY);
		mc.localToGlobal(p1);
		mcHolder.globalToLocal(p1);
		return p1;
	}
	private static function getLocalRectangle(mc) : Rectangle {
		var b1:Object = mc.getBounds(mcHolder);
		var r1:Rectangle = new Rectangle(b1.xMin, b1.yMin, (b1.xMax - b1.xMin), (b1.yMax - b1.yMin))
		return r1;
	}
}