import SceneKit

class GameViewController: NSViewController, SCNSceneRendererDelegate {
    @IBOutlet weak var gameView: GameView!
    var gameEngine: GameEngine!
    
    override func awakeFromNib(){
        // create a new scene
        let scene = GameBootstrapper.prepareScene()

        // create engine
        self.gameEngine = GameEngine(scene: GameScene(native:scene))

        // set the scene to the view
        self.gameView!.scene = scene

        // add game engine
        self.gameView!.delegate = self
        self.gameView!.keyEventsDelegate = self.gameEngine

        // show statistics such as fps and timing information
        //self.gameView!.showsStatistics = true

        // configure the view
        self.gameView!.backgroundColor = NSColor.blackColor()
    }

    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        gameEngine.updateAtTime(time)
    }
}
