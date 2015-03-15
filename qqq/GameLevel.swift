import Foundation
import SceneKit

public class GameLevel {
    public class func loadField(field: [[GameItem]], toScene scene: SCNScene) {
        for box in (scene.rootNode.childNodesPassingTest { $0.0.name == "box" }) {
            box.removeFromParentNode()
        }
        for i in 0..<field.count {
            for j in 0..<field[i].count {
                if field[i][j].isWall {
                    // add a box
                    var box = SCNNode()
                    box.name = "box"
                    box.geometry = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 1)
                    box.position = SCNVector3(x: CGFloat(-i*10), y: CGFloat(3.0), z: CGFloat(j*10))
                    box.runAction(getHoverAction())
                    scene.rootNode.addChildNode(box)
                }
            }
        }
    }

    private class func getHoverAction() -> SCNAction {
        var h = Double(random())/Double(RAND_MAX)
        var moveUp = SCNAction.moveByX(0.0, y: CGFloat(random()%5 - 5), z: 0.0, duration: 0.5+h)
        moveUp.timingMode = .EaseInEaseOut
        var moveDown = moveUp.reversedAction()
        moveDown.timingMode = .EaseInEaseOut
        return SCNAction.repeatActionForever(SCNAction.sequence([moveUp, moveDown]))
    }
}