import SceneKit

// x points to the north
// y points up
// z points to the east

extension GameDirection {
    var asRotationVector: SCNVector4 {
        get {
            switch(self) {
            case .North:
                return SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI_2))
            case .East:
                return SCNVector4(x: 0, y: 1, z: 0, w: 0)
            case .South:
                return SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(-M_PI_2))
            case .West:
                return SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI))
            }
        }
    }
}

extension SCNNode {
    func moveTo(xy: (Int, Int)) {
        self.position.x = CGFloat(-xy.0*10)
        self.position.z = CGFloat(xy.1*10)
    }
    func moveTo(xy: (Double, Double)) {
        self.position.x = CGFloat(-xy.0*10)
        self.position.z = CGFloat(xy.1*10)
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