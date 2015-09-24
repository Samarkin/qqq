import Foundation

enum Key {
    case Left, Right, Forward, Backwards, Action
}

protocol KeyEventsDelegate: class {
    func keyDown(key: Key) -> Bool
    func keyUp(key: Key) -> Bool
}

protocol GameController: class {
    func itemAt(coordinates: (x: Int, y: Int)) -> GameItem
    func setItemAt(coordinates: (x: Int, y: Int), item: GameItem)
}

protocol GameProcessor: class {
    func updateAtTime(time: NSTimeInterval)
}

class GameEngine: GameProcessor, KeyEventsDelegate, GameController {
    private let scene: GameScene
    private let overlay: GameOverlay
    private var ship: GameShip?
    private var gun: GameGun?
    private var gameField: [[GameItem]]
    private var currentLevel: Int
    private var enemies: [GameEnemy]
    private var bullets: [GameBullet]

    private var freeze = false

    init(scene: GameScene, overlay: GameOverlay) {
        self.scene = scene
        self.overlay = overlay
        currentLevel = -1
        enemies = []
        bullets = []
        gameField = [[]]
        loadNextLevel()
    }

    private let levels = [
        "level0",
        "level1",
        "level2",
        "level3",
        "level4",
    ]

    private func reloadLevel() {
        loadField(fromFile: levels[currentLevel%levels.count])
    }

    private func loadNextLevel() {
        loadField(fromFile: levels[(++currentLevel)%levels.count])
    }

    private func getField(fromFile fileName: String) -> [[GameItem]] {
        let translation: [Character:GameItem] = [
            "X" : .Wall,
            "." : .Empty,
            "P" : .Player,
            "O" : .Gun(6),
            "o" : .Gun(2),
            ">" : .Enemy(.East),
            "<" : .Enemy(.West),
            "^" : .Enemy(.North),
            "v" : .Enemy(.South),
            "V" : .Enemy(.South)
        ]
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: ""),
            x = try? String(contentsOfFile: path, encoding: NSASCIIStringEncoding) {
                return x.componentsSeparatedByString("\n").map { $0.characters.map { translation[$0] ?? .Empty } }
        }
        return [[.Player]]
    }

    private func loadField(fromFile fileName: String) {
        overlay.setLevel(fileName)
        let field = getField(fromFile: fileName)
        enemies = []
        gun = nil
        var x = -1, y = -1
        for (i,line) in field.enumerate() {
            for (j,cell) in line.enumerate() {
                switch (cell) {
                case .Player:
                    assert(x < 0, "Unable to load \(fileName). A field cannot contain more than one player")
                    x = i
                    y = j
                case let .Enemy(direction):
                    let enemy = GameEnemy(onScene: self.scene, withController: self, atX: i, y: j, facing: direction, number: enemies.count)
                    enemies.append(enemy)
                case let .Gun(bullets):
                    assert(gun == nil, "Unable to load \(fileName). A field cannot contain more than one gun")
                    gun = GameGun(onScene: self.scene, withController: self, atX: i, y: j, bullets: bullets)
                default:
                    break
                }
            }
        }
        assert(x >= 0, "Unable to load \(fileName). A field should contain player item")
        ship = GameShip(onScene: scene, withController: self, atX: x, y: y, facing: .East)
        gameField = field
        GameLevel.loadField(field, toScene: self.scene)
        updateOverlay()
    }

    private func moveShip(dir: GameShip.MoveDirection) {
        switch(ship?.move(dir)) {
        case .Some(.NextLevel):
            loadNextLevel()
        case .Some(.GunFound):
            gun = nil
            updateOverlay()
        case .Some(.GameOver):
            gameOver()
        case .Some(.Success), .None:
            break
        }
    }

    private func updateOverlay() {
        if let ship = ship {
            overlay.setBullets(ship.bullets)
        }
    }

    private func gameOver() {
        print("You're dead!")
        freeze = true
        overlay.gameOver {
            self.reloadLevel()
            self.freeze = false
        }
    }

    func keyDown(key: Key) -> Bool {
        guard !freeze else {
            return false
        }
        switch(key) {
        case .Left:
            ship?.rotate(.Left)
            return true
        case .Right:
            ship?.rotate(.Right)
            return true
        case .Backwards:
            moveShip(.Backwards)
            return true
        case .Forward:
            moveShip(.Forward)
            return true
        case .Action:
            if let bullet = ship?.shoot() {
                updateOverlay()
                bullets.append(bullet)
                return true
            }
            return false
        }
    }

    func keyUp(key: Key) -> Bool {
        return false
    }

    func updateAtTime(time: NSTimeInterval) {
        for enemy in enemies {
            switch(enemy.move(time)) {
            case .Success:
                break
            case .NextLevel:
                loadNextLevel()
                return
            case .GameOver:
                gameOver()
                return
            case .GunFound:
                assertionFailure("Enemy's move cannot lead to .GunFound")
            }
        }
        var brokenBullets = [GameBullet]()
        for bullet in bullets {
            switch(bullet.move(time)) {
            case .Success:
                break
            case .BulletBreaks:
                print("Bullet dies")
                brokenBullets.append(bullet)
                ship?.bulletDies()
            case let .EnemyKilled(x, y):
                print("Enemy at \((x,y)) has been killed")
                if let deadEnemyIndex = enemies.indexOf({$0.isAt(x: x, y: y)}) {
                    enemies.removeAtIndex(deadEnemyIndex)
                }
                brokenBullets.append(bullet)
                ship?.bulletDies()
            }
        }
        bullets = bullets.filter { b in
            !brokenBullets.contains { $0 === b }
        }
        updateOverlay()
    }

    func itemAt(coordinates: (x: Int, y: Int)) -> GameItem {
        guard 0..<gameField.count ~= coordinates.x && 0..<gameField[coordinates.x].count ~= coordinates.y else {
            return .Exit
        }
        return gameField[coordinates.x][coordinates.y]
    }

    func setItemAt(coordinates: (x: Int, y: Int), item: GameItem) {
        gameField[coordinates.x][coordinates.y] = item
    }
}