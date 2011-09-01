import enspire.model.structure.ChapterData;
import enspire.model.structure.SectionData;
import enspire.model.structure.ClipData;
dynamic class enspire.model.structure.SegmentData{
	public var chapter:ChapterData;
	public var section:SectionData;
	public var clip:ClipData;
	private var bComplete;
	function SegmentData() {
		bComplete = false;
	}
	function getComplete() {
		return this.bComplete;
	}
	function setComplete() {
		this.bComplete = true;
	}
	function toString() {
		var s = "SegmentData\n";
		for(var arg in this) {
			if((arg != "clip") && (arg != "chapter") && (arg != "section") && (typeof(this[arg]) != "function")) {
				
				if(typeof(this[arg]) == "object") {
					s += "\t"+arg+"\n";
					for(var elm in this[arg]) {
						var obj = this[arg]
						s += "\t\t"+elm+": "+obj[elm]+"\n";
					}
				}else{
					s += "\t"+arg+": "+this[arg]+"\n";
				}
				
				
			}
		}
		return s;
	}
}