package org.as3Depiction.view.components.scene.item{
	import flash.events.Event;

	
	public class ItemEvent extends Event
	{
		
		public static const CLICK:String =  'itemClick';
		public static const MOUSE_OVER:String =  'itemMouseOver';
		public static const MOUSE_MOVE:String =  'itemMouseMove';
		public static const MOUSE_OUT:String =  'itemMouseOut';
		public static const ANIMATE_OUT_COMPLETE:String = 'itemAnimateOutComplete';
		public static const ANIMATE_IN_COMPLETE:String = 'itemAnimateInComplete';
		public static const LOAD_COMPLETE:String = 'itemsLoadComplete';
		private var _itemId:uint;
		
		
		public function ItemEvent(type: String,itemId: uint,bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			_itemId = itemId;
		}
		
		/**
		* Getters and Setters
		*/
		public function get itemId():* { return _itemId; }
		public function set itemId(newValue:*):void
		{
			_itemId = newValue;
		}
		
	}//Endclass 

}//Endpackage

