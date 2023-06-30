package menus;

class RightClickMenu {
    
    public var object:DisplayObject;

    public function new(object:DisplayObject) {
        this.object = object;
        object.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
    }

    function onRightClick(e:MouseEvent) {
        
    }

    function closeMenu() {
        
    }
}