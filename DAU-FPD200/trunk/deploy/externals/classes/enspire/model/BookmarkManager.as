import org.asapframework.util.ArrayUtils; 
class enspire.model.BookmarkManager{
	private static var aBookmarks:Array = new Array();
	public static function addBookmark(segData:SegmentData) {
		if(ArrayUtils.findElement(aBookmarks, segData) == -1) {
			return;
		}
		this.aBookmarks.push(segData)
	}
	public static function removeBookmark(segData:SegmentData) {
		ArrayUtils.removeElement(aBookmarks, segData)
	}
	public static function getAllBookmarks() {
		return aBookmarks;
	}
}