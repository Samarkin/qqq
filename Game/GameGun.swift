import SceneKit

class GameGun {
    private let node: SCNNode
    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, bullets: Int) {
        node = GameGun.createNode(bullets: bullets)
        node.move(to: (x,y))
        scene.addChildNode(node)
    }

    private class func createNode(bullets: Int) -> SCNNode {
        let gunMaterial = SCNMaterial()
        gunMaterial.diffuse.contents = GameColor.green
        gunMaterial.emission.contents = GameColor.green
        gunMaterial.emission.intensity = 0.1
        let cylinder = SCNCylinder(radius: 0.4, height: 3)
        cylinder.materials = [gunMaterial]
        let rootNode = SCNNode()

        let margin: GameFloat = 0.1
        let angleStep = 2 * .pi/GameFloat(bullets)
        let radius = (2*GameFloat(cylinder.radius) + margin) / (2 * sin(angleStep/2))
        for i in 0..<bullets {
            let node = SCNNode()
            node.geometry = cylinder
            node.position = SCNVector3(x: radius*cos(GameFloat(i)*angleStep), y: radius*sin(GameFloat(i)*angleStep), z: 0)
            node.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi/2)
            rootNode.addChildNode(node)
        }

        let rotateAction = SCNAction.rotate(by: .pi, around: SCNVector3(x: 0, y: 1, z: 0), duration: 1)
        rootNode.runAction(SCNAction.repeatForever(rotateAction))
        return rootNode
    }

    deinit {
        node.removeFromParentNode()
    }
}
