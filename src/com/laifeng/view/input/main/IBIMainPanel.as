package com.laifeng.view.input.main
{
	import com.laifeng.view.input.LanguageMark;
	import com.laifeng.view.input.LocationCaret;
	
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	
	public interface IBIMainPanel extends IEventDispatcher
	{
		function open():void;
		
		function close():void;
		
		function reset():void;
		
		function sendChatMsg(msg:String):void;
		
		function sendChatSucc():void;
		
		function countCharNum():void;
		
		function hidePlaceholders():void;
		
		function showPlaceholders():void;
		
		function get input():TextField;
		
		function get langMark():LanguageMark;
		
		function get caret():LocationCaret;
		
		function get topY():int;
		
		function get imeY():int;
		
		function get panelName():String;
		
		function get inputMiddleX():int;
		
	}
}