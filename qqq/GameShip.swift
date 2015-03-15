import Foundation
import SceneKit

class GameShip {
    private let node: SCNNode
    private unowned let game: GameController
    private var xy: (Int, Int)
    private var direction: GameDirection
    internal init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection) {
        let camera = scene.cameraNode
        camera.removeFromParentNode()
        node = GameShip.createNode(camera: camera)
        scene.addChildNode(node)
        game = controller

        xy = (x,y)
        node.moveTo(xy)
        direction = dir
        node.rotation = dir.asRotationVector
    }

    private class func createNode(#camera: SCNNode?) -> SCNNode {
        let scene = SCNScene(named: "art.scnassets/ship.dae")!
        let shipNode = scene.rootNode.childNodeWithName("ship", recursively: true)!

        SCNTransaction.setAnimationDuration(0)
        // place the camera
        camera?.position = SCNVector3(x: 0, y: 4, z: -15)
        camera?.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI))

        // create and add a light to the scene
        let light = SCNLight()
        light.type = SCNLightTypeSpot
        light.spotInnerAngle = 0.1
        light.spotInnerAngle = 0.2
        light.castsShadow = true
        light.shadowColor = NSColor.blackColor()

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI))
        lightNode.position = SCNVector3(x: 0, y: 2, z: 0)

        // group a player
        var player = SCNNode()
        player.name = "player"
        if let c = camera { player.addChildNode(c) }
        player.addChildNode(shipNode)
        player.addChildNode(lightNode)
        player.elevation = 0.0
        scene.rootNode.addChildNode(player)
        return player
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

    internal func move(dir: MoveDirection) -> GameMoveResult {
        var moveDirection = dir == .Forward ? direction : direction.opposite
        var next = moveDirection.getNextPosition(xy)
        println("Ship next is at \(next)")
        switch(game.itemAt(next)) {
        case .Empty:
            SCNTransaction.setAnimationDuration(0.5)
            game.setItemAt(xy, item: .Empty)
            xy = next
            node.moveTo(xy)
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

    deinit {
        node.removeFromParentNode()
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
