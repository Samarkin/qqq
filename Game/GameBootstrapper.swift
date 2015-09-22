import SceneKit

class GameBootstrapper {
    class func prepareScene() -> SCNScene {
        let scene = SCNScene()

        // create and add an ambient light to the scene
        let light = SCNLight()
        light.type = SCNLightTypeAmbient
        light.color = GameColor(red:0.2, green: 0.2, blue: 0.2, alpha: 1)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = light
        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a camera to the scene
        let camera = SCNCamera()
        camera.automaticallyAdjustsZRange = true
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)

        // add floor
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.position = SCNVector3(x: 0, y: -2, z: 0)
        //scene.rootNode.addChildNode(floorNode)
        return scene
    }
}