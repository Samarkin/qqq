import SceneKit

class GameScene {
    private let nativeScene: SCNScene
    init(native: SCNScene) {
        nativeScene = native
    }

    func addChildNode(node: SCNNode) {
        nativeScene.rootNode.addChildNode(node)
    }

    var cameraNode: SCNNode {
        get {
            return nativeScene.rootNode.childNodeWithName("camera", recursively: true)!
        }
    }
}