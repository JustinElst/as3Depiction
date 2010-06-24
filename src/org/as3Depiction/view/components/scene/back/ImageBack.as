package org.as3Depiction.view.components.scene.back 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import org.as3Depiction.model.vo.SceneVo;
	import mx.controls.Alert;
	/**
	 * ...
	 * @author ...
	 */
	public class ImageBack extends Back implements IBack
	{
		private var _imgLoader:Loader;
		private var _isLoadet:Boolean = false;
		
		public function ImageBack() 
		{
		}
		
		override public function load(scene:SceneVo):void
		{
			dispatchEvent(new Event(BackEvent.LOAD_STARTED));
			var urlRequest:URLRequest = new URLRequest(scene.backUrl);
			_imgLoader = new Loader();
			_imgLoader.load(urlRequest);
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		}
		
		/**
		* dispatched event complete for the scene manager 
		*/
		private function onLoadComplete(e: Event):void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			this.addChild(_imgLoader.content);
			_imgLoader = null;
			_isLoadet = true;
			dispatchEvent(new Event(BackEvent.LOAD_COMPLETE));
		}
		
		/**
		* dispatched event complete for the scene manager 
		*/
		private function onLoadError(e:IOErrorEvent):void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			Alert.show("Loading the back image of this scene has failed, please contact the admin. ", "Loading failed");
			dispatchEvent(new Event(BackEvent.LOAD_COMPLETE));
		}
		
	}

}