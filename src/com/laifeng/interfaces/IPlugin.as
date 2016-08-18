package  com.laifeng.interfaces
{
	/**
	 * 插件接口
	 */
	public interface IPlugin
	{
		/**参数*/
		function set param(value:Object):void;
		/**启动*/
		function start(callback:Function):void;
		function end():void;
		/**更新 */
		function screenChange(w:int,h:int):void;
		/**销毁*/
		function destroy():void;
		
	}
}