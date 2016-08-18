package  com.laifeng.view.soundcontrol
{
	import com.laifeng.component.YButton;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.event.MEvent;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.controls.Notification;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class VolumePanel extends Sprite
	{
		
		public function VolumePanel()
		{
			super();
			
			init();
		}
		
		
		private function init():void{
			
			_btnDic[0] = new YButton(new FL_skin_btn_horn_0(),0);
			_btnDic[1] = new YButton(new FL_skin_btn_horn_2(),1);
			_btnDic[2] = new YButton(new FL_skin_btn_horn_1(),2);
			
			changeVolumeBtn(1);
			
			
			addChild(_track);
			_track.x = 30;
			_track.y = 5;
			
			addChild(_dot);
			
			_dot.x = _track.x+_track.width/2;
			_dot.y = _track.y+2;
			_track.addEventListener(MouseEvent.CLICK,clickTrackHandler);
			
			_dot.addEventListener(MouseEvent.MOUSE_DOWN,mouseDowHandler);
			_dot.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			_dot.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			_dot.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			
			_mouseRec = new Rectangle(_track.x,_track.y+2,_track.width,0);
			
		}
		
		public function changeVolumeBtn(index:int):void{
			
			if(_currBtn != null){
				if(this.contains(_currBtn)){
					_currBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
					removeChild(_currBtn);
				}
			}
			
			_currBtn = _btnDic[index];
			_currBtn.y =8
			addChild(_currBtn);
			
			_currBtn.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		
		private function  clickHandler(event:MouseEvent):void{
			var btnIndex:int = (event.target as YButton).index;
			if(btnIndex == 0){
				LiveConfig.currentVolume = 0.5;
				changeVolumeBtn(1);
				_dot.x = _track.x+_track.width/2;
				Notification.get.notify(new MEvent(NoticeKey.N_CHANGE_VOLUME,_currVolume));
			}else{
				LiveConfig.currentVolume = 0;
				changeVolumeBtn(0);
				_dot.x = _track.x;
				Notification.get.notify(new MEvent(NoticeKey.N_CHANGE_VOLUME,_currVolume));
			}
		}
		
		
		private function clickTrackHandler(event:MouseEvent):void{
			
		}
		
		
		private function mouseDowHandler(event:MouseEvent):void{
			_isMouseDown = true;
			_dot.startDrag(true,_mouseRec);
		}
		
		private function mouseUpHandler(event:MouseEvent):void{
			_isMouseDown = false;
			_dot.stopDrag();
		}
		
		
		private function mouseOutHandler(event:MouseEvent):void{
			
			mouseUpHandler(null);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void{
			if(!_isMouseDown){
				return;
			}
			
			_currVolume = _dot.x/100;
			
			_volumeLevel = _currVolume>0.5? 2:_currVolume<=0.3? 0:1;
			if(_currBtn.index != _volumeLevel){
				changeVolumeBtn(_volumeLevel);
			}
			
			if(_currVolume <=0.3){
				_currVolume = 0;
			}
			LiveConfig.currentVolume = _currVolume;
			Notification.get.notify(new MEvent(NoticeKey.N_CHANGE_VOLUME,_currVolume));
		}
		
		
		
		private var _currBtn:YButton;
		
		private var _btnDic:Dictionary = new Dictionary();
		private var _track:FL_skin_volume_bar = new FL_skin_volume_bar();
		private var _dot:YButton = new YButton(new FL_skin_btn_circle());
		private var _mouseRec:Rectangle;
		private var _volumeLevel:int = 0;	
		private var _currVolume:Number = 0;
		private var _isMouseDown:Boolean = false;
		
		
		
	}
}