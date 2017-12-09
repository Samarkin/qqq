import SceneKit

private var boxes: [SCNNode] = []

class GameLevel {
    class func load(field: [[GameItem]], toScene scene: GameScene) {
        for box in boxes {
            box.removeFromParentNode()
        }
        boxes = []
        for i in 0..<field.count {
            for j in 0..<field[i].count {
                if field[i][j].isWall {
                    // add a box
                    let box = createNode()
                    box.move(to: (i,j))
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
        let h = Double(arc4random())/Double(UInt32.max)
        let moveUp = SCNAction.moveBy(x: 0.0, y: CGFloat(arc4random()%3) - 3, z: 0.0, duration: 0.5+h)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        moveDown.timingMode = .easeInEaseOut
        return SCNAction.repeatForever(SCNAction.sequence([moveUp, moveDown]))
    }
}
