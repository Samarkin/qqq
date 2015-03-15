import Foundation
import SceneKit

public extension GameDirection {
    // x points to the north
    // z points to the east
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