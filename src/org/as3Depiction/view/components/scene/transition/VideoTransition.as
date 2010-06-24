package org.as3Depiction.view.components.scene.transition 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import mx.rpc.soap.LoadEvent;
	import nl.demonsters.debugger.MonsterDebugger;
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.view.components.scene.BackRenderer;
	/**
	 * ...
	 * @author 
	 */
	public class VideoTransition implements IBackTransition
	{
		private var _backRenderer:BackRenderer;
		private var _transitionPath:PathVo;
		private var _backLoadet:Boolean = false;
		private var _backLoading:Boolean = false;
		private var _bufferFull :Boolean = false;
		private var _videoloadComplete:Boolean = false;
		private var _startTransit:Boolean = false;
		private var _videoComplete:Boolean = false;
		private var _video:Video;
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _duration:Number = 999;
		
		public function VideoTransition() 
		{
			
		}
		
		public function metaDataHandler(infoObject:Object):void 
		{
			_duration = infoObject.duration;
		}
		
		public function netStatusHandler(e:NetStatusEvent):void
		{
			switch (e.info.code) 
			{
				case "NetStream.Play.Stop":
					if (_duration != 999 && (_duration == _ns.time || _duration < _ns.time))
					{
						_videoComplete = true;
						transitionToNewBack();
					}
				break;
				case "NetStream.Buffer.Full" :
					_bufferFull  = true;
				break;
			}		
		}

		public function prepare(backRenderer:BackRenderer, transitionPath:PathVo):void
		{
			_backRenderer = backRenderer;
			_transitionPath = transitionPath;
			
			var customClient:Object = new Object();
			customClient.onMetaData = metaDataHandler;
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_nc.connect(null);
			
			_ns = new NetStream(_nc);
			_ns.client = customClient;
			_video = new Video(800, 600);
			_video.name = "TransVid";
			_backRenderer.displayContainer.addEventListener(Event.ENTER_FRAME, onEnterframe);
			
			_video.attachNetStream(_ns);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_ns.play(_transitionPath.source);
			_ns.pause();
			_ns.seek(0);
		}
		
		private function onEnterframe(e:Event):void
		{
			if (((_ns.bytesLoaded / _ns.bytesTotal) * 100) >= 60 && _videoloadComplete != true)
			{
				_videoloadComplete = true;
				beginTransition();
			}
			if (((_ns.bytesLoaded / _ns.bytesTotal) * 100) >= 100)
			{
				if (_backLoading == false)
				{
					_backRenderer.displayContainer.removeEventListener(Event.ENTER_FRAME, onEnterframe);
					_backLoading = true;
					_backRenderer.loadNextBack();
				}
			}
		}
		public function startTransition():void
		{
			_startTransit = true;
			beginTransition();
		}
		private function beginTransition():void
		{
			if (_startTransit == true && _videoloadComplete == true)
			{	
				_ns.seek(0);
				_backRenderer.displayContainer.addChildAt(_video,0);
				_startTransit = false;
				
				TweenLite.to(_backRenderer.curBack, 0.5, { alpha:0, onComplete:startVid ,ease:Quad.easeIn } );
			}
		}
		private function startVid():void
		{
			_ns.resume();
		}
		
		public function backLoaded():void
		{
			_backLoadet = true;
			transitionToNewBack();
			
		}
		private function transitionToNewBack():void
		{
			if (_backLoadet == true && _videoComplete == true)
			{
				_backRenderer.nextBack.alpha = 0;
				_backRenderer.displayContainer.addChild(_backRenderer.nextBack);
				TweenLite.to(_backRenderer.nextBack, 0.5, { alpha:1,ease:Cubic.easeOut, onComplete:transitionComplete } );
			}
		}
		
		private function transitionComplete():void
		{
			_backRenderer.transitionComplete();
		}
	}

}