package geometry.basic;

import openfl.display.Sprite;

class DraggableSprite extends Sprite {

	/**
		this callback's arguments:
		```haxe
		object.onDragged[i] = function (x:Float, y:Float, previousX:Float, previousY:Float) {}
		```
	**/
	public var onDragged:Array<(Float, Float, Float, Float) -> Void> = [];

	/**
		this callback's arguments:
		```haxe
		object.onMoved[i] = function (x:Float, y:Float) {}
		```
	**/
	public var onMoved:Array<(Float, Float) -> Void> = [];

	

	public function new() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
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
		trace("registered");
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
		for (move in onMoved) move(this.x, this.y);
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