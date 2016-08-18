package  com.laifeng.interfaces
{
	/**********************************************************
	 * IUI
	 * 
	 * Author : mj
	 * Description:
	 * 			UI 接口
	 *  		所有 UI   必须实现此接口
	 ***********************************************************/
	public interface IUI
	{
		
		function open():void;
		function close():void;
		function updata():void;
		function screenChange(w:int,h:int):void;
		function get level():int;
		function set uiState(value:String):void;
		function get uiState():String;
		function destroy():void;
		
	}
}