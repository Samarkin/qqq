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

    override func keyDown(with theEvent: NSEvent) {
        guard let key = keymap[theEvent.keyCode] else {
            super.keyDown(with: theEvent)
            return
        }
        _ = keyEventsDelegate?.keyDown(key)
    }

    override func keyUp(with theEvent: NSEvent) {
        guard let key = keymap[theEvent.keyCode] else {
            super.keyUp(with: theEvent)
            return
        }
        _ = keyEventsDelegate?.keyUp(key)
    }

    
}
