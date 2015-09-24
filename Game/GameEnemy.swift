import SceneKit

class GameEnemy {
    private let node: SCNNode
    private weak var game: GameController!
    private var direction: GameDirection
    private var oldXY: (x: Int, y: Int)?
    private var xy: (x: Int, y: Int)
    private let stepTime: NSTimeInterval = 1
    private var timeToMove = true

    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection, number: Int) {
        xy = (x, y)
        direction = dir
        game = controller
        node = GameEnemy.createNode(bodyColor: colors[number%colors.count])
        node.rotateTo(dir)
        node.moveTo((x,y))
        scene.addChildNode(node)
    }

    private let colors = [
        GameColor.redColor(),
        GameColor.yellowColor(),
        GameColor.greenColor(),
        GameColor.blueColor(),
        GameColor.orangeColor()
    ]

    func move(time: NSTimeInterval) -> GameMoveResult {
        guard timeToMove else {
            return .Success
        }
        timeToMove = false
        let nextPosition = direction.getNextPosition(xy)
        if game.itemAt(nextPosition).isPlayer {
            return .GameOver
        }
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(stepTime)
        SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
        if game.itemAt(nextPosition).isEmpty {
            oldXY = xy
            xy = nextPosition
            game.setItemAt(xy, item: .Enemy(direction))
            node.moveTo(xy)
        } else {
            direction = direction.opposite
            node.rotation.w = node.rotation.w + GameFloat(M_PI)
            oldXY = nil
        }
        SCNTransaction.setCompletionBlock { [weak self] in
            if let me = self, oldxy = me.oldXY {
                me.game.setItemAt(oldxy, item: .Empty)
            }
            self?.timeToMove = true
        }
        SCNTransaction.commit()
        return .Success
    }

    func isAt(x x: Int, y: Int) -> Bool {
        return xy.x == x && xy.y == y
            || oldXY?.x == x && oldXY?.y == y
    }

    private class func createNode(bodyColor bodyColor: GameColor) -> SCNNode {
        let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = bodyColor
        bodyMaterial.emission.contents = bodyColor
        bodyMaterial.emission.intensity = 1
        let eyeMaterial = SCNMaterial()
        eyeMaterial.diffuse.contents = GameColor.whiteColor()
        eyeMaterial.emission.contents = GameColor.whiteColor()
        eyeMaterial.emission.intensity = 1
        let light = SCNLight()
        light.type = SCNLightTypeOmni
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
        game?.setItemAt(xy, item: .Empty)
        if let oldxy = oldXY {
            game?.setItemAt(oldxy, item: .Empty)
        }
        node.removeFromParentNode()
    }
}