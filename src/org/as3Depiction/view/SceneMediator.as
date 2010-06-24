package org.as3Depiction.view{
	import flash.events.Event;
	import org.as3Depiction.model.SceneProxy;
	import org.as3Depiction.model.vo.SceneVo;
	import org.as3Depiction.view.components.scene.item.ItemEvent;
	import org.as3Depiction.view.components.SceneManager;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SceneMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = 'SceneMediator';
		public static const DISPLAY_SCENE:String = 'DisplayScene';
		public static const SCENE_TRANSITION_COMPLETE:String = 'SceneTransitionComplete';
		public static const CLICK_ITEM:String = 'ItemClicked';
		public static const OVER_ITEM:String = 'OverSceneItem';
		public static const OUT_ITEM:String = 'OutSceneItem';
		
		public function SceneMediator(viewComponent:SceneManager):void
		{
			super( NAME, viewComponent);
		}
		
		/**
		 * in the startup sequence this function is called before all other mediators.
		 */
		override public function onRegister():void
		{
			
		}
		
		
		override public function listNotificationInterests(): Array
		{
			return [SceneProxy.SCENES_LOADET,DISPLAY_SCENE];
		}
		
		override public function handleNotification(note: INotification):void
		{
			switch ( note.getName() ) 
            {
                case DISPLAY_SCENE:
                    changeScene(note.getBody() as SceneVo);
                break;
            }
		}
		
		/**
		 * changes the scene witch the view (SceneManager) wil handle
		 * listens for complete witch will be dispatched when the items of the new scene are loaded
		 * 
		 * @param	scene is the vo for the new scene, the scene manager will load the appropriate assets and sets up the scene according to this vo.
		 */
		private function changeScene(scene:SceneVo):void
		{
			var view:SceneManager = viewComponent as SceneManager;
			view.items.removeEventListener(ItemEvent.CLICK, onItemEvent);
			view.items.removeEventListener(ItemEvent.MOUSE_OVER, onItemEvent);
			view.items.removeEventListener(ItemEvent.MOUSE_OUT, onItemEvent);
			
			view.addEventListener(SceneManager.CHANGE_SCENE_COMPLETE, changeSceneComplete);
			view.changeScene(scene);
		}
		/**
		 * This event will be trigered when the items for the new scene are loadet and on the stage.
		 * Adds event listeners for the items so when a item got a event it will be handled by onItemEvent
		 * 
		 * @param	e is not used
		 */
		private function changeSceneComplete(e:Event):void
		{
			var view:SceneManager = viewComponent as SceneManager;
			view.items.addEventListener(ItemEvent.CLICK, onItemEvent);
			view.items.addEventListener(ItemEvent.MOUSE_OVER, onItemEvent);
			view.items.addEventListener(ItemEvent.MOUSE_OUT, onItemEvent);
			sendNotification(SCENE_TRANSITION_COMPLETE);
		}
		
		/**
		 * Handles all item events in the current scene 
		 * and sends the propper notification to the rest of the application.
		 * The item id is send with the notification, 
		 * the rest of the application can use it to see witch item the event originates from.
		 * 
		 * @param	e type is used to determine the event from an item.
		 */
		public function onItemEvent(e:ItemEvent):void 
		{
			if (e.type == ItemEvent.CLICK)
			{
				var view:SceneManager = viewComponent as SceneManager;
				sendNotification(CLICK_ITEM, e.itemId);
			}
			else if (e.type == ItemEvent.MOUSE_OVER)
			{
				sendNotification(OVER_ITEM, e.itemId);
			}
			else if (e.type == ItemEvent.MOUSE_OUT)
			{
				sendNotification(OUT_ITEM, e.itemId);
			}
		}
		
		/**
		* Getters and Setters
		*/
		
	}//Endclass 

}//Endpackage

