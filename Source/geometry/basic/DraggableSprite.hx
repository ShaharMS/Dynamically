package geometry.basic;

import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.display.Sprite;

class DraggableSprite extends Sprite {

	/**
		this callback's arguments:
		```haxe
		object.onDragged[i] = function (x:Float, y:Float, previousX:Float, previousY:Float) {}
		```
	**/
	public var onDragged:Array<(x:Float, y:Float, px:Float, py:Float) -> Void> = [];

	/**
		this callback's arguments:
		```haxe
		object.onMoved[i] = function (x:Float, y:Float, mouseX:Float, mouseY:Float) {}
		```

		onMoved[0] is reserved to the actualy movement.
	**/
	public var onMoved:Array<(x:Float, y:Float, mx:Float, my:Float) -> Void> = [];

	

	public function new() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}
	
	function onMouseOver(e:MouseEvent) {
		Mouse.cursor = openfl.ui.MouseCursor.HAND;
	}

	function onMouseOut(e:MouseEvent) {
		Mouse.cursor = MouseCursor.DEFAULT;
	}

	var pX:Float;
	var pY:Float;

	var prevX:Float;
	var prevY:Float;

    var offsetX:Float;
    var offsetY:Float;

	function setPrevDimensions() {
		prevX = x;
		prevY = y;
	}

	function registerDrag(e:MouseEvent) {
		offsetX = parent.mouseX - x;
		offsetY = parent.mouseY - y;
		pX = x;
		pY = x;
		removeEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, applyDrag);
		stage.addEventListener(MouseEvent.MOUSE_UP, unregisterDrag);
	}

	function applyDrag(e:MouseEvent) {
		var local = parent.globalToLocal(new Point(e.stageX - offsetX, e.stageY - offsetY));
		this.x = local.x;
		this.y = local.y;
		for (move in onMoved) move(local.x, local.y, e.stageX, e.stageY);
	}

	function unregisterDrag(e:MouseEvent) {
		var local = parent.globalToLocal(new Point(e.stageX - offsetX, e.stageY - offsetY));
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, applyDrag);
		stage.removeEventListener(MouseEvent.MOUSE_UP, unregisterDrag);
		addEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
		if (local.x == pX && local.y == pY)
			return;
		
        for (drag in onDragged) drag(local.x, local.y, pX, pY);
	}
}