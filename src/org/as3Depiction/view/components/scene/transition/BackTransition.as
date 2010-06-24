package org.as3Depiction.view.components.scene.transition 
{
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.view.components.scene.BackRenderer;
	/**
	 * ...
	 * @author ...
	 */
	public class BackTransition
	{
		private var _backRenderer:BackRenderer;
		private var _transitionPath:PathVo;
		public function BackTransition(backRenderer:BackRenderer, transitionPath:PathVo) 
		{
			_backRenderer = backRenderer;
			_transitionPath = transitionPath;
			_backRenderer.loadNextBack();
		}
		
		public function backLoaded():void
		{
			_backRenderer.displayContainer.addChild(_backRenderer.nextBack);
			_backRenderer.transitionComplete();
		}
	}

}