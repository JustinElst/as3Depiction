package org.as3Depiction.model.vo{

	
	public class ActionVo 
	{
		private var _type:String;
		private var _value:String;
		
		public function ActionVo()
		{
			_type = 'path';
			_value = '0';
		}
		
		/**
		* Getters and Setters
		*/
		public function get type():String { return _type; }
		public function set type(newValue:String):void
		{
			_type = newValue;
		}
		public function get value():String { return _value; }
		public function set value(newValue:String):void
		{
			_value = newValue;
		}
	}//Endclass 

}//Endpackage

