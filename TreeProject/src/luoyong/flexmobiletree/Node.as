package luoyong.flexmobiletree
{
	import mx.collections.ArrayList;
	import mx.utils.LinkedList;
	
	public class Node
	{
		
		private var _name:String;
		
		private var _dir:Dir;
		
		public function Node(name:String=null) {
			this.name = name;
		}
		
		/**
		 * Get node name.
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * Set node name.
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * Get dir.
		 */
		public function get dir():Dir {
			return _dir;
		}
		
		/**
		 * Set dir.
		 */
		public function set dir(value:Dir):void {
			_dir = value;
		}
		
		/**
		 * Get full dirs (in order).
		 */
		public function get fullDir():ArrayList {
			var fullDir:ArrayList = new ArrayList();
			
			var currentDir:Dir = this.dir;
			while (currentDir != null) {
				fullDir.addItemAt(currentDir, 0);
				currentDir = currentDir.dir;
			}
			
			return fullDir;
		}
	}
}