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
    private var lastMove: TimeInterval?
    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection) {
        xy = (Double(x), Double(y))
        node = GameBullet.createNode()
        node.rotate(to: dir)
        node.move(to: xy)
        direction = dir
        game = controller
        scene.addChildNode(node)
    }

    private class func createNode() -> SCNNode {
        let gunMaterial = SCNMaterial()
        gunMaterial.diffuse.contents = GameColor.green
        gunMaterial.emission.contents = GameColor.green
        gunMaterial.emission.intensity = 0.1
        let cylinder1 = SCNCylinder(radius: 0.1, height: 1)
        cylinder1.materials = [gunMaterial]
        let bulletNode1 = SCNNode()
        bulletNode1.geometry = cylinder1
        bulletNode1.move(to: (-0.25,0))
        bulletNode1.elevation = -0.5
        bulletNode1.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi/2)
        let cylinder2 = SCNCylinder(radius: 0.1, height: 1)
        cylinder2.materials = [gunMaterial]
        let bulletNode2 = SCNNode()
        bulletNode2.geometry = cylinder2
        bulletNode2.move(to: (0.25,0))
        bulletNode2.elevation = -0.5
        bulletNode2.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi/2)
        let node = SCNNode()
        node.addChildNode(bulletNode1)
        node.addChildNode(bulletNode2)
        return node
    }

    func move(at time: TimeInterval) -> GameBulletMoveResult {
        guard let oldTime = lastMove else {
            lastMove = time
            return .Success
        }
        lastMove = time
        xy = direction.getNextPosition(xy, offset: (time-oldTime)*cellsPerSecond)
        node.move(to: xy)
        let nextPosition = (Int(xy.0), Int(xy.1))
        switch(game[nextPosition]) {
        case .Wall, .Exit:
            return .BulletBreaks
        case .Enemy:
            return .EnemyKilled(nextPosition.0, nextPosition.1)
        case .Empty, .Gun, .Player:
            return .Success
        }
    }

    deinit {
        node.removeFromParentNode()
    }
}
