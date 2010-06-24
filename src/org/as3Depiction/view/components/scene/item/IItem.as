package org.as3Depiction.view.components.scene.item{
	import flash.display.DisplayObject;
	import org.as3Depiction.model.vo.ItemVo;
	import mx.core.IUIComponent;
	
	
	public interface IItem{
		
		
		function init(data: ItemVo):void;
		
		function animateOut():void;
		
	}
}
