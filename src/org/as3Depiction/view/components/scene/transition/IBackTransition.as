package org.as3Depiction.view.components.scene.transition 
{
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.view.components.scene.BackRenderer;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IBackTransition 
	{
		function prepare(backRenderer:BackRenderer, transitionPath:PathVo):void;
		function startTransition():void;
		function backLoaded():void;
	}
	
}