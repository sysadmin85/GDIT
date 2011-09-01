import org.asapframework.util.*;

import enspire.interactivity.control.*;
import enspire.interactivity.display.*;
import enspire.interactivity.evaluation.*;
import enspire.interactivity.events.*;
import enspire.interactivity.model.*;
import enspire.interactivity.score.*;
import enspire.interactivity.utils.*;
import enspire.interactivity.main.*;
import enspire.interactivity.*;

/*
   
*/
class enspire.interactivity.model.MouseFollower 
	extends InteractivityClip {
	
	public function MouseFollower() {
		super();
	}
	
	public function startFollow() {
		this.onEnterFrame = follow;
	}
	
	public function stopFollow() {
		this.onEnterFrame = null;
	}
	
	public function follow() {
		if(this._parent._xmouse < 340) {
			this._x = this._parent._xmouse;
			this._y = this._parent._ymouse;
		} else {
			this._x = this._parent._xmouse - this._width;
			this._y = this._parent._ymouse;
		}
		this._visible = true;
	}
	
	
	
}

