import SceneKit

// x points to the north
// y points up
// z points to the east

extension SCNNode {
    func moveTo(xy: (Int, Int)) {
        self.position.x = CGFloat(-xy.0*10)
        self.position.z = CGFloat(xy.1*10)
    }
    func moveTo(xy: (Double, Double)) {
        self.position.x = CGFloat(-xy.0*10)
        self.position.z = CGFloat(xy.1*10)
    }
    func rotateTo(dir: GameDirection) {
        switch(dir) {
        case .North:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI_2))
        case .East:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 0)
        case .South:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(-M_PI_2))
        case .West:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI))
        }
    }
    var elevation: CGFloat {
        get {
            return self.position.y
        }
        set {
            self.position.y = newValue
        }
    }
}