import SceneKit

class GameEnemy {
    private let node: SCNNode
    private weak var game: GameController!
    private var direction: GameDirection
    private var oldXY: (Int, Int)?
    private var xy: (Int, Int)
    private let stepTime: TimeInterval = 1
    private var timeToMove = true

    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection, number: Int) {
        xy = (x, y)
        direction = dir
        game = controller
        node = GameEnemy.createNode(bodyColor: colors[number%colors.count])
        node.rotate(to: dir)
        node.move(to: (x,y))
        scene.addChildNode(node)
    }

    private let colors: [GameColor] = [
        .red,
        .yellow,
        .green,
        .blue,
        .orange
    ]

    func move(at time: TimeInterval) -> GameMoveResult {
        guard timeToMove else {
            return .Success
        }
        timeToMove = false
        let nextPosition = direction.getNextPosition(xy)
        if game[nextPosition].isPlayer {
            return .GameOver
        }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = stepTime
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        if game[nextPosition].isEmpty {
            oldXY = xy
            xy = nextPosition
            game[xy] = .Enemy(direction)
            node.move(to: xy)
        } else {
            direction = direction.opposite
            node.rotation.w = node.rotation.w + .pi
            oldXY = nil
        }
        SCNTransaction.completionBlock = { [weak self] in
            if let me = self, let oldxy = me.oldXY {
                me.game[oldxy] = .Empty
            }
            self?.timeToMove = true
        }
        SCNTransaction.commit()
        return .Success
    }

    func isAt(x: Int, y: Int) -> Bool {
        return xy.0 == x && xy.1 == y
            || oldXY?.0 == x && oldXY?.1 == y
    }

    private class func createNode(bodyColor: GameColor) -> SCNNode {
        let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = bodyColor
        bodyMaterial.emission.contents = bodyColor
        bodyMaterial.emission.intensity = 1
        let eyeMaterial = SCNMaterial()
        eyeMaterial.diffuse.contents = GameColor.white
        eyeMaterial.emission.contents = GameColor.white
        eyeMaterial.emission.intensity = 1
        let light = SCNLight()
        light.type = .omni
        light.attenuationStartDistance = 5.0
        light.attenuationEndDistance = 15.0
        light.color = bodyColor
        let bodySphere = SCNSphere(radius: 5)
        bodySphere.materials = [bodyMaterial]
        let node = SCNNode()
        node.geometry = bodySphere
        node.light = light

        let eyeSphere = SCNSphere(radius: 1)
        eyeSphere.materials = [eyeMaterial]
        let eye = SCNNode()
        eye.geometry = eyeSphere
        eye.position = SCNVector3(x: -1, y: 1.5, z: 4.2)
        node.addChildNode(eye)

        let eyeSphere2 = SCNSphere(radius: 1)
        eyeSphere2.materials = [eyeMaterial]
        let eye2 = SCNNode()
        eye2.geometry = eyeSphere2
        eye2.position = SCNVector3(x: 1, y: 1.5, z: 4.2)
        node.addChildNode(eye2)

        node.elevation = 3.0
        return node
    }

    deinit {
        game?[xy] = .Empty
        if let oldxy = oldXY {
            game?[oldxy] = .Empty
        }
        node.removeFromParentNode()
    }
}
