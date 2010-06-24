package org.as3Depiction.view.components.scene.back 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.as3Depiction.interfaces.IDispose;
	import org.as3Depiction.model.vo.SceneVo;
	/**
	 * ...
	 * @author ...
	 */
	public class Back extends Sprite implements IDispose, IBack
	{
		
		public function Back() 
		{
			
		}
		
		public function load(scene:SceneVo):void
		{
			dispatchEvent(new Event(BackEvent.LOAD_STARTED));
			dispatchEvent(new Event(BackEvent.LOAD_COMPLETE));
		}
		
		public function dispose():void
		{
			
		}
		
	}

}