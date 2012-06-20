package luoyong.flexmobiletree
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.utils.LinkedList;
	import mx.utils.LinkedListNode;
	
	import spark.components.View;
	import spark.events.IndexChangeEvent;
	
	public class ListView extends spark.components.View
	{
		
		/** UI List Component */
		private var _listComponent:spark.components.List;
		
		/** Dir the List component to show. */
		private var _dir:Dir;
		
		/** Parent dir and node list from current dir. Wrap them as type ActionItem. */
		private var _nodeList:ArrayList;
		
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
			
			this.addElement(_listComponent);
			
			_listComponent.addEventListener(IndexChangeEvent.CHANGE, changeSelection);
		}
		
		private function changeSelection(evt: Event):void {
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
		
		/**
		 * Refresh this component.
		 */
		public function refresh():void {
			
			var i:int = 0;
			
			// Clear node list.
			this._nodeList = new ArrayList();
			
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
			this._nodeList.addItem(new ActionItemAncestorDir(dir));
		}
		
		private function addNode(node:Node):void {
			this._nodeList.addItem(new ActionItem(node));
		}
	}
	
	 
}

class ActionItem {
	
	import luoyong.flexmobiletree.Dir;
	import luoyong.flexmobiletree.Node;
	
	private var _item:Object;
	private var _action:Function;
	
	public function ActionItem(item:Object, action:Function=null) {
		this._item = item;
		this._action = action;
	}
	
	public function get item():Object {
		return _item;
	}
	
	public function get action():Function {
		return this._action;
	}
	
	public function toString():String {
		var literal:String = _item.name;
		if (this._item is Dir) {
			literal = " " + literal + " >";
			return literal;
		}else if(this._item is Node) {
			literal = " " + literal;
			return literal;
		}else {
			return _item.toString();
		}
	}
}

class ActionItemAncestorDir extends ActionItem {
	
	import luoyong.flexmobiletree.Dir;
	
	private var _dir:Dir;
	
	public function ActionItemAncestorDir(dir:Dir, action:Function=null) {
		super(dir, action);
		_dir = dir
	}
	
	public override function toString():String {
		return this._dir.name + " >";
	}
}
