import Foundation
import SceneKit

class GameShip {
    private let node: SCNNode
    private unowned let game: GameController
    private var xy: (Int, Int)
    private var direction: GameDirection
    internal init(playerNode: SCNNode, withController controller: GameController) {
        node = playerNode
        game = controller
        xy = (0,0)
        direction = .North
    }

    internal func rotate(dir: RotateDirection) {
        SCNTransaction.setAnimationDuration(0.5)
        switch(dir) {
        case .Left:
            direction = direction.left
            node.rotation.w += CGFloat(M_PI_2)
        case .Right:
            direction = direction.right
            node.rotation.w -= CGFloat(M_PI_2)
        }
        println("Ship is at \(xy) facing \(direction.rawValue)")
    }

    // x points to the north
    // z points to the east
    internal func move(dir: MoveDirection) -> GameMoveResult {
        var moveDirection = dir == .Forward ? direction : direction.opposite
        var next = moveDirection.getNextPosition(xy.0, xy.1)
        println("Ship next is at \(next)")
        switch(game.itemAt(next)) {
        case .Empty:
            SCNTransaction.setAnimationDuration(0.5)
            game.setItemAt(xy, item: .Empty)
            xy = next
            // TODO: replace with common translation method
            node.position = SCNVector3(x: CGFloat(-xy.0*10), y: 0, z: CGFloat(xy.1*10))
            game.setItemAt(xy, item: .Player)
            return .Success
        case .Enemy:
            return .GameOver
        case .Exit:
            return .NextLevel
        default:
            return .Success
        }
    }

    internal func reset(x: Int, _ y: Int, dir: GameDirection) {
        xy = (x,y)
        direction = dir
        SCNTransaction.setAnimationDuration(0)
        node.rotation = dir.asRotationVector
        node.position.x = CGFloat(-x*10)
        node.position.z = CGFloat(y*10)
    }

    internal enum RotateDirection {
        case Left
        case Right
    }

    internal enum MoveDirection {
        case Forward
        case Backwards
    }
}
