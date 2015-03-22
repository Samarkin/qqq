import SceneKit

class GameView: SCNView {
    weak var keyEventsDelegate : KeyEventsDelegate?

    let keymap: [UInt16: Key] = [
        123: .Left, // Left arrow
        124: .Right, // Right arrow
        125: .Backwards, // Down arrow
        126: .Forward, // Up arrow
        49: .Action // Spacebar
    ]

    override func keyDown(theEvent: NSEvent) {
        let key = keymap[theEvent.keyCode]
        if key == nil || keyEventsDelegate?.keyDown(key!) != true {
            super.keyDown(theEvent)
        }
    }

    override func keyUp(theEvent: NSEvent) {
        let key = keymap[theEvent.keyCode]
        if key == nil || keyEventsDelegate?.keyUp(key!) != true {
            super.keyUp(theEvent)
        }
    }

    
}