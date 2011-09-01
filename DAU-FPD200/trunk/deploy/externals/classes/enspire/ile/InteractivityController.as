import org.asapframework.util.debug.Log;
import org.asapframework.util.ObjectUtils;
//
import mx.events.EventDispatcher;
//
import com.mosesSupposes.fuse.*;
//
import enspire.core.Server;
import enspire.core.SoundManager;
import enspire.display.ContentArea;
import enspire.display.BaseGui;
import enspire.display.Tooltip;
import enspire.ile.AppEvents;
import enspire.model.Configs;
import enspire.model.Labels;
import enspire.model.State;
import enspire.utils.ILE_utils;
import enspire.utils.TimeUtils
import enspire.utils.GarbageCollection;
import enspire.utils.ClipUtils;
import enspire.debug.JumpMenu;


import enspire.interactivity.events.*;
import enspire.interactivity.evaluation.*;


class enspire.ile.InteractivityController {
	// static var for sigleton implemetation
	private static var interactivity_controller:InteractivityController;

	public var mostRecentEvaluation:IEvaluation;
	
	// constructor and static helper functions
	private function InteractivityController() {
		
		//Server.connect(this, "update", AppEvents.START_SEG);
		Server.addController("interactivity", this);
		//Log.status("Interactivity Controller Created");
	}
	// 
	//  ---------------------------------------------------------------------------------------------------  //     
	//								constructor and static helper functions									 //
	//  ---------------------------------------------------------------------------------------------------  //	
	//
	public static function getInstance() {
		if(interactivity_controller == undefined) {
			return new InteractivityController();
		}
		return interactivity_controller;
	}

	
	public function startInteractivity() {
		//trace("starting Interactivity in controller");
		var gui = Server.getController("gui");
		var args = Server.model.args;
		var profileName = args["sProfile"];
		var profile = Configs.getProfile(profileName);
		var INTERACTIVITY_API = gui.getContainer("interactivity").getClip().API;
		INTERACTIVITY_API.createActivity(args["sActivityType"], args, profile, gui.getContainer("clipPlayer").getClip()["clip"]);
		
		if(profile["bGate"] == true) {
			Server.getController("gui").disableControl("next");
		}
	}
	
