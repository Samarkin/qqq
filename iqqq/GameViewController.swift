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
        scnView.backgroundColor = .black

        // add gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGesture.direction = .right
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipeGesture.direction = .left
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUpSwipe))
        upSwipeGesture.direction = .up
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDownSwipe))
        downSwipeGesture.direction = .down
        var gestureRecognizers: [UIGestureRecognizer] =
        [
            tapGesture,
            rightSwipeGesture,
            leftSwipeGesture,
            upSwipeGesture,
            downSwipeGesture
        ]
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.append(contentsOf: existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        _ = gameEngine.keyDown(.Action)
    }

    @objc func handleLeftSwipe(_ gestureRecognize: UIGestureRecognizer) {
        _ = gameEngine.keyDown(.Left)
    }

    @objc func handleRightSwipe(_ gestureRecognize: UIGestureRecognizer) {
        _ = gameEngine.keyDown(.Right)
    }

    @objc func handleUpSwipe(_ gestureRecognize: UIGestureRecognizer) {
        _ = gameEngine.keyDown(.Forward)
    }

    @objc func handleDownSwipe(_ gestureRecognize: UIGestureRecognizer) {
        _ = gameEngine.keyDown(.Backwards)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        gameEngine.update(at: time)
    }

    override var prefersStatusBarHidden: Bool { return true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
