import org.asapframework.util.debug.Log;
import enspire.display.ITemplateFactory;
import enspire.display.templates.*;
import enspire.display.alerts.*;
import enspire.utils.ConstructorUtil;

class enspire.display.TemplateFactory implements ITemplateFactory{
	
	public function TemplateFactory() {
		//Log.status("Created", toString());
	}
	
	public function makeTemplate(sType:String, mcHolder:MovieClip) {
		var template = new Object();
		switch(sType) {
			case "BulletList":
				template.clip = this.makeTemplateClip("BulletList", mcHolder, BulletList);
				template.profile = "BulletList";
				break;
			case "TitleSplash":
				template.clip = this.makeTemplateClip("TitleSplash", mcHolder, BaseTemplate);
				template.profile = "TitleSplash";
				break;
			case "instructions":
				template.clip = this.makeTemplateClip("Instructions", mcHolder, Instructions);
				template.profile = "Instructions";
				break;
			case "FeedbackPopup":
				template.clip = this.makeTemplateClip("FeedbackPopup", mcHolder, AlertTemplate);
				template.profile = "Feedback";
				break;
			case "QuizPopup":
				template.clip = this.makeTemplateClip("QuizPopup", mcHolder, AlertTemplate);
				template.profile = "Feedback";
				break;
			case "VideoController":
				template.clip = this.makeTemplateClip("VideoController", mcHolder, VideoController);
				template.profile = "VideoController";
				break;
			default:
				//attempt to make a simple template attempt
				template.clip = this.makeTemplateClip(sType, mcHolder, BaseTemplate);
				template.profile = sType;
				//Log.info("Template type simple", toString());
				break;
		}
		return template;
	}
	private function makeTemplateClip(sLinkage:String, mcHolder:MovieClip, f:Function) {
		////Log.debug("makeTemplateClip: "+sLinkage, toString());
		var nIndex = mcHolder.getNextHighestDepth()
		var mcTemplate = mcHolder.attachMovie(sLinkage, "mc_"+sLinkage+"_"+nIndex, nIndex);
		if(mcTemplate == undefined) {
			//Log.error("TEMPLATE NOT CREATED "+sLinkage, toString());
		}
		// set the template class
		ConstructorUtil.createVisualInstance(f, mcTemplate);
		return mcTemplate;
	}
	public function toString() {
		return "enspire.display.TemplateFactory";
	}
	
}