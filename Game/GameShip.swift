import SceneKit

class GameShip {
    private let node: SCNNode
    private unowned let game: GameController
    private unowned let scene: GameScene
    private var xy: (x: Int, y: Int)
    private var direction: GameDirection
    private(set) var bullets = Int.min

    init(onScene scene: GameScene, withController controller: GameController, atX x: Int, y: Int, facing dir: GameDirection) {
        self.scene = scene
        let camera = scene.cameraNode
        camera.removeFromParentNode()
        node = GameShip.createNode(camera: camera)
        scene.addChildNode(node)
        game = controller

        xy = (x,y)
        node.moveTo(xy)
        direction = dir
        node.rotateTo(dir)
    }

    private class func createNode(camera camera: SCNNode) -> SCNNode {
        let scene = SCNScene(named: "art.scnassets/ship.dae")!
        let shipNode = scene.rootNode.childNodeWithName("ship", recursively: true)!

        SCNTransaction.setAnimationDuration(0)
        // place the camera
        camera.position = SCNVector3(x: 0, y: 4, z: -15)
        camera.rotation = SCNVector4(x: 0, y: 1, z: 0, w: GameFloat(M_PI))

        // create and add a light to the scene
        let light = SCNLight()
        light.type = SCNLightTypeSpot
        light.spotInnerAngle = 0.1
        light.spotInnerAngle = 0.2
        light.castsShadow = true
        light.shadowColor = GameColor.blackColor()

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: GameFloat(M_PI))
        lightNode.position = SCNVector3(x: 0, y: 2, z: 0)

        // group a player
        let player = SCNNode()
        player.name = "player"
        player.addChildNode(camera)
        player.addChildNode(shipNode)
        player.addChildNode(lightNode)
        player.elevation = 0.0
        scene.rootNode.addChildNode(player)
        return player
    }

    func rotate(dir: RotateDirection) {
        SCNTransaction.setAnimationDuration(0.5)
        switch(dir) {
        case .Left:
            direction = direction.left
            node.rotation.w += GameFloat(M_PI_2)
        case .Right:
            direction = direction.right
            node.rotation.w -= GameFloat(M_PI_2)
        }
        print("Ship is at \(xy) facing \(direction.rawValue)")
    }

    func move(dir: MoveDirection) -> GameMoveResult {
        let moveDirection = dir == .Forward ? direction : direction.opposite
        let next = moveDirection.getNextPosition(xy)
        print("Ship next is at \(next)")
        switch(game.itemAt(next)) {
        case .Empty:
            SCNTransaction.setAnimationDuration(0.5)
            game.setItemAt(xy, item: .Empty)
            xy = next
            node.moveTo(xy)
            game.setItemAt(xy, item: .Player)
            return .Success
        case .Gun(let bullets):
            SCNTransaction.setAnimationDuration(0.5)
            game.setItemAt(xy, item: .Empty)
            xy = next
            node.moveTo(xy)
            game.setItemAt(xy, item: .Player)
            self.bullets = bullets
            return .GunFound
        case .Enemy:
            return .GameOver
        case .Exit:
            return .NextLevel
        default:
            return .Success
        }
    }

    func shoot() -> GameBullet? {
        guard bullets >= 2 else {
            return nil
        }
        bullets -= 2
        print("Shoot!")
        return GameBullet(onScene: self.scene, withController: self.game, atX: xy.x, y: xy.y, facing: direction)
    }

    func bulletDies() {
        bullets += 2
    }

    deinit {
        node.removeFromParentNode()
    }

    enum RotateDirection {
        case Left
        case Right
    }

    enum MoveDirection {
        case Forward
        case Backwards
    }
}
