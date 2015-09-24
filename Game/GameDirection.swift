enum GameDirection : Int8 {
    case North = 0
    case East
    case South
    case West
}

extension GameDirection {
    var opposite: GameDirection {
        get {
            return GameDirection(rawValue: (self.rawValue + 2)%4)!
        }
    }
    var right: GameDirection {
        get {
            return GameDirection(rawValue: (self.rawValue + 1)%4)!
        }
    }
    var left: GameDirection {
        get {
            return GameDirection(rawValue: (self.rawValue + 3)%4)!
        }
    }

    func getNextPosition(xy: (x: Int, y: Int)) -> (x: Int, y: Int) {
        let (x,y) = xy
        switch (self) {
        case .North:
            return (x-1, y)
        case .East:
            return (x, y+1)
        case .South:
            return (x+1, y)
        case .West:
            return (x, y-1)
        }
    }

    func getNextPosition(xy: (x: Double, y: Double), offset: Double) -> (x: Double, y: Double) {
        let (x,y) = xy
        switch (self) {
        case .North:
            return (x-offset, y)
        case .East:
            return (x, y+offset)
        case .South:
            return (x+offset, y)
        case .West:
            return (x, y-offset)
        }
    }
}