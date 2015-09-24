import SceneKit

// x points to the north
// y points up
// z points to the east

extension SCNNode {
    func moveTo(xy: (x: Int, y: Int)) {
        self.position.x = GameFloat(-xy.x*10)
        self.position.z = GameFloat(xy.y*10)
    }
    func moveTo(xy: (x: Double, y: Double)) {
        self.position.x = GameFloat(-xy.x*10)
        self.position.z = GameFloat(xy.y*10)
    }
    func rotateTo(dir: GameDirection) {
        switch(dir) {
        case .North:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: GameFloat(M_PI_2))
        case .East:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 0)
        case .South:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: GameFloat(-M_PI_2))
        case .West:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: GameFloat(M_PI))
        }
    }
    var elevation: GameFloat {
        get {
            return self.position.y
        }
        set {
            self.position.y = newValue
        }
    }
}