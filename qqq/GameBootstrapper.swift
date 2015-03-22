import SceneKit

class GameBootstrapper {
    class func prepareScene() -> SCNScene {
        let scene = SCNScene()

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor(calibratedRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.automaticallyAdjustsZRange = true
        scene.rootNode.addChildNode(cameraNode)

        // add floor
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor() as SCNFloor
        floorNode.position = SCNVector3(x: 0, y: -2, z: 0)
        //scene.rootNode.addChildNode(floorNode)
        return scene
    }
}