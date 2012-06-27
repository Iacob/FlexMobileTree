package luoyong.flexmobiletree
{
	import flash.desktop.Icon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.core.BitmapAsset;
	import mx.core.ClassFactory;
	import mx.utils.LinkedList;
	import mx.utils.LinkedListNode;
	
	import spark.components.View;
	import spark.events.IndexChangeEvent;
	import spark.primitives.BitmapImage;
	
	public class ListView extends spark.components.View
	{
		
		/** UI List Component */
		private var _listComponent:spark.components.List;
		
		/** Dir the List component to show. */
		private var _dir:Dir;
		
		/** Parent dir and node list from current dir.
		 * The dir and list must be wrapped as type ActionItem.
		 */
		private var _nodeList:ArrayList;
		
		private var _icon_dir_uplevel:String = "luoyong/flexmobiletree/uplevel.png";
		private var _icon_dir_path:String = "luoyong/flexmobiletree/dir.png";
		private var _icon_node_path:String = "luoyong/flexmobiletree/node.png";
		
		private var _callBackChangeSelection:Function;
		
		public function ListView()
		{
			super();
			this.initView();
		}
		
		private function initView():void {
			
			// Initialize node list.
			_nodeList = new ArrayList();
			
			// Initialize list component.
			_listComponent = new spark.components.List();
			_listComponent.itemRenderer = new ClassFactory(NodeListRenderer);
			
			// Add list component to view.
			this.addElement(_listComponent);
			
			_listComponent.addEventListener(IndexChangeEvent.CHANGE, changeSelection);
		}
		
		/**
		 * Selection change action.
		 */
		private function changeSelection(evt: spark.events.IndexChangeEvent):void {
			
			var selectedNode:Node = _nodeList.getItemAt(evt.newIndex).item as Node;
			//trace(selectedNode.name);
			if (selectedNode is Dir) {
				this.dir = selectedNode as Dir;
				
				// Call the callback function to notify the dir change.
				if (this.changeSelectionCallback != null) {
					this.changeSelectionCallback(this.dir);
				}
			}
		}
		
		/**
		 * Get node for this component.
		 */
		public function get dir():Dir {
			return _dir;
		}
		
		/**
		 * Set node and refresh this component.
		 */
		public function set dir(value:Dir):void {
			this._dir = value;
			this.refresh();
		}
		
		public function get changeSelectionCallback():Function {
			return this._callBackChangeSelection;
		}
		
		public function set changeSelectionCallback(value:Function):void {
			this._callBackChangeSelection = value;
		}
		
		/**
		 * Refresh this component.
		 */
		public function refresh():void {
			
			// Reset list component width.
			_listComponent.width = this.width;
			
			var i:int = 0;
			
			// Clear node list.
			this._nodeList.removeAll();
			
			// Add full dir to list.
			if (this.dir != null) {
				if (this.dir.fullDir != null) {
					for (i=0; i<this.dir.fullDir.length; i++) {
						// Add ancestor node.
						this.addAncestorDir(Dir(this.dir.fullDir.getItemAt(i)));
					}
				}
			}
			
			// Add sub nodes to list.
			if ((this.dir != null) && (this.dir.nodes != null)) {
				
				for (i=0; i<this.dir.nodes.length; i++) {
					this.addNode(Node(this.dir.nodes.getItemAt(i)));
				}
			}
			
			_listComponent.dataProvider = _nodeList;
		}
		
		private function addAncestorDir(dir:Dir):void {
			var actionDir:ActionItemAncestorDir = new ActionItemAncestorDir(dir);
			actionDir.icon = this._icon_dir_uplevel;
			this._nodeList.addItem(actionDir);
		}
		
		private function addNode(node:Node):void {
			var actionNode:ActionItem = new ActionItem(node);
			if (node is Dir) {
				actionNode.icon = this._icon_dir_path;
			}else {
				actionNode.icon = this._icon_node_path;
			}
			this._nodeList.addItem(actionNode);
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;

import spark.primitives.BitmapImage;

class ActionItem extends Object {
	
	import luoyong.flexmobiletree.Dir;
	import luoyong.flexmobiletree.Node;
	
	private var _item:Object;
	private var _action:Function;
	
	private var _label:String;
	private var _message:String;
	private var _icon:String;
	
	public function ActionItem(item:Node, action:Function=null) {
		this.label = item.name;
		this._item = item;
		this._action = action;
	}
	
	public function get item():Object {
		return _item;
	}
	
	public function get action():Function {
		return this._action;
	}
	
	public function get label():String {
		return _label;
	}
	
	public function set label(value:String):void {
		this._label = value;
	}
	
	public function get message():String {
		return _message;
	}
	
	public function set message(value:String):void {
		this._message = value;
	}
	
	public function get icon():String {
		return _icon;
	}
	
	public function set icon(value:String):void {
		this._icon = value;
	}
}

class ActionItemAncestorDir extends ActionItem {
	
	import luoyong.flexmobiletree.Dir;
	
	private var _dir:Dir;
	
	public function ActionItemAncestorDir(dir:Dir, action:Function=null) {
		super(dir, action);
		_dir = dir
	}
}
