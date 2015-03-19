import SceneKit

class GameEnemy {
    private let node: SCNNode
    private weak var game: GameController!
    private var direction: GameDirection
    private var oldXY: (Int, Int)?
    private var xy: (Int, Int)
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
        NSColor.redColor(),
        NSColor.yellowColor(),
        NSColor.greenColor(),
        NSColor.blueColor(),
        NSColor.orangeColor()
    ]

    func move(time: NSTimeInterval) -> GameMoveResult {
        if (timeToMove) {
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
                node.rotation.w = node.rotation.w + CGFloat(M_PI)
                oldXY = nil
            }
            SCNTransaction.setCompletionBlock { [weak self] in
                if let oldxy = self?.oldXY {
                    self?.game.setItemAt(oldxy, item: .Empty)
                }
                self?.timeToMove = true
            }
            SCNTransaction.commit()
        }
        return .Success
    }

    func isAt(#x: Int, y: Int) -> Bool {
        return xy.0 == x && xy.1 == y
            || oldXY?.0 == x && oldXY?.1 == y
    }

    private class func createNode(#bodyColor: NSColor) -> SCNNode {
        let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = bodyColor
        bodyMaterial.emission.contents = bodyColor
        bodyMaterial.emission.intensity = 1
        let eyeMaterial = SCNMaterial()
        eyeMaterial.diffuse.contents = NSColor.whiteColor()
        eyeMaterial.emission.contents = NSColor.whiteColor()
        eyeMaterial.emission.intensity = 1
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        light.attenuationStartDistance = 5.0
        light.attenuationEndDistance = 15.0
        light.color = bodyColor
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 5)
        node.geometry!.materials = [bodyMaterial]
        node.light = light

        let eye = SCNNode()
        eye.geometry = SCNSphere(radius: 1)
        eye.geometry?.materials = [eyeMaterial]
        eye.position = SCNVector3(x: -1, y: 1.5, z: 4.2)
        node.addChildNode(eye)

        let eye2 = SCNNode()
        eye2.geometry = SCNSphere(radius: 1)
        eye2.geometry!.materials = [eyeMaterial]
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