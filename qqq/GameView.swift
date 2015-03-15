import SceneKit

class GameView: SCNView {
    weak var keyEventsDelegate : KeyEventsDelegate?

    override func keyDown(theEvent: NSEvent) {
        if keyEventsDelegate?.keyDown(theEvent) != true {
            super.keyDown(theEvent)
        }
    }

    override func keyUp(theEvent: NSEvent) {
        if keyEventsDelegate?.keyUp(theEvent) != true {
            super.keyUp(theEvent)
        }
    }

    
}