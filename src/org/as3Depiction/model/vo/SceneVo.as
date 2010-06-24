package org.as3Depiction.model.vo{

	
	public class SceneVo 
	{
		
		private var _id:uint;
		private var _title:String;
		private var _backUrl:String;
		private var _items:Vector.<ItemVo>;
		private var _paths:Vector.<PathVo>;
		private var _transitionPath:PathVo;
		private var _other:Array;
		private var _itemImgFolder:String;
		private var _pathAssetsFolder:String;
		
		
		/**
		* Getters and Setters
		*/
		public function get id():uint { return _id; }
		public function set id(newValue:uint):void
		{
			_id = newValue;
		}
		public function get title():String { return _title; }
		public function set title(newValue:String):void
		{
			_title = newValue;
		}
		public function get backUrl():String { return _backUrl; }
		public function set backUrl(newValue:String):void
		{
			_backUrl = newValue;
		}
		public function get items():Vector.<ItemVo> { return _items; }
		public function set items(newValue:Vector.<ItemVo>):void
		{
			_items = newValue;
		}
		public function get paths():Vector.<PathVo> { return _paths; }
		public function set paths(newValue:Vector.<PathVo>):void
		{
			_paths = newValue;
		}
		public function get other():Array { return _other; }
		public function set other(newValue:Array):void
		{
			_other = newValue;
		}
		public function get itemImgFolder():String { return _itemImgFolder; }
		public function set itemImgFolder(value:String):void 
		{
			_itemImgFolder = value;
		}
		
		public function get transitionPath():PathVo { return _transitionPath; }
		
		public function set transitionPath(value:PathVo):void 
		{
			_transitionPath = value;
		}
		
		public function get pathAssetsFolder():String { return _pathAssetsFolder; }
		
		public function set pathAssetsFolder(value:String):void 
		{
			_pathAssetsFolder = value;
		}
		
	}//Endclass 

}//Endpackage

