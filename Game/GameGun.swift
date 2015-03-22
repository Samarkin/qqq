import SceneKit

class GameGun {
    private let node: SCNNode
    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int) {
        node = GameGun.createNode()
        node.moveTo((x,y))
        scene.addChildNode(node)
    }

    private class func createNode() -> SCNNode {
        let gunMaterial = SCNMaterial()
        gunMaterial.diffuse.contents = GameColor.greenColor()
        gunMaterial.emission.contents = GameColor.greenColor()
        gunMaterial.emission.intensity = 0.1
        let node = SCNNode()
        node.geometry = SCNCylinder(radius: 0.8, height: 6)
        node.geometry!.materials = [gunMaterial]
        node.rotation = SCNVector4(x: 1, y: 0, z: 0, w: GameFloat(M_PI_2))
        let rotateAction = SCNAction.rotateByAngle(CGFloat(M_PI), aroundAxis: SCNVector3(x: 0, y: 1, z: 0), duration: 1)
        node.runAction(SCNAction.repeatActionForever(rotateAction))
        return node
    }

    deinit {
        node.removeFromParentNode()
    }
}