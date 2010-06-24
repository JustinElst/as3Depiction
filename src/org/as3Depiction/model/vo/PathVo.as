package org.as3Depiction.model.vo{

	
	public class PathVo 
	{
		private var _id:uint;
		private var _to:uint;
		private var _type:String;
		private var _source:String;
		
		
		
		/**
		* Getters and Setters
		*/
		public function get id():uint { return _id; }
		public function set id(newValue:uint):void
		{
			_id = newValue;
		}
		public function get to():uint { return _to; }
		public function set to(newValue:uint):void
		{
			_to = newValue;
		}
		
		public function get type():String { return _type; }
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get source():String { return _source; }
		
		public function set source(value:String):void 
		{
			_source = value;
		}
		
	}//Endclass 

}//Endpackage

