package org.as3Depiction.view.components.scene.back 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class BackEvent extends Event
	{
		private var _back:Back = new Back;
		public static const LOAD_STARTED:String =  'backLoadStarted';
		public static const LOAD_COMPLETE:String =  'backLoadComplete';
		public static const TRANSITION_COMPLETE:String =  'transitionBackComplete';
		
		public function BackEvent(type:String, back:Back, bubbles:Boolean = false,cancelable:Boolean = false) 
		{
			_back = back;
			super(type, bubbles, cancelable);
		}
		
		public function get back():Back { return _back; }
		
	}

}