package org.as3Depiction.model.vo{
	import flash.geom.Point;

	
	public class ItemVo 
	{
		
		private var _id:uint;
		/**
		* class path
		*/
		private var _className:String;
		private var _position:Point;
		private var _scale:Point;
		private var _title:String;
		private var _action:ActionVo;
		private var _assetsPath:String;
		
		public function ItemVo()
		{
			_className = "Item";
			_position = new Point(0, 0);
			_scale = new Point(0, 0);
			_title = "Item";
			_assetsPath = "images/default/itemImg/";
			_action= new ActionVo();
		}
		
		/**
		* Getters and Setters
		*/
		public function get id():uint { return _id; }
		public function set id(newValue:uint):void
		{
			_id = newValue;
		}
		public function get className():String { return _className; }
		public function set className(newValue:String):void
		{
			_className = newValue;
		}
		public function get position():Point { return _position; }
		public function set position(newValue:Point):void
		{
			_position = newValue;
		}
		public function get scale():Point { return _scale; }
		public function set scale(newValue:Point):void
		{
			_scale = newValue;
		}
		public function get title():String { return _title; }
		public function set title(newValue:String):void
		{
			_title = newValue;
		}
		public function get action():ActionVo { return _action; }
		public function set action(newValue:ActionVo):void
		{
			_action = newValue;
		}
		public function get assetsPath():String { return _assetsPath; }
		public function set assetsPath(value:String):void 
		{
			_assetsPath = value;
		}
		
	}//Endclass 

}//Endpackage

