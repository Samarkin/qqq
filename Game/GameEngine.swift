import Foundation

enum Key {
    case Left, Right, Forward, Backwards, Action
}

protocol KeyEventsDelegate: class {
    func keyDown(_ key: Key) -> Bool
    func keyUp(_ key: Key) -> Bool
}

protocol GameController: class {
    subscript(_ coordinates: (Int,Int)) -> GameItem { get set }
}

protocol GameProcessor: class {
    func update(at time: TimeInterval)
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
        currentLevel += 1
        loadField(fromFile: levels[currentLevel%levels.count])
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
        if let path = Bundle.main.path(forResource: fileName, ofType: ""),
            let x = try? String(contentsOfFile: path, encoding: .ascii) {
            return x.components(separatedBy: "\n").map { $0.map { translation[$0] ?? .Empty } }
        }
        return [[.Player]]
    }

    private func loadField(fromFile fileName: String) {
        overlay.levelName = fileName
        let field = getField(fromFile: fileName)
        enemies = []
        gun = nil
        var x = -1, y = -1
        for (i,line) in field.enumerated() {
            for (j,cell) in line.enumerated() {
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
        GameLevel.load(field: field, toScene: self.scene)
        updateOverlay()
    }

    private func moveShip(dir: GameShip.MoveDirection) {
        switch(ship?.move(dir: dir)) {
        case .some(.NextLevel):
            loadNextLevel()
        case .some(.GunFound):
            gun = nil
            updateOverlay()
        case .some(.GameOver):
            gameOver()
        case .some(.Success), .none:
            break
        }
    }

    private func updateOverlay() {
        if let ship = ship {
            overlay.bulletCount = ship.bullets
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

    func keyDown(_ key: Key) -> Bool {
        guard !freeze else {
            return false
        }
        switch(key) {
        case .Left:
            ship?.rotate(dir: .Left)
            return true
        case .Right:
            ship?.rotate(dir: .Right)
            return true
        case .Backwards:
            moveShip(dir: .Backwards)
            return true
        case .Forward:
            moveShip(dir: .Forward)
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

    func keyUp(_ key: Key) -> Bool {
        return false
    }

    func update(at time: TimeInterval) {
        for enemy in enemies {
            switch(enemy.move(at: time)) {
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
            switch(bullet.move(at: time)) {
            case .Success:
                break
            case .BulletBreaks:
                print("Bullet dies")
                brokenBullets.append(bullet)
                ship?.bulletDies()
            case let .EnemyKilled(x, y):
                print("Enemy at \((x,y)) has been killed")
                if let deadEnemyIndex = enemies.index(where: {$0.isAt(x: x, y: y)}) {
                    enemies.remove(at: deadEnemyIndex)
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

    subscript(_ coordinates: (Int, Int)) -> GameItem {
        get {
            guard coordinates.0 >= 0 && coordinates.0 < gameField.count && coordinates.1 >= 0 && coordinates.1 < gameField[coordinates.0].count else {
                return .Exit
            }
            return gameField[coordinates.0][coordinates.1]
        }
        set {
            gameField[coordinates.0][coordinates.1] = newValue
        }
    }
}
