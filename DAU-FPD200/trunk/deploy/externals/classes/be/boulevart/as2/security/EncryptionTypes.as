
class be.boulevart.as2.security.EncryptionTypes
{
	private static var _Base8:Object = com.meychi.ascrypt.Base8;
	private static var _Base64:Object = com.meychi.ascrypt.Base64;
	private static var _SHA1:Object = com.meychi.ascrypt.SHA1;
	private static var _MD5:Object = com.meychi.ascrypt.MD5;
	private static var _RC4:Object = com.meychi.ascrypt.RC4;
	private static var _Rijndael:Object = com.meychi.ascrypt.Rijndael;
	private static var _TEA:Object = com.meychi.ascrypt.TEA;
	private static var _GUID:Object = com.meychi.ascrypt.GUID;
	private static var _LZW:Object = com.meychi.ascrypt.LZW;
	private static var _ROT13:Object = com.meychi.ascrypt.ROT13;
	private static var _Goauld:Object = com.meychi.ascrypt.Goauld;
	
	public function EncryptionTypes()
	{
		_Base8 = Base8();
		_Base64 = Base64();
		_SHA1 = SHA1();
		_MD5 = MD5();
		_RC4 = RC4();
		_Rijndael = Rijndael();
		_TEA = TEA();
		_GUID = GUID();
		_LZW = LZW();
		_ROT13 = ROT13();
		_Goauld = Goauld();
	}
	
	public static function Base8():Object
	{
		return _Base8;
	}
	
	public static function Base64():Object
	{
		return _Base64;
	}
	
	public static function SHA1():Object
	{
		return _SHA1;
	}
	
	public static function MD5():Object
	{
		return _MD5;
	}
	
	public static function RC4():Object
	{
		return _RC4;
	}
	
	public static function Rijndael():Object
	{
		return _Rijndael;
	}
	
	public static function TEA():Object
	{
		return _TEA;
	}
	
	public static function GUID():Object
	{
		return _GUID;
	}
	
	public static function Goauld():Object
	{
		return _Goauld;
	}
	
	public static function LZW():Object
	{
		return _LZW;
	}
	
	public static function ROT13():Object
	{
		return _ROT13;
	}
}
