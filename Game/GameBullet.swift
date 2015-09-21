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
        gunMaterial.diffuse.contents = GameColor.greenColor()
        gunMaterial.emission.contents = GameColor.greenColor()
        gunMaterial.emission.intensity = 0.1
        let bulletNode1 = SCNNode()
        bulletNode1.geometry = SCNCylinder(radius: 0.1, height: 1)
        bulletNode1.geometry!.materials = [gunMaterial]
        bulletNode1.moveTo((-0.25,0))
        bulletNode1.elevation = -0.5
        bulletNode1.rotation = SCNVector4(x: 1, y: 0, z: 0, w: GameFloat(M_PI_2))
        let bulletNode2 = SCNNode()
        bulletNode2.geometry = SCNCylinder(radius: 0.1, height: 1)
        bulletNode2.geometry!.materials = [gunMaterial]
        bulletNode2.moveTo((0.25,0))
        bulletNode2.elevation = -0.5
        bulletNode2.rotation = SCNVector4(x: 1, y: 0, z: 0, w: GameFloat(M_PI_2))
        let node = SCNNode()
        node.addChildNode(bulletNode1)
        node.addChildNode(bulletNode2)
        return node
    }

    func move(time: NSTimeInterval) -> GameBulletMoveResult {
        guard let oldTime = lastMove else {
            lastMove = time
            return .Success
        }
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
    }

    deinit {
        node.removeFromParentNode()
    }
}