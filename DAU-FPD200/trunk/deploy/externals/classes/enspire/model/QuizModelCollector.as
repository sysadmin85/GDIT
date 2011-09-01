import enspire.model.structure.SegmentData;
//INTEGRATE import enspire.interactivity.QuizManager;
import org.asapframework.util.debug.Log;
import enspire.model.QuizData;
import enspire.model.ModelCollector;

class enspire.model.QuizModelCollector extends ModelCollector{
	
	function collect(oSeg:SegmentData) {
		if(oSeg.args["nQuiz"] == undefined) {
			return;
		}
		var aIds = oSeg.args["nQuiz"].split("_");
		var nQuiz:Number = parseInt(aIds[0]);
		//INTEGRATE var quiz:QuizData = QuizManager.getQuiz(nQuiz);
		
		/* INTEGRATE
		if(!quiz instanceof QuizData) {
			//Log.error("Quiz in is NaN - arg: "+oSeg.args["nQuiz"], this.toString());
			return;
		}
		
		if(nQuiz == 0) {
			quiz.sTitle = oSeg.args["sQuizTitle"];
		}
		oSeg.args.bQuiz = true;
		oSeg.args.oQuizData = quiz.addItem(parseInt(aIds[1]));
		*/
		var nValue = parseInt(oSeg.args["nPointValue"]);
		oSeg.args.oQuizData.nPointValue = isNaN(nValue) ? 1 : nValue;
		
		//Log.debug("Quiz "+aIds[0]+" question "+aIds[1]+"  collected " , this.toString());
	}
	function toString() {
		return "enspire.model.QuizModelCollector";
	}
}
