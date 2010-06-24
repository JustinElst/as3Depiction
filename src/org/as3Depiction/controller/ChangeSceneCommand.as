package org.as3Depiction.controller{
	import org.as3Depiction.model.SceneProxy;
	import org.as3Depiction.model.vo.SceneVo;
	import org.as3Depiction.view.SceneMediator;
	import nl.demonsters.debugger.MonsterDebugger;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	
	public class ChangeSceneCommand extends SimpleCommand {
		
		public static const NAME:String = "ChangeSceneCommand";
		public static const CHANGE_SCENE:String = "ChangeScene";
		
		override public function execute( note:INotification) :void    
        {
			var sceneProxy:SceneProxy = facade.retrieveProxy(SceneProxy.NAME) as SceneProxy;
			if (sceneProxy.curSceneId != note.getBody() || sceneProxy.firstLoad == true)
			{
				sceneProxy.firstLoad = false;
				var nextScene:SceneVo= sceneProxy.getSceneById(note.getBody() as uint);
				sendNotification(SceneMediator.DISPLAY_SCENE, nextScene);
				sceneProxy.previousScene = sceneProxy.curScene;
				sceneProxy.curScene = nextScene.id;
			}
		}
		
	}

}

