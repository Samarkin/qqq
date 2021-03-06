import SceneKit

// x points to the north
// y points up
// z points to the east

extension SCNNode {
    func move(to xy: (Int, Int)) {
        self.position.x = GameFloat(-xy.0*10)
        self.position.z = GameFloat(xy.1*10)
    }
    func move(to xy: (Double, Double)) {
        self.position.x = GameFloat(-xy.0*10)
        self.position.z = GameFloat(xy.1*10)
    }
    func rotate(to dir: GameDirection) {
        switch(dir) {
        case .North:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: .pi/2)
        case .East:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 0)
        case .South:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: .pi/2)
        case .West:
            self.rotation = SCNVector4(x: 0, y: 1, z: 0, w: .pi)
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
