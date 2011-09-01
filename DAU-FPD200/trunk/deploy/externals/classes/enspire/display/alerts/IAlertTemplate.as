interface enspire.display.alerts.IAlertTemplate{
	public function setText(sText:String);
	public function addButton(sButtonText:String, fCallback:Function);
}