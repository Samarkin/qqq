import Foundation

enum Key {
    case Left, Right, Forward, Backwards, Action
}

protocol KeyEventsDelegate: class {
    func keyDown(key: Key) -> Bool
    func keyUp(key: Key) -> Bool
}

protocol GameController: class {
    func itemAt(coordinates: (Int,Int)) -> GameItem
    func setItemAt(coordinates: (Int,Int), item: GameItem)
}

protocol GameProcessor: class {
    func updateAtTime(time: NSTimeInterval)
}

class GameEngine: GameProcessor, KeyEventsDelegate, GameController {
    private let scene: GameScene
    private var ship: GameShip?
    private var gun: GameGun?
    private var gameField: [[GameItem]]
    private var currentLevel: Int
    private var enemies: [GameEnemy]
    private var bullets: [GameBullet]

    init(scene: GameScene) {
        self.scene = scene
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
            "O" : .Gun,
            "o" : .Gun,
            ">" : .Enemy(.East),
            "<" : .Enemy(.West),
            "^" : .Enemy(.North),
            "v" : .Enemy(.South),
            "V" : .Enemy(.South)
        ]
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "") {
            let x = (try? String(contentsOfFile: path, encoding: NSASCIIStringEncoding)) ?? "P"
            return x.componentsSeparatedByString("\n").map { $0.characters.map { translation[$0] ?? .Empty } }
        }
        return [[.Player]]
    }

    private func loadField(fromFile fileName: String) {
        let field = getField(fromFile: fileName)
        enemies = []
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
                case .Gun:
                    gun = GameGun(onScene: self.scene, withController: self, atX: i, y: j)
                default:
                    break
                }
            }
        }
        assert(x >= 0, "Unable to load \(fileName). A field should contain player item")
        ship = GameShip(onScene: scene, withController: self, atX: x, y: y, facing: .East)
        gameField = field
        GameLevel.loadField(field, toScene: self.scene)
    }

    private func moveShip(dir: GameShip.MoveDirection) {
        switch(ship?.move(dir)) {
        case .Some(.NextLevel):
            loadNextLevel()
        case .Some(.GunFound):
            gun = nil
        case .Some(.GameOver):
            gameOver()
        case .Some(.Success), .None:
            break
        }
    }

    private func gameOver() {
        print("You're dead!")
        reloadLevel()
    }

    func keyDown(key: Key) -> Bool {
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
            case let .EnemyKilled(x, y):
                print("Enemy at \((x,y)) has been killed")
                if let deadEnemyIndex = enemies.indexOf({$0.isAt(x: x, y: y)}) {
                    enemies.removeAtIndex(deadEnemyIndex)
                }
                brokenBullets.append(bullet)
            }
        }
        bullets = bullets.filter { b in
            !brokenBullets.contains { $0 === b }
        }
    }

    func itemAt(coordinates: (Int, Int)) -> GameItem {
        guard coordinates.0 >= 0 && coordinates.0 < gameField.count && coordinates.1 >= 0 && coordinates.1 < gameField[coordinates.0].count else {
            return .Exit
        }
        return gameField[coordinates.0][coordinates.1]
    }

    func setItemAt(coordinates: (Int, Int), item: GameItem) {
        gameField[coordinates.0][coordinates.1] = item
    }
}