package org.as3Depiction.view.components.scene.transition 
{
	import com.greensock.TweenLite;
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.view.components.scene.BackRenderer;
	/**
	 * ...
	 * @author ...
	 */
	public class CrossFade implements IBackTransition
	{
		private var _backRenderer:BackRenderer;
		private var _transitionPath:PathVo;
		private var _ready:Boolean = false;
		private var _start:Boolean = false;
		
		public function CrossFade() 
		{
		}
		
		public function prepare(backRenderer:BackRenderer, transitionPath:PathVo):void
		{
			_backRenderer = backRenderer;
			_transitionPath = transitionPath;
			_backRenderer.loadNextBack();
		}
		
		public function startTransition():void
		{
			_start = true;
			transit();
		}
		
		public function backLoaded():void
		{
			_ready = true;
			transit();
		}
		
		private function transit():void
		{
			if (_ready == true && _start == true)
			{
				_backRenderer.nextBack.alpha = 0;
				_backRenderer.displayContainer.addChild(_backRenderer.nextBack);
				TweenLite.to(_backRenderer.nextBack, 1, {alpha:1, onComplete:transitionComplete } );
				TweenLite.to(_backRenderer.curBack, 1, { alpha:0 } );
			}
		}
		
		private function transitionComplete():void
		{
			_backRenderer.transitionComplete();
		}
	}

}