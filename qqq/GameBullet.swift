import SceneKit

enum GameBulletMoveResult {
    case Success
    case EnemyKilled(Int, Int)
    case BulletBreaks
}

class GameBullet {
    private let cellsPerSecond: Double = 5
    private unowned let game: GameController
    private let direction: GameDirection
    private let node: SCNNode
    private var xy: (Double, Double)
    private var lastMove: NSTimeInterval?
    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection) {
        xy = (Double(x), Double(y))
        node = GameBullet.createNode()
        node.rotateTo(dir)
        node.moveTo(xy)
        direction = dir
        game = controller
        scene.addChildNode(node)
    }


    private class func createNode() -> SCNNode {
        let gunMaterial = SCNMaterial()
        gunMaterial.diffuse.contents = NSColor.greenColor()
        gunMaterial.emission.contents = NSColor.greenColor()
        gunMaterial.emission.intensity = 0.1
        let bulletNode = SCNNode()
        bulletNode.geometry = SCNCylinder(radius: 0.1, height: 1)
        bulletNode.geometry!.materials = [gunMaterial]
        bulletNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: CGFloat(M_PI_2))
        let node = SCNNode()
        node.addChildNode(bulletNode)
        return node
    }

    func move(time: NSTimeInterval) -> GameBulletMoveResult {
        if let oldTime = lastMove {
            lastMove = time
            xy = direction.getNextPosition(xy, offset: (time-oldTime)*cellsPerSecond)
            node.moveTo(xy)
            let nextPosition = (Int(xy.0), Int(xy.1))
            switch(game.itemAt(nextPosition)) {
            case .Wall, .Exit:
                return .BulletBreaks
            case .Enemy:
                return .EnemyKilled(nextPosition)
            case .Empty, .Gun, .Player:
                return .Success
            }
        } else {
            lastMove = time
            return .Success
        }
    }

    deinit {
        node.removeFromParentNode()
    }
}