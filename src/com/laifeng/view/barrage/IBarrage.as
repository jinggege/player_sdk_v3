package com.laifeng.view.barrage
{
	import flash.geom.Point;
	import flash.text.TextFormat;

	public interface IBarrage
	{
		
		function setInfo(info:Object):void;
		
		function setXY(offX:int,offY:int):void;
		
		function get xy():Point;
		
		function get w():int;
		function get h():int;
		
		/**弹幕类型*/
		function get BarrageType():int;
		
		function updata():void;
		
		/**设置弹幕字体大小*/
		function set setFontSize(size:int):void;
		
		/**#FFFFFF*/
		function set setFontColor(color:String):void;
		
		/**弹幕状态:0:死亡   1：暂停   2：运行中 */
		function get status():String;
		function set status(value:String):void;
		/**暂停时间*/
		function get pauseTime():int;
		function set pauseTime(value:int):void;
		
		function get isUp():Boolean;
		function set isUp(value:Boolean):void;
		
		function destroy():void;
		
		
		
		
	}
}