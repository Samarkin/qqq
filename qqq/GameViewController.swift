import SceneKit

class GameViewController: NSViewController, SCNSceneRendererDelegate {
    @IBOutlet weak var gameView: GameView!
    var gameEngine: GameEngine!
    
    override func awakeFromNib(){
        // create a new scene
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

        // create engine
        self.gameEngine = GameEngine(scene: GameScene(native:scene))

        // set the scene to the view
        self.gameView!.scene = scene

        // add game engine
        self.gameView!.delegate = self
        self.gameView!.keyEventsDelegate = self.gameEngine

        // allows the user to manipulate the camera
        //self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.blackColor()
    }

    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        gameEngine.updateAtTime(time)
    }
}
