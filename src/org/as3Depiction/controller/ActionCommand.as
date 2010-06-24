package org.as3Depiction.controller 
{
	import hv.controller.InfoPopupCommand;
	import nl.demonsters.debugger.MonsterDebugger;
	import org.as3Depiction.model.SceneProxy;
	import org.as3Depiction.model.vo.ActionVo;
	import org.as3Depiction.model.vo.ItemVo;
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.model.vo.SceneVo;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	/**
	 * ...
	 * @author ...
	 */
	public class ActionCommand extends SimpleCommand
	{
		public static const NAME:String = 'ActionCommand';
		
		override public function execute( note:INotification ) :void    
        {
			var sceneProxy:SceneProxy = facade.retrieveProxy(SceneProxy.NAME) as SceneProxy;
			var curScene:SceneVo = sceneProxy.getCurScene() as SceneVo;
			var item:ItemVo = sceneProxy.getItemById(note.getBody() as uint) as ItemVo;
			var action:ActionVo = item.action;
			if (action.type == 'path')
			{
				var path:PathVo = sceneProxy.getPathById(uint(action.value));
				var nextScene:SceneVo = sceneProxy.getSceneById(path.to);
				sendNotification(ChangeSceneCommand.CHANGE_SCENE, nextScene.id);
			}
			else if (action.type == 'item')
			{
				sendNotification(InfoPopupCommand.DISPLAY_POPUP, action.value);
			}
        }
	}
}