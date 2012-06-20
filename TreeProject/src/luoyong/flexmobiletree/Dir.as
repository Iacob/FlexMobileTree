package luoyong.flexmobiletree
{
	import mx.collections.ArrayList;
	import mx.utils.LinkedList;

	public class Dir extends Node
	{
		// Nodes the dir contain.
		private var _nodes:ArrayList;
		
		public function Dir(name:String=null)
		{
			super(name);
			_nodes = new ArrayList();
		}
		
		/**
		 * Get sub nodes.
		 */
		public function get nodes():ArrayList {
			return _nodes;
		}
		
		/**
		 * Set sub nodes.
		 */
		public function set nodes(values:ArrayList):void {
			if (values == null) {
				values = new ArrayList();
			}
			
			// Point these nodes' dir property to current object.
			for (var i:int = 0; i<values.length; i++) {
				var value:Node = Node(values.getItemAt(i));
				if (value != null) {
					value.dir = this;
				}
			}
			
			// Set the sub nodes.
			this._nodes = values;
		}
		
		/**
		 * Add node to this dir.
		 */
		public function addNode(node:Node):void {
			
			
			if (_nodes == null) {
				_nodes = new ArrayList();
			}
			
			// Return if the node has already been added.
			for (var i:int=0; i<_nodes.length; i++) {
				if (node == _nodes.getItemAt(i)) {
					return;
				}
			}
			
			// Add the node to this dir.
			this._nodes.addItem(node);
			
			// Change the node's dir.
			if (node != null) {
				node.dir = this;
			}
		}
		
		/**
		 * Detect if this dir have nodes.
		 */
		public function hasNode():Boolean {
			if ((_nodes == null) || (_nodes.length < 1)) {
				return false;
			}else {
				return true;
			}
		}
	}
}