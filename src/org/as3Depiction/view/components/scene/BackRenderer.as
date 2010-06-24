package org.as3Depiction.view.components.scene{
	import flash.accessibility.Accessibility;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ObjectInput;
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.model.vo.SceneVo;
	import org.as3Depiction.view.components.scene.back.*;
	import org.as3Depiction.view.components.scene.transition.*;
	import org.as3Depiction.view.components.scene.transition.VideoTransition;
	import org.as3Depiction.view.components.scene.transition.CrossFade;
	import mx.controls.Alert;
	import mx.controls.Image;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.as3Depiction.interfaces.IDispose;
	import nl.demonsters.debugger.MonsterDebugger;
	import flash.utils.getDefinitionByName;
	
	public class BackRenderer extends EventDispatcher implements IDispose
	{
		private var _curBack:Back;
		private var _nextBack:Back;
		private var _nextScene:SceneVo;
		private var _transition:IBackTransition;
		private var _displayContainer:Sprite;
		
		public function BackRenderer()
		{
			_displayContainer = new Sprite();
			_curBack = new Back();
			_transition = new VideoTransition() as IBackTransition;
			_transition = new CrossFade() as IBackTransition;
			_transition = null;
			_displayContainer.addChild(_curBack);
		}
		
		public function buildTransition(scene:SceneVo):void
		{
			var i:int = _displayContainer.numChildren;
			while( i -- )
			{
				if(_displayContainer.getChildAt(i) != _curBack)
				{
					_displayContainer.removeChildAt(i);
				}
			}
			MonsterDebugger.trace(this, scene.transitionPath);
			if (scene.transitionPath != null)
			{
				var c:Class =  getDefinitionByName('org.as3scene.view.components.scene.transition.'+scene.transitionPath.type) as Class;
				_transition = new c() as IBackTransition;
				_nextScene = scene;
				_transition.prepare(this, scene.transitionPath);
			}
			else
			{
				_transition = new CrossFade() as IBackTransition;
				_nextScene = scene;
				_transition.prepare(this, scene.transitionPath);
			}
		}
		
		public function startTransition():void
		{
			_transition.startTransition();
		}
		
		public function dispose():void
		{
			
		}
		
		public function get displayContainer():Sprite { return _displayContainer; }
		
		
		public function loadNextBack():void 
		{
			_nextBack = new ImageBack();
			_nextBack.load(_nextScene);
			_nextBack.addEventListener(BackEvent.LOAD_COMPLETE, onNextBackLoadComplete);
			
		}
		
		public function get nextBack():Back
		{
			return _nextBack;
		}
		
		public function get curBack():Back { return _curBack; }
		
		private function onNextBackLoadComplete(e:Event):void 
		{
			_transition.backLoaded();
			dispatchEvent(new Event(BackEvent.LOAD_COMPLETE));
		}
		
		public function transitionComplete():void
		{
			var i:int = _displayContainer.numChildren;
			while( i -- )
			{
				if(_displayContainer.getChildAt(i) != _nextBack)
				{
					_displayContainer.removeChildAt(i);
				}
			}
			_nextBack.alpha = 1;
			_curBack = null;
			_curBack = _nextBack;
			dispatchEvent(new Event(BackEvent.TRANSITION_COMPLETE));
		}
	}//Endclass 

}//Endpackage

