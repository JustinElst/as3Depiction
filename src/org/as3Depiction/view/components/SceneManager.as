package org.as3Depiction.view.components{
	import adobe.utils.CustomActions;
	import flash.events.Event;
	import nl.demonsters.debugger.MonsterDebugger;
	import org.as3Depiction.interfaces.IDispose;
	import org.as3Depiction.model.vo.*;
	import mx.controls.Image;
	import org.as3Depiction.view.components.scene.back.BackEvent;
	import org.as3Depiction.view.components.scene.BackRenderer;
	import org.as3Depiction.view.components.scene.item.ItemEvent;
	import org.as3Depiction.view.components.scene.ItemRenderer;
	import spark.core.SpriteVisualElement;
	
	public class SceneManager extends SpriteVisualElement implements IDispose
	{
		
		private var _back:BackRenderer;
		private var _items:ItemRenderer;
		private var _nextSceneVo:SceneVo;
		private var _firstLoad:Boolean = true;
		private var _loadet:Array;
		public static const CHANGE_SCENE_COMPLETE:String = "changeSceneComplete";
		
		public function SceneManager()
		{
			_back = new BackRenderer();
			addChild(_back.displayContainer);
			_items = new ItemRenderer();
			addChild(_items.displayContainer);
			_loadet = new Array();
		}
		
		/**
		 * here the scene build start, if it is the first build do not attempt to animate the previous scene.
		 * @param	scene the scene vo that was send by the scene mediator (origin: sceneProxy)
		 */
		public function changeScene(scene: SceneVo):void
		{
			_nextSceneVo = scene;
			_back.buildTransition(_nextSceneVo);
			items.addEventListener(ItemEvent.ANIMATE_OUT_COMPLETE, onItemsAnimateOut);
			items.animateOut();
		}
		
		/**
		 * if the item out animations are complete build the new scene 
		 * @param	e
		 */
		private function onItemsAnimateOut(e:Event):void 
		{
			removeChild(_items.displayContainer);
			_items.dispose();
			addChild(_items.displayContainer);
			_back.startTransition();
			_back.addEventListener(BackEvent.LOAD_COMPLETE, loadItems);
			_back.addEventListener(BackEvent.TRANSITION_COMPLETE, onBackTransitionComplete);
			
		}
		
		private function onBackTransitionComplete(e:Event):void 
		{
			_items.addItemsToStage();
			_items.animateIn();
			dispatchEvent(new Event(CHANGE_SCENE_COMPLETE));
			_items.addEventListener(ItemEvent.ANIMATE_IN_COMPLETE, onItemsLoad);
		}
		
		public function loadItems(e:Event):void
		{
			_items.addItems(_nextSceneVo.items);
			_items.addEventListener(ItemEvent.LOAD_COMPLETE, onItemsLoad);
		}
		/**
		 * gets triggered when the item assets are all loaded. and when the animation in for each of the items is complete
		 * @param	items the vo's for the new items
		 */
		private function onItemsLoad(e:Event):void 
		{
			if (e.type == ItemEvent.LOAD_COMPLETE)
			{
				_items.removeEventListener(ItemEvent.LOAD_COMPLETE, onItemsLoad);
			}
			else 
			{
				dispatchEvent(new Event(ItemEvent.ANIMATE_IN_COMPLETE));
			}
			
		}
		
		public function dispose():void
		{
			_back.dispose();
			_items.dispose();
			var i:int = numChildren;
			while( i -- )
			{
				removeChildAt(i);
			}
		}
		
		/**
		* Getters and Setters
		*/
		public function get items():ItemRenderer { return _items; }
		public function set items(newValue:ItemRenderer):void
		{
			_items = newValue;
		}
		
	}//Endclass 

}//Endpackage

