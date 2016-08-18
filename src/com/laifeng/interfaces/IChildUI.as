package  com.laifeng.interfaces
{
	/**********************************************************
	 * IChildUI
	 * 
	 * Author : mj
	 * Description:
	 * 			video接口
	 *  		子面板必须实现此接口
	 ***********************************************************/
	
	public interface IChildUI
	{
		function changeScreen(w:int,h:int):void;
		function open():void;
		function close():void;
	}
}