	public function resumeInteractivity() {

		var args = Server.model.args;
		var profileName = args["sProfile"];
		var profile = Configs.getProfile(profileName);
		var gui = Server.getController("gui");
		var interactivityController = Server.getController("interactivity");

		var correct = interactivityController.mostRecentEvaluation.getCorrect();
		var numTries = interactivityController.mostRecentEvaluation.getNumTries();
		
		var shouldResume = true;
		
		
		if(args["sActivityType"] == "MultSelect") {
			if(profile["sFeedbackType"] == "general") {
				shouldResume = false;
			} else {
				if(numTries < parseInt(profile["nTries"])) {
					if(parseInt(profile["nTries"]) != 0) {
						shouldResume = false;
					}
				}
			}
		}
		
		
		if(shouldResume) {
			Server["INTERACTIVITY_API"].resumeActivity();
		}
		
		
		if(correct) {
			gui.enableControl("next");
			if(args["sActivityType"] == "MultChoice") {
				if(profile["sFinish"] == "next") {
					Server.run("next");
				} 
				if(profile["sFinish"] == "pulse") {
					Server.getControl("next").pulse();
				}
			}
			if(args["sActivityType"] == "MultSelect" && profile["sFeedbackType"] == "general") {
				if(profile["sFinish"] == "next") {
					Server.run("next");
				} 
				if(profile["sFinish"] == "pulse") {
					Server.getControl("next").pulse();
				}
			}
			if(args["sActivityType"] == "Sorting") {
				if(profile["sFinish"] == "next") {
					Server.run("next");
				} 
				if(profile["sFinish"] == "pulse") {
					Server.getControl("next").pulse();
				}
			}
			if(args["sActivityType"] == "Sequencing") {
				if(profile["sFinish"] == "next") {
					Server.run("next");
				} 
				if(profile["sFinish"] == "pulse") {
					Server.getControl("next").pulse();
				}
			}
			if(args["sActivityType"] == "Dropdown") {
				if(profile["sFinish"] == "next") {
					Server.run("next");
				} 
				if(profile["sFinish"] == "pulse") {
					Server.getControl("next").pulse();
				}
			}
		} else {
			if(args["sActivityType"] == "MultChoice") {
				if(numTries >= parseInt(profile["nTries"])) {
					if(parseInt(profile["nTries"]) != 0) {
						if(profile["sFinish"] == "pulse") {
							Server.getControl("next").pulse();
							gui.enableControl("next");
						}
						if(profile["sFinish"] == "next") {
							Server.run("next");
						}
					}
				}
			}
			if(args["sActivityType"] == "MultSelect" && profile["sFeedbackType"] == "general") {
				if(numTries >= parseInt(profile["nTries"])) {
					if(parseInt(profile["nTries"]) != 0) {
						if(profile["sFinish"] == "pulse") {
							Server.getControl("next").pulse();
							gui.enableControl("next");
						}
						if(profile["sFinish"] == "next") {
							Server.run("next");
						}
					}
				}
			}
			if(args["sActivityType"] == "Sorting") {
				if(numTries >= parseInt(profile["nTries"])) {
					if(parseInt(profile["nTries"]) != 0) {
						if(profile["sFinish"] == "pulse") {
							Server.getControl("next").pulse();
							gui.enableControl("next");
						}
						if(profile["sFinish"] == "next") {
							Server.run("next");
						}
					}
				}
			}
			if(args["sActivityType"] == "Sequencing") {
				if(numTries >= parseInt(profile["nTries"])) {
					if(parseInt(profile["nTries"]) != 0) {
						if(profile["sFinish"] == "pulse") {
							Server.getControl("next").pulse();
							gui.enableControl("next");
						}
						if(profile["sFinish"] == "next") {
							Server.run("next");
						}
					}
				}
			}
			if(args["sActivityType"] == "Dropdown") {
				if(numTries >= parseInt(profile["nTries"])) {
					if(parseInt(profile["nTries"]) != 0) {
						if(profile["sFinish"] == "pulse") {
							Server.getControl("next").pulse();
							gui.enableControl("next");
						}
						if(profile["sFinish"] == "next") {
							Server.run("next");
						}
					}
				}
			}
		}
	}

	public function notifyInteractivityEvent(e:InteractivityEvent) {
		//trace("\n\n\nCAUGHT TOP LEVEL INTERACTIVITY EVENT");
		var args = Server.model.args;
		var profileName = args["sProfile"];
		var profile = Configs.getProfile(profileName);
		var gui = Server.getController("gui");
		
		//trace("INTERACTIVITY EVENT: \n\n\n");
		//ObjectUtils.traceObject(e);
		//trace("\n\n\nend INTERACTIVITY EVENT");
		
		if(e instanceof PopupEvent) {
			// check to see if we are branching and if so go on then
			
			
			if(profile["sFeedbackType"] == "branching") {
				Server.getController("app").startSegment(PopupEvent(e).getPopupText());
			}else{
			  Server.getController("templates").doAlert(profile["sPopupSkin"], 
				PopupEvent(e).getPopupText(), 
					PopupEvent(e).getButtonText(), 
						this.resumeInteractivity);
			  // 508 decide where to go
			  trace("CHECK FOR TRY AGIAN: "+PopupEvent(e).getButtonText().toLowerCase());
			  if(PopupEvent(e).getButtonText().toLowerCase() == "try again") {
			  	State.sAccGroup = "content"
			  }else{
				State.sAccGroup = "controls"
			  }
			}
		} 
		if(e instanceof ScoreEvent) {

			var evaluation = ScoreEvent(e).getEvaluation();
			mostRecentEvaluation = evaluation;
			if(profile["sFeedbackType"] == "none") {
				// if feedback should not be shown on this interactivity, we know we can continue
				Server.run("next");
			}
			
			if(args["sActivityType"] == "Hotspot") {
				if(evaluation.getCorrect()) {
					Server.getControl("next").pulse();
					gui.enableControl("next");
				}
			}
		}
	}
	
	
	public function toString() {
		return "enspire.ile.InteractivityController";
	}
}