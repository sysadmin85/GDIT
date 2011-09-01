import enspire.model.BaseUserData;
import enspire.model.State;
import enspire.core.Server;
class enspire.model.SimpleUserData extends BaseUserData{
	private static var TOP_DELIMITER:String = "^";
	function SimpleUserData() {
		super();
	}
	public function parseBookmark(sBookmark:String) : Void {
		if((sBookmark == "") || (sBookmark == undefined) || (sBookmark == null) || (sBookmark == "null") || (sBookmark == "undefined")) {
			return;
		}
		var aParts = sBookmark.split("^");
		var nSeg = parseInt(aParts[0]);
		Server.getController("app").nStartSeg = isNaN(nSeg) ? 0 : nSeg;
		Server.model.structure.parseSuspend(aParts[1]);
		super.parseBookmark(aParts[2]);
	}
	private function makeBookmark() {
		return State.nSegment+TOP_DELIMITER+Server.model.structure.getBookmark()+TOP_DELIMITER+super.makeBookmark();
	}
}