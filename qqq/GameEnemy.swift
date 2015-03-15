import Foundation
import SceneKit

public class GameEnemy {
    private var node: SCNNode
    private unowned let game: GameController
    private var direction: GameDirection
    private var x,y: Int
    private var stepTime: NSTimeInterval = 1
    private var timeToMove = true

    init(onScene scene: SCNScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection, number: Int) {
        self.x = x
        self.y = y
        direction = dir
        game = controller
        node = GameEnemy.createNodeAt(x, y, dir:dir, bodyColor: colors[number%colors.count])
        scene.rootNode.addChildNode(node)
    }

    private let colors = [
        NSColor.redColor(),
        NSColor.yellowColor(),
        NSColor.greenColor(),
        NSColor.blueColor(),
    ]

    public func move(time: NSTimeInterval) -> GameMoveResult {
        if (timeToMove) {
            timeToMove = false
            let oldPosition = (x,y)
            var nextPosition = direction.getNextPosition(x, y)
            if game.itemAt(nextPosition).isPlayer {
                return .GameOver
            }
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(stepTime)
            SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
            var move: Bool
            if game.itemAt(nextPosition).isEmpty {
                (x,y) = nextPosition
                game.setItemAt(nextPosition, item: .Enemy(direction))
                node.position = SCNVector3(x: CGFloat(-x*10), y: CGFloat(3.0), z: CGFloat(y*10))
                move = true
            } else {
                direction = direction.opposite
                node.rotation.w = node.rotation.w + CGFloat(M_PI)
                move = false
            }
            SCNTransaction.setCompletionBlock { [weak self] in
                if move {
                    self?.game.setItemAt(oldPosition, item: .Empty)
                }
                self?.timeToMove = true
            }
            SCNTransaction.commit()
        }
        return .Success
    }

    private class func createNodeAt(x: Int, _ y: Int, dir: GameDirection, bodyColor: NSColor) -> SCNNode {
        var bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = bodyColor
        bodyMaterial.emission.contents = bodyColor
        bodyMaterial.emission.intensity = 1
        var eyeMaterial = SCNMaterial()
        eyeMaterial.diffuse.contents = NSColor.whiteColor()
        eyeMaterial.emission.contents = NSColor.whiteColor()
        eyeMaterial.emission.intensity = 1
        var light = SCNLight()
        light.type = SCNLightTypeOmni
        light.attenuationStartDistance = 5.0
        light.attenuationEndDistance = 15.0
        light.color = bodyColor
        var node = SCNNode()
        node.geometry = SCNSphere(radius: 5)
        node.geometry!.materials = [bodyMaterial]
        node.light = light

        var eye = SCNNode()
        eye.geometry = SCNSphere(radius: 1)
        eye.geometry?.materials = [eyeMaterial]
        eye.position = SCNVector3(x: -1, y: 1.5, z: 4.2)
        node.addChildNode(eye)

        var eye2 = SCNNode()
        eye2.geometry = SCNSphere(radius: 1)
        eye2.geometry!.materials = [eyeMaterial]
        eye2.position = SCNVector3(x: 1, y: 1.5, z: 4.2)
        node.addChildNode(eye2)

        node.rotation = dir.asRotationVector
        node.position = SCNVector3(x: CGFloat(-x*10), y: CGFloat(3.0), z: CGFloat(y*10))
        return node
    }

    deinit {
        node.removeFromParentNode()
    }
}