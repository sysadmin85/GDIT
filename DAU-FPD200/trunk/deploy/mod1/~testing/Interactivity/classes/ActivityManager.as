import org.asapframework.util.FrameDelay;
import Activity;
class ActivityManager{
	private var mcClip:MovieClip;
	private var currentActivity:Activity;

	function ActivityManager(mcClip:MovieClip) {
		this.mcClip = mcClip;
		trace("Activity Manager Init");
	}
	function create(sType:String) {
		// add activity todo make loop to add multiple controllers
		
		// determine which profile to use
	
		var template = createTemplate("Activity1");
		currentActivity = new Activity(template);
		// temp for now until we have this working
		currentActivity.args = {sPrompt:"This is a Prompt", sChoice0:"Choice 1", sChoice1:"Choice 2", sChoice2:"Choice 3", nCorrect:"1"};
		currentActivity.addController(sType)
		
		var delay = new FrameDelay(currentActivity, currentActivity.init);
	}
	function createTemplate(sLinkage:String) {
		return this.mcClip.attachMovie(sLinkage, "mcActivityShell", 1);
	}
	function getActivity() {
		return currentActivity;
	}
	function clear() {
		
	}
}