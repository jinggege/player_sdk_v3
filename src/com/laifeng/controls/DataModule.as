package com.laifeng.controls
{
	import com.laifeng.config.ModuleKey;
	import com.laifeng.interfaces.IDataModule;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class DataModule extends EventDispatcher
	{
		
		public function DataModule()
		{
			super();
			if(_instance != null){
				throw(new Event("DataModule 为单例,不可构造!"));
			}
		}
		
		
		public function init():void{
			_moduleDic = new Dictionary();
			
			/**注册 report 数据模块*/
			registerModule(ModuleKey.DM_REPORT,new DMReport());
			registerModule(ModuleKey.DM_LIVECORE,new DMCenter() )
			
			start();
		}
		
		
		public function registerModule(key:String,module:IDataModule):void{
			_moduleDic[key] = module;
		}
		
		
		private function start():void{
			for(var key:String  in  _moduleDic){
				_moduleDic[key].start();
			}
		}
		
		
		public function getModule(moduleKey:String):IDataModule{
			return _moduleDic[moduleKey];
		}
		
		
		public static function get get():DataModule{
			_instance = _instance==null? new DataModule() : _instance;
			return _instance;
		}
		
		private static var _instance:DataModule = null;
		private var _moduleDic:Dictionary;
		
		
	}
}