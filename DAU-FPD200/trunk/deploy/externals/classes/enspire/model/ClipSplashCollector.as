import enspire.model.ModelCollector;
import enspire.model.Configs;
import enspire.model.structure.SegmentData;
class enspire.model.ClipSplashCollector extends ModelCollector{
		
	function collect(seg:SegmentData) {
		if((seg.args.bTitleSeg != "false") && (Configs.getConfig("bTitleSeg")) && (seg.nSegment == 0) && (seg.args.noSplash == undefined)){
			// if we have title splash on add it to the templates arg
			if(seg.args.sSplash == undefined) {
				seg.args.sSplash = "TitleSplash";
			}
			seg.args.noSegFlag = "true";
			seg.args.noFade = true;
			seg.bCount = false;
		}else{
			seg.bCount = true;
		}
	}
	
	
}