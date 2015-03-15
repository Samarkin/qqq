enum GameItem {
    case Wall
    case Player
    case Empty
    case Enemy(GameDirection)
    case Exit
}

extension GameItem {
    var isWall: Bool {
        get {
            switch(self) {
            case .Wall: return true
            default: return false
            }
        }
    }
    var isPlayer: Bool {
        get {
            switch(self) {
            case .Player: return true
            default: return false
            }
        }
    }
    var isEmpty: Bool {
        get {
            switch(self) {
            case .Empty: return true
            default: return false
            }
        }
    }
    var isEnemy: Bool {
        get {
            switch(self) {
            case .Enemy: return true
            default: return false
            }
        }
    }
    var isExit: Bool {
        get {
            switch(self) {
            case .Exit: return true
            default: return false
            }
        }
    }
}