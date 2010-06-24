package org.as3Depiction.view.components.scene{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import org.as3Depiction.model.vo.ItemVo;
	import org.as3Depiction.view.components.scene.item.Item;
	import org.as3Depiction.view.components.scene.item.ItemEvent;
	import org.as3Depiction.view.components.scene.transition.*;
	import org.as3Depiction.interfaces.IDispose;
	
	public class ItemRenderer extends EventDispatcher implements IDispose
	{
		
		private var _items:Array;
		private var _displayContainer:Sprite;
		private var _itemsLoadet:Boolean;
		private var _tempCount:uint;
		private var _animating:Boolean = true;
		
		public function ItemRenderer()
		{
			_items = new Array();
			_displayContainer = new Sprite();
		}
		/**
		 * add multiple items 
		 * @param	items
		 */
		public function addItems(items: Vector.<ItemVo>):void
		{
			for each(var itemVo:ItemVo in items)
			{
				addItem(itemVo);
			}
			trace('add items')
		}
		
		/**
		 * add new item to the items and listen for it to complete the load
		 * @param	itemVo 
		 */
		public function addItem(itemVo: ItemVo):void
		{
			_tempCount = 1;
			var item:Item = new Item();
			item.init(itemVo);
			item.addEventListener(ItemEvent.LOAD_COMPLETE, onItemLoadComplete);
			_items.push(item); 
			item.x = itemVo.position.x;
			item.y = itemVo.position.y;
			_itemsLoadet = false;
		}
		
		/**
		 * count the loadet items, if all items are loadet dispatch the complete event for the scene manager
		 * @param	e
		 */
		private function onItemLoadComplete(e:Event):void 
		{
			if (_tempCount < _items.length)
			{
				_tempCount++;
			}
			else
			{
				_itemsLoadet = true;
				dispatchEvent(new ItemEvent(ItemEvent.LOAD_COMPLETE,0));
			}
		}
		
		public function addItemsToStage():void
		{
			for each(var tItem:Item in _items)
			{
				tItem.addEventListener(ItemEvent.CLICK, onItemEvent);
				tItem.addEventListener(ItemEvent.MOUSE_OUT, onItemEvent);
				tItem.addEventListener(ItemEvent.MOUSE_OVER, onItemEvent);
				tItem.addEventListener(ItemEvent.MOUSE_MOVE, onItemEvent);
				_displayContainer.addChild(tItem);
			}
		}
		
		/**
		 * handles all mouse events from the items.
		 * @param	e item type is used to determain the type of event.
		 */
		private function onItemEvent(e:MouseEvent):void 
		{
			var item:Item = e.currentTarget as Item;
			if (e.type == ItemEvent.CLICK)
			{
				//dispatch event for the scene manager
				dispatchEvent(new ItemEvent(ItemEvent.CLICK, item.id));
			}
			else if (e.type == ItemEvent.MOUSE_MOVE)
			{
				//check if the items underneath this item are also hit by the mouse
				for each(var tItem:Item in _items)
				{
					if (_animating == false)
					{
						tItem.onMouseMove(e, true);
					}
					
				}
			}
			else if (e.type == ItemEvent.MOUSE_OVER)
			{
				//dispatch event for the scene manager
				dispatchEvent(new ItemEvent(ItemEvent.MOUSE_OVER, item.id));
			}
			else if (e.type == ItemEvent.MOUSE_OUT)
			{
				//dispatch event for the scene manager
				dispatchEvent(new ItemEvent(ItemEvent.MOUSE_OUT, item.id));
			}
		}
		
		/**
		 * do the animation in for each item.
		 */
		public function animateIn():void
		{
			_animating = true;
			_tempCount = 1;
			if (_items[0])
			{
				var item:Item = _items[0] as Item;
				item.addEventListener(ItemEvent.ANIMATE_IN_COMPLETE, animateInComplete);
				item.animateIn();
			}
			else
			{
				_animating = false;
				dispatchEvent(new Event(ItemEvent.ANIMATE_IN_COMPLETE));
			}
		}
		/**
		 * go to the next aniation in 
		 * if all animations are done dispath event for the scene manager
		 */
		public function animateInComplete(e:Event):void
		{
			
			var item:Item = _items[_tempCount - 1] as Item;
			item.removeEventListener(ItemEvent.ANIMATE_IN_COMPLETE, animateInComplete)
			if (_tempCount < _items.length)
			{
				item = _items[_tempCount] as Item;
				item.addEventListener(ItemEvent.ANIMATE_IN_COMPLETE, animateInComplete);
				item.animateIn();
				_tempCount++;
			}
			else
			{
				_animating = false;
				dispatchEvent(new Event(ItemEvent.ANIMATE_IN_COMPLETE));
				
			}
			
		}
		
		/**
		 * do the animation Out for each item.
		 */
		public function animateOut():void
		{
			_animating = true;
			_tempCount = 1;
			if (_items[0])
			{
				var item:Item = _items[0] as Item;
				item.addEventListener(ItemEvent.ANIMATE_OUT_COMPLETE, animateOutComplete);
				item.animateOut();
			}
			else
			{
				_animating = false;
				dispatchEvent(new Event(ItemEvent.ANIMATE_OUT_COMPLETE));
			}
		}
		/**
		 * go to the next aniation Out 
		 * if all animations are done dispath event for the scene manager
		 */
		public function animateOutComplete(e:Event):void
		{
			var item:Item = _items[_tempCount - 1] as Item;
			item.removeEventListener(ItemEvent.ANIMATE_OUT_COMPLETE, animateOutComplete)
			if (_tempCount < _items.length)
			{
				item = _items[_tempCount] as Item;
				item.addEventListener(ItemEvent.ANIMATE_OUT_COMPLETE, animateOutComplete);
				item.animateOut();
				_tempCount++;
			}
			else
			{
				_animating = false;
				dispatchEvent(new Event(ItemEvent.ANIMATE_OUT_COMPLETE));
			}
			
		}
		
		public function dispose():void
		{
			for each(var item:Item in _items)
			{
				item.dispose();
			}
			_items = null;
			_items = new Array();
			var i:int = _displayContainer.numChildren;
			while( i -- )
			{
				_displayContainer.removeChildAt(i);
			}
			_displayContainer = null;
			_displayContainer = new Sprite();
		}
		
		/**
		* Getters and Setters
		*/
		public function get items():Array { return _items; }
		public function set items(newValue:Array):void
		{
			_items = newValue;
		}
		public function get displayContainer():Sprite { return _displayContainer; }
		public function set displayContainer(newValue:Sprite):void
		{
			_displayContainer = newValue;
		}
		
		public function get itemsLoadet():Boolean { return _itemsLoadet; }
		
	}//Endclass 

}//Endpackage

