dynamic class enspire.model.State{
	public static var startTime:Date;
	public static var bAudio:Boolean;
	public static var bHasAudio:Boolean;
	public static var bFinal:Boolean;
	public static var bAccessible:Boolean;
	public static var bIFT:Boolean;
	public static var bFirstSeg:Boolean;
	public static var bFirstSegInClip:Boolean;
	public static var bLastSeg:Boolean;
	public static var sRelease:String;
	// utils
	public static var nChapter:Number;
	public static var nSection:Number;
	public static var nClip:Number;
	public static var nSegment:Number;
	
	public static var sChapterId:String;
	public static var sSectionId:String;
	public static var sClipId:String;
	public static var sSegmentId:String;

	public static var nTotalChapters:Number;
	public static var nTotalSections:Number;
	public static var nTotalClips:Number;
	public static var nTotalSegments:Number;
	
	public static var bInteractive:Boolean = false;
	public static var bMute:Boolean;
	public static var bAutoplay:Boolean;
	public static var bEndedAudio:Boolean;
	public static var bEndedSeg:Boolean;
	public static var bBranching:Boolean;
	public static var bPaused:Boolean;
	public static var bCourseEnd:Boolean;
	public static var bCourseCompleted:Boolean;
}