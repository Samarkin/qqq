import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    var gameEngine: GameEngine!

    override func viewDidLoad() {
        super.viewDidLoad()

        // create a new scene
        let scene = GameSceneImpl()

        // retrieve the SCNView
        let scnView = self.view as! SCNView

        // create overlay
        let overlay = GameSpriteKitOverlay(size: scnView.bounds.size)

        // create engine
        self.gameEngine = GameEngine(scene: scene, overlay: overlay)

        // set the scene to the view
        scnView.scene = scene
        scnView.delegate = self
        scnView.overlaySKScene = overlay

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
        var gestureRecognizers: [UIGestureRecognizer] =
        [
            tapGesture,
            rightSwipeGesture,
            leftSwipeGesture,
            upSwipeGesture,
            downSwipeGesture
        ]
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.appendContentsOf(existingGestureRecognizers)
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

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
