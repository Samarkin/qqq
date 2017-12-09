import SceneKit

protocol GameScene : class {
    func addChildNode(_ node: SCNNode)
    var cameraNode: SCNNode { get }
}

class GameSceneImpl : SCNScene, GameScene {
    override init() {
        super.init()
        // create and add an ambient light to the scene
        let light = SCNLight()
        light.type = .ambient
        light.color = GameColor(red:0.2, green: 0.2, blue: 0.2, alpha: 1)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = light
        rootNode.addChildNode(ambientLightNode)

        // create and add a camera to the scene
        let camera = SCNCamera()
        camera.automaticallyAdjustsZRange = true
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = camera
        rootNode.addChildNode(cameraNode)

        // add floor
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.position = SCNVector3(x: 0, y: -2, z: 0)
        //rootNode.addChildNode(floorNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        return nil
    }

    func addChildNode(_ node: SCNNode) {
        rootNode.addChildNode(node)
    }

    var cameraNode: SCNNode {
        get {
            return rootNode.childNode(withName: "camera", recursively: true)!
        }
    }
}
