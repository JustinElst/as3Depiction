package org.as3Depiction.view.components.scene.item{
	import com.greensock.easing.Circ;
	import com.greensock.events.TweenEvent;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import mx.controls.Alert;
	import org.as3Depiction.interfaces.IDispose;
	import org.as3Depiction.model.vo.ItemVo;

	
	public class Item extends Sprite implements IDispose, IItem
	{
		
		private var _id:uint;
		private var _title:String;
		private var _assetsPath:String;
		private var _imgLoader:Loader;
		private var _mouseArea:Bitmap;
		private var _mouseOver:Bitmap;
		private var _over:Boolean;
		private var _loadet:Array;
		private var _dismantled:Boolean = true;
		public static const CLICK:String = "MouseOutItem";
		public static const MOUSE_OUT:String = "MouseOutItem";
		public static const MOUSE_OVER:String = "MouseOverItem";
		
		public function Item()
		{
			_imgLoader = new Loader();
			_loadet = new Array();
			_over = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseMove);
		}
		
		/**
		 * set default vars for the item from the item vo
		 * @param	data
		 */
		public function init(data: ItemVo):void
		{
			_id = data.id;
			_title = data.title;
			_assetsPath = data.assetsPath;
			_loadet['mouseArea'] = false;
			_loadet['mouseOver'] = false;
			startLoad(_assetsPath + "item" + _id + ".png");
		}
		
		/**
		 * start the loading off the images
		 * @param	url the url for the assets
		 */
		private function startLoad(url:String): void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			_imgLoader = new Loader();
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBitmap);
			_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_imgLoader.load(urlRequest);
		}
		
		/**
		 * handle th eloadet image and check if the next image needs loading.
		 * dispath an event if all assets are loadet
		 * @param	e
		 */
		private function onLoadBitmap(e:Event):void 
		{
			if (_mouseArea == null)
			{
				_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadBitmap);
				_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				_loadet['mouseArea'] = true;
				_mouseArea = _imgLoader.content as Bitmap;
				_mouseArea.alpha = 0;
				_imgLoader = null;
				addChild(_mouseArea);
				startLoad(_assetsPath+"item" + _id + "glow.png");
			}
			else if (_mouseOver == null)
			{
				_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadBitmap);
				_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				_loadet['mouseOver'] = true;
				_mouseOver = _imgLoader.content as Bitmap;
				_mouseOver.alpha = 0;
				_imgLoader = null;
				addChild(_mouseOver);
			}
			if (_loadet['mouseArea'] == true && _loadet['mouseOver'] == true)
			{
				dispatchEvent(new Event(ItemEvent.LOAD_COMPLETE));
			}
		}
		
		/**
		 * check if the mouse movement is on the target area(white) of the _mousearea png.
		 * @param	e
		 * @param	onHitOtherItem if this is a test send from an other item this is true
		 */
		public function onMouseMove(e:MouseEvent, onHitOtherItem:Boolean = false):void 
		{
			if (onHitOtherItem == false )
			{
				dispatchEvent(new MouseEvent(ItemEvent.MOUSE_MOVE));
			}
			if (hitTest(_mouseArea, new Point(stage.mouseX, stage.mouseY)))
			{
				if (_over == false)
				{
					_over = true;
					addEventListener(MouseEvent.CLICK, onMouseClick);
					dispatchEvent(new MouseEvent(ItemEvent.MOUSE_OVER));
					TweenLite.killTweensOf(_mouseOver);
					new TweenLite(_mouseOver, 0.1, { alpha:1 , ease:Circ.easeIn} );
				}
			}
			else
			{
				if (_over == true)
				{
					_over = false;
					removeEventListener(MouseEvent.CLICK, onMouseClick);
					dispatchEvent(new MouseEvent(ItemEvent.MOUSE_OUT));
					TweenLite.killTweensOf(_mouseOver);
					new TweenLite(_mouseOver, 0.2, { alpha:0, ease:Circ.easeIn } );
				}
				
			}
		}
		
		/**
		 * if the item is clicked send event
		 * @param	e
		 */
		private function onMouseClick(e:MouseEvent):void 
		{
			dispatchEvent(new MouseEvent(ItemEvent.CLICK));
		}
		
		/**
		 * util function to determain if the mouse is over an transparent part of the png or not.
		 * @param	object the png data
		 * @param	point the point were the mouse is on the object
		 * @return
		 */
		private function hitTest(object:DisplayObject, point:Point):Boolean 
		{
            if (object is BitmapData) 
			{
                return (object as BitmapData).hitTest(new Point(0,0), 0, object.globalToLocal(point));
            }
            else 
			{
                if (!object.hitTestPoint(point.x, point.y, true)) 
				{
                    return false;
                }
                else 
				{
                    var bmapData:BitmapData = new BitmapData(object.width, object.height, true, 0x00000000);
                    bmapData.draw(object, new Matrix());
                    
                    var returnVal:Boolean = bmapData.hitTest(new Point(0,0), 0, object.globalToLocal(point));
                    
                    bmapData.dispose();
                    
                    return returnVal;
                }
            }
        }
		
		public function onLoadError(e:IOErrorEvent):void
		{
			Alert.show("Loading the back image of this scene has failed, please contact the admin. ", "Loading failed");
		}
		/**
		 * animate in the item
		 */
		public function animateIn():void
		{
			var timeline:TimelineMax = new TimelineMax();
			timeline.addEventListener(TweenEvent.COMPLETE, animateInComplete);
			timeline.append(new TweenLite(_mouseOver, 0.1, { alpha:1, ease:Circ.easeIn } ));
			if (_over != true)
			{
				timeline.append(new TweenLite(_mouseOver, 0.2, { alpha:0, ease:Circ.easeIn } ));
			}
		}
		private function animateInComplete(e:TweenEvent):void 
		{
			dispatchEvent(new Event(ItemEvent.ANIMATE_IN_COMPLETE));
		}
		
		/**
		 * animate Out the item
		 */
		public function animateOut():void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseMove);
			var timeline:TimelineMax = new TimelineMax();
			timeline.addEventListener(TweenEvent.COMPLETE, animateOutComplete);
			timeline.append(new TweenLite(_mouseOver, 0, { alpha:1, ease:Circ.easeOut } ));
			//timeline.append(new TweenLite(_mouseOver, 0, { alpha:0, ease:Circ.easeIn } ));
			
		}
		private function animateOutComplete(e:TweenEvent):void 
		{
			dispatchEvent(new Event(ItemEvent.ANIMATE_OUT_COMPLETE));
		}
		
		public function dispose():void
		{
			TweenLite.killTweensOf(_mouseOver);
		}
		/**
		* Getters and Setters
		*/
		public function get id():uint { return _id; }
		public function set id(newValue:uint):void
		{
			_id = newValue;
		}
		
	}//Endclass 

}//Endpackage

