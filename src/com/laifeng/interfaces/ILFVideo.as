package  com.laifeng.interfaces
{
	import flash.net.NetStream;

	/**********************************************************
	 * ILFVideo
	 * 
	 * Author : mj
	 * Description:
	 * 			video接口
	 *  		httpvideo   rtmpvideo  p2pvideo  必须实现此接口
	 ***********************************************************/
	
	public interface ILFVideo
	{
		
		function init(callback:Function):void;
		function play(url:String):void;
		function setWH(w:int,h:int):void;
		function get ns():NetStream;
	}
}