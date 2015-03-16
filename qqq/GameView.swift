import SceneKit

class GameView: SCNView {
    weak var keyEventsDelegate : KeyEventsDelegate?

    override func keyDown(theEvent: NSEvent) {
        if keyEventsDelegate?.keyDown(theEvent.keyCode) != true {
            super.keyDown(theEvent)
        }
    }

    override func keyUp(theEvent: NSEvent) {
        if keyEventsDelegate?.keyUp(theEvent.keyCode) != true {
            super.keyUp(theEvent)
        }
    }

    
}