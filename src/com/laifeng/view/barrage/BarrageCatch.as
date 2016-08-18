package com.laifeng.view.barrage
{
	import flash.utils.Dictionary;

	public class BarrageCatch
	{
		public function BarrageCatch()
		{
		}
		
		
		
		public function isEmpty(index:int):Boolean{
			
			if(_dic[index] != null){
				return Boolean(_dic[index].length);
			}
			
			return true;
		}
		
		
		
		public function add(index:int,item:IBarrage):void{
			
			if(_dic[index] == null){
				_dic[index] = new Vector.<IBarrage>();
			}
			
			_dic[index].push(item);
		}
		
		
		public function removeAll():void{
			var list:Vector.<IBarrage> =null;
			for(var key:String in _dic){
					list = _dic[key];
					if(list== null) break;
					for(var i:int=0; i<list.length; i++){
						if(list[i] != null){
							list[i].destroy();
						}
						list[i] = null;
						list.splice(i,1);
					}
					list = null;
					delete _dic[key];
			}
		}
		
		
		
		public function getVec(index:int):Vector.<IBarrage>{
			return _dic[index];
		}
		
		
		public function getVecLength(index:int):int{
			
			if(_dic[index] == null) return 0;
			
			return _dic[index].length;
		}
		
		
		
		public function getLastItem(index:int):IBarrage{
			var vec:Vector.<IBarrage> = _dic[index];
			return vec[vec.length-1];
		}
		
		
		public function getRootDataList():Dictionary{
			return _dic;
		}
		
		
		
		private var _dic:Dictionary =  new Dictionary();
		
	}
}