
/*
   class: ConstructorUtil
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.utils.ConstructorUtil {
	public static  function createBasicInstance(c:Function) {
		var i = {};
		i.__proto__ = c.prototype;
		i.__constructor__ = c;
		return i;
	}
	public static  function createInstance(c:Function,args:Array) {
		if (!c) {
			return null;
		}
		var i = ConstructorUtil.createBasicInstance(c);
		c.apply(i, args);
		return i;
	}
	public static  function createVisualInstance(c:Function,oVisual,oInit) {
		oVisual.__proto__=c.prototype;
		if (oInit) {
			for (var each:String in oInit) {
				oVisual[each] = oInit[each];
			}
		}
		c.apply(oVisual);
		return oVisual;
	}
	public static function createInstanceByNamespace( path:String , scope ){
		var a:Array = path.split('.');
		var l:Number = a.length ;
		var name:String ;
		scope = scope || _global ;
		for (var i:Number = 0 ; i < l ; i++) {
			name = a[i] ;
			if ( ! scope[name] ) {
				scope[name] = {} ;
			}
			scope = scope[name] ;
		}
		return scope ;
	} ;
}