/*	Class: enspire.display.LayoutUtils
	A static class to provide alligment and layout help
*/
import flash.geom.Rectangle;
import com.darronschall.DynamicRegistration;
//
import enspire.display.templates.BaseTemplate;
import enspire.display.ContentContainer;
import org.asapframework.util.ObjectUtils;
//
class enspire.display.LayoutUtils{
	/*	Function: applyWidthToTextField
		resizes textfield to set width
		
		Parrameters:
		tf - (required) textfield to resize
		nW - (required) new width
	*/
	public static function applyWidthToTextField(tf:TextField, nW:Number) {
		tf.multiline = tf.wordWrap = false;
		tf.autoSize = true;
		//tf.border = true;
		if(tf._width > nW) {
			tf._width = nW;
			tf.multiline = tf.wordWrap = true;
		}	
	}
	/*	Function: find
		recursive object search, mainly used to find nested movieclips
		
		Parrameters:
		oHaystack - (required) object to search, untyped
		sNeedle - (required) object to look for
		sType - (optional) garentees that you get the type of var you are looking for i.e. "movieclip"
	*/
	public static function find(oHaystack, sNeedle:String, sType:String) {
		////trace("LayoutUtils.find(" + oHaystack + ", " + sNeedle + ")");
		var mcFound;
		var o
		// return if they're the same
		if(oHaystack._name == sNeedle) {
			return oHaystack;
		}
		
		for(var name in oHaystack) {
			if(typeof oHaystack[name] == sType || sType == undefined) {			
				if(name == sNeedle) {
					////trace("LayoutUtils.find name == sNeedle");
					mcFound = oHaystack[name];
					return mcFound;
					break;
				}		
				o = oHaystack[name];
				
				if(o._parent == oHaystack)
				{
					mcFound = find(o, sNeedle, sType);
				}
			}
		}
		////trace("LayoutUtils.find returning "+mcFound);
		return (mcFound != undefined) ? mcFound : false;
	}
	/*	Function: positionToPoint
		position a movieclip to a point, does not use dynamic registration
		
		Parrameters:
		mc - (required) movieclip to position
		x - (required) number for new x
		x - (required) number for new y
	*/
	public static function positionToPoint(mc:MovieClip, x:Number, y:Number) {
		mc._x = x;
		mc._y = y;
	}
	/*	Function: makeBounds
		returns a rectangle object based on movieclips mcBounds clip or for the clip dimensions
		
		Parrameters:
		mc - (required) movieclip to take bounds rectangle from
	*/
	public static function getClipBounds(mc:MovieClip) {
		////trace("getClipBounds");
		if((mc != undefined) && (mc instanceof MovieClip)) {
			
			//if there is a bounds clip use that
			if((mc["mcBounds"] != undefined)&& (mc["mcBounds"] instanceof MovieClip)) {
				mc = mc["mcBounds"];
			}
			return makeBounds(mc._x, mc._width, mc._y, mc._height);
		}
		
		return undefined;
	}
	/*	Function: makeBounds
		returns a rectangle object
		
		Parrameters:
		x - (required) x of rectangle
		y - (required) y of rectangle
		w - (required) width of rectangle
		h - (required) height of rectangle
	*/
	public static function makeBounds(x:Number, w:Number, y:Number, h:Number) {
		return new Rectangle(x, y, w, h);
	}
	public static function addDynamicRegistration(mc) {
		DynamicRegistration.initialize(mc)
	}
	/*	Function: dynaAlignToContainer
		use a dynamic registartion to allign a clip to a content container
		
		Parrameters: 
		rect - (required) the bounds rect of the content container
		mcTemplate - (required) template to align
		xAlign - (optional) - string defualts to left
		yAlign - (optional) - string defualts to top
	*/
	public static function dynaAlignToBounds(rect:Rectangle, mcTemplate:BaseTemplate, xAlign:String, yAlign:String, bSetReg:Boolean) : Void {
		var xReg = 0;
		var yReg = 0;
		var xPos = 0;
		var yPos = 0;
		var mcRect = getClipBounds(mcTemplate);
		
		switch(xAlign.toLowerCase()) {
			case "center":
				xReg = mcRect.width / 2;
				xPos = rect.width / 2;
				break;
			case "right":
				xReg = mcRect.width;
				xPos = rect.width;
				break;
		}
		switch(yAlign.toLowerCase()) {
			case "center":
				yReg = mcRect.height / 2;
				yPos = rect.height / 2;
				break;
			case "bottom":
				yReg = mcRect.height;
				yPos = rect.height;
				break;
		}
		//trace("xPos: "+xPos+" yPos: "+yPos);
		if(bSetReg != false) {
			mcTemplate.setRegistration(xReg, yReg);
		}
		mcTemplate._x2 = xPos;
		mcTemplate._y2 = yPos; 
		
		////trace("\n\n\n//trace out template object");
		//ObjectUtils.//traceObject(mcRect);
		//trace("BOUNDS +");
		
		//ObjectUtils.//traceObject(mcTemplate)
	}
	/*	Function: dynaAlignToContainer
		this function handles the template alignment based on settings in the templates profile object. the profile object has to be added to the template before this is called
		
		Parrameters: 
		rect - (required) the bounds rect of the content container
		mcTemplate - (required) template to align
	*/
	public static function alignToContainer(rect:Rectangle, mcTemplate:BaseTemplate) {
		
	}
}