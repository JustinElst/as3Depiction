package org.as3Depiction.model{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import mx.controls.Alert;
	import nl.demonsters.debugger.MonsterDebugger;
	import org.as3Depiction.controller.ChangeSceneCommand;
	import org.as3Depiction.model.vo.ActionVo;
	import org.as3Depiction.model.vo.ItemVo;
	import org.as3Depiction.model.vo.PathVo;
	import org.as3Depiction.model.vo.SceneVo;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SceneProxy extends Proxy implements IProxy 
	{
		public static const NAME:String = 'SceneProxy';
		public static const SCENES_LOADET:String = 'SceneLoadet';
		
		private var _data:Vector.<SceneVo>;
		private var _curScene:uint = 0;
		private var _previousScene:uint = 0;
		private var _options:Array;
		private var _firstLoad:Boolean = true;
		
		public function SceneProxy()
		{
			var vector:Vector.<SceneVo> = new Vector.<SceneVo>();
			
			var it1:ItemVo = new ItemVo();
			it1.id = 1;
			it1.position = new Point(147, 181);
			it1.title = 'item 1';
			
			var ac1:ActionVo = new ActionVo();
			ac1.type = 'path';
			ac1.value = '0';
			it1.action = ac1;
			
			var pa1:PathVo = new PathVo();
			pa1.id = 1;
			pa1.to = 1;
			
			var vo1:SceneVo = new SceneVo();
			vo1.id = 0;
			vo1.title = 'Straat';
			vo1.backUrl = 'images/default/back.png';
			vo1.items = new Vector.<ItemVo>();
			vo1.items.push(it1);
			vo1.paths = new Vector.<PathVo>();
			vo1.paths.push(pa1);
			vector.push(vo1);
			
			_options = new Array();
			loadScenes('scenes');
			super(NAME, vector);
		}
		
		/**
		 * Load the scene with a file.
		 * 
		 * @param	file the location of the file to load
		 */
		private function loadScenes(file:String):void
		{
			var lader:URLLoader = new URLLoader();
			lader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			lader.addEventListener(Event.COMPLETE, loadComplete);
			lader.load(new URLRequest("xml/" + file + ".xml"));
		}
		
		/**
		 * file loadet and convert file to vo's and save in the data property.
		 * Save te vo's in the data property
		 * 
		 * @param	e
		 */
		private function loadComplete(e: Event):void
		{
			var tData:Vector.<SceneVo>  = new Vector.<SceneVo>;
			var container:XML = new XML(e.target.data);
			_options['baseImgFolder'] = container.child('options').@baseImgFolder;
			for each (var scene:XML in container.scenes.children() )
			{
				var sVo:SceneVo = new SceneVo();
				sVo.id = scene.@id;
				sVo.title = scene.@title;
				sVo.backUrl = _options['baseImgFolder']+"scene_"+sVo.id+"/"+scene.@backUrl;
				sVo.itemImgFolder = scene.@itemImgFolder;
				sVo.pathAssetsFolder = scene.@pathAssetsFolder;
				sVo.items = new Vector.<ItemVo>;
				for each (var item:XML in scene.items.children() )
				{
					var iVo:ItemVo = new ItemVo();
					iVo.id = item.@id;
					iVo.title = item.@title;
					iVo.assetsPath = _options['baseImgFolder']+"scene_"+sVo.id+"/"+sVo.itemImgFolder+"/";
					iVo.position = new Point(item.point.@x, item.point.@y);
					var aVo:ActionVo = new ActionVo();
					aVo.type = item.action.@type;
					aVo.value = item.action.@value;
					iVo.action = aVo;
					sVo.items.push(iVo);
				}
				sVo.paths = new Vector.<PathVo>;
				for each (var path:XML in scene.paths.children() )
				{
					var pVo:PathVo = new PathVo();
					pVo.id = path.@id;
					pVo.to = path.@to;
					pVo.type = path.@type;
					pVo.source = _options['baseImgFolder']+"scene_"+sVo.id+"/"+sVo.pathAssetsFolder+"/"+path.@source;
					sVo.paths.push(pVo);
				}
				tData.push(sVo);
			}
			data = tData;
			sendNotification(SCENES_LOADET, null);
			sendNotification(ChangeSceneCommand.CHANGE_SCENE, 0);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			Alert.show("Scenes failed to load. Please contact the admin.");
		}
		
		/**
		 * Get all the scenes vo 
		 * 
		 * @return vector of scene vo's
		 */
		public function getScenes(): Vector.<SceneVo>
		{
			return data as Vector.<SceneVo>;
		}
		
		/**
		 * get the scene vo by id
		 * 
		 * @param	id 
		 * @return  scene vo
		 */
		public function getSceneById(id: uint): SceneVo
		{
			var vector:Vector.<SceneVo> = data as Vector.<SceneVo>;
			for each (var scene:SceneVo in vector)
			{
				if (scene.id == id)
				{
					break;
				}
			}
			if (scene.id != _curScene)
			{
				scene.transitionPath = getPathByTo(scene.id);
			}
			else
			{
				scene.transitionPath = null;
			}
			return scene;
		}
		
		/**
		 * get the scene that is currently in use.
		 * @return
		 */
		public function getCurScene(): SceneVo
		{
			return getSceneById(_curScene);
		}
		
		/**
		 * get an item vo of a specific scene by id
		 * @param	id the id of the item.
		 * @param	sceneId the scene of witch the item 
		 * @return  item vo of that item
		 */
		public function getItemById(id: uint , sceneId:uint = 0):ItemVo
		{
			var vector:Vector.<SceneVo> = data as Vector.<SceneVo>;
			for each (var item:ItemVo in getCurScene().items)
			{
				if (item.id == id)
				{
					break;
				}
			}
			return item;
		}
		
		/**
		 *  get an path vo of a specific scene by id
		 * @param	id 
		 * @param	sceneId 
		 * @return
		 */
		public function getPathById(id:uint, sceneId:uint = 0):PathVo
		{
			var vector:Vector.<SceneVo> = data as Vector.<SceneVo>;
			for each (var path:PathVo in getCurScene().paths)
			{
				if (path.id == id)
				{
					break;
				}
			}
			return path;
		}
		public function getPathByTo(id:uint, sceneId:uint = 0):PathVo
		{
			var vector:Vector.<SceneVo> = data as Vector.<SceneVo>;
			for each (var path:PathVo in getCurScene().paths)
			{
				if (path.to == id)
				{
					var tPath:PathVo = path;
					break;
				}
			}
				return tPath;
		}
		
		public function set curScene(value:uint):void 
		{
			_curScene = value;
		}
		
		public function get previousScene():uint { return _previousScene; }
		public function set previousScene(value:uint):void 
		{
			_previousScene = value;
		}
		
		public function get curSceneId():uint { return _curScene; }
		
		public function get firstLoad():Boolean { return _firstLoad; }
		
		public function set firstLoad(value:Boolean):void 
		{
			_firstLoad = value;
		}
		
		public function get curScene():uint { return _curScene; }
		
		/**
		* Getters and Setters
		*/
		
	}//Endclass 

}//Endpackage

