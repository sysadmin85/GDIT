/*
   class: VisualRandomizer
   Event that is dispatched from any Movie Clip that inherits from <HotSpot> when
   the standard mouse actions are performed on the clip.
*/
class enspire.interactivity.utils.VisualRandomizer {
	
	public function VisualRandomizer() {
		
	}
	
	// Pass in an array of movie clips, this function will
	// swap their positions in a random manner
	public function randomizePositions(a:Array):Void {
		for(var i = 0; i < a.length; i++) {
			var clip = a[i];
			var complementIndex = (a.length-1) - i;
			var complementClip = a[complementIndex];
			if(Math.random() > .5) {
				var tempx = clip._x;
				var tempy = clip._y;
				clip._x = complementClip._x;
				clip._y = complementClip._y;
				complementClip._x = tempx;
				complementClip._y = tempy;
			}
		}
	}
	
}

