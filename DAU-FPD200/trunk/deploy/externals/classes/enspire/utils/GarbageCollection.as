class enspire.utils.GarbageCollection{
	private static var aCollection:Array = new Array();
	
	public static function markAsTrash(oGarbage) {
		aCollection.push(oGarbage);
	}
	public static function destroy() {
		for (var i=0; i<aCollection.length; i++) {
			
			if(typeof aCollection[i] == "movieclip"){
				aCollection[i].destroy();
				aCollection[i].removeMovieClip();
				
			}else if (typeof aCollection[i] == "number"){
				// interval id
				clearInterval(aCollection[i]);
			}
		}
		aCollection = [];
	}
}