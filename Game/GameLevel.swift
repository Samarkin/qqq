import SceneKit

private var boxes: [SCNNode] = []

class GameLevel {
    class func loadField(field: [[GameItem]], toScene scene: GameScene) {
        for box in boxes {
            box.removeFromParentNode()
        }
        boxes = []
        for i in 0..<field.count {
            for j in 0..<field[i].count {
                if field[i][j].isWall {
                    // add a box
                    let box = createNode()
                    box.moveTo((i,j))
                    boxes.append(box)
                    scene.addChildNode(box)
                }
            }
        }
    }

    private class func createNode() -> SCNNode {
        let box = SCNNode()
        box.name = "box"
        box.geometry = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 1)
        box.elevation = 3.0
        box.runAction(getHoverAction())
        return box
    }

    private class func getHoverAction() -> SCNAction {
        let h = Double(random())/Double(RAND_MAX)
        let moveUp = SCNAction.moveByX(0.0, y: CGFloat(random()%5 - 5), z: 0.0, duration: 0.5+h)
        moveUp.timingMode = .EaseInEaseOut
        let moveDown = moveUp.reversedAction()
        moveDown.timingMode = .EaseInEaseOut
        return SCNAction.repeatActionForever(SCNAction.sequence([moveUp, moveDown]))
    }
}