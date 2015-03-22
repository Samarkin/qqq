import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    var gameEngine: GameEngine!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = GameBootstrapper.prepareScene()

        // create engine
        self.gameEngine = GameEngine(scene: GameScene(native: scene))

        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // set the scene to the view
        scnView.scene = scene
        scnView.delegate = self
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleRightSwipe:")
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleLeftSwipe:")
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleUpSwipe:")
        upSwipeGesture.direction = UISwipeGestureRecognizerDirection.Up
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleDownSwipe:")
        downSwipeGesture.direction = UISwipeGestureRecognizerDirection.Down
        var gestureRecognizers: [AnyObject] =
        [
            tapGesture,
            rightSwipeGesture,
            leftSwipeGesture,
            upSwipeGesture,
            downSwipeGesture
        ]
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.extend(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        gameEngine.keyDown(.Action)
    }

    func handleLeftSwipe(gestureRecognize: UIGestureRecognizer) {
        gameEngine.keyDown(.Left)
    }

    func handleRightSwipe(gestureRecognize: UIGestureRecognizer) {
        gameEngine.keyDown(.Right)
    }

    func handleUpSwipe(gestureRecognize: UIGestureRecognizer) {
        gameEngine.keyDown(.Forward)
    }

    func handleDownSwipe(gestureRecognize: UIGestureRecognizer) {
        gameEngine.keyDown(.Backwards)
    }

    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        gameEngine.updateAtTime(time)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
