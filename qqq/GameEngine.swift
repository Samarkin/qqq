import Foundation
import SceneKit

public protocol KeyEventsHandler: class {
    func keyDown(theEvent: NSEvent) -> Bool
    func keyUp(theEvent: NSEvent) -> Bool
}

public protocol GameController: class {
    func itemAt(coordinates: (Int,Int)) -> GameItem
    func setItemAt(coordinates: (Int,Int), item: GameItem)
}

class GameEngine : NSObject, SCNSceneRendererDelegate, KeyEventsHandler, GameController {
    private unowned let scene: SCNScene
    private let ship: GameShip!
    private var gameField: [[GameItem]]
    private var currentLevel: Int
    private var enemies: [GameEnemy]

    init(scene: SCNScene) {
        self.scene = scene
        var playerNode = scene.rootNode.childNodeWithName("player", recursively: false)!
        currentLevel = -1
        enemies = []
        gameField = [[]]
        super.init()
        ship = GameShip(playerNode: playerNode, withController: self)
        loadNextLevel()
    }

    private let levels = [
        //"testLevel",
        "level0",
        "level1",
        "level2"
    ]

    private func reloadLevel() {
        loadField(fromFile: levels[currentLevel%levels.count])
    }

    private func loadNextLevel() {
        // TODO: check result
        loadField(fromFile: levels[(++currentLevel)%levels.count])
    }

    private func getField(fromFile fileName: String) -> [[GameItem]] {
        let translation: [Character:GameItem] = [
            "X" : .Wall,
            "." : .Empty,
            "P" : .Player,
            ">" : .Enemy(.East),
            "<" : .Enemy(.West),
            "^" : .Enemy(.North),
            "v" : .Enemy(.South),
            "V" : .Enemy(.South)
        ]
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "") {
            var err: NSErrorPointer = nil
            var x = String(contentsOfFile: path, encoding: NSASCIIStringEncoding, error: err) ?? "P"
            return map(x.componentsSeparatedByString("\n")) { map($0.generate()) { translation[$0] ?? .Empty } }
        }
        return [[.Player]]
    }

    private func loadField(fromFile fileName: String) -> Bool {
        var field = getField(fromFile: fileName)
        enemies = []
        var x = -1, y = -1
        for i in 0..<field.count {
            for j in 0..<field[i].count {
                switch (field[i][j]) {
                case .Player:
                    x = i
                    y = j
                case let .Enemy(direction):
                    enemies.append(GameEnemy(onScene: self.scene, withController: self, atX: i, y: j, facing: direction, number: enemies.count))
                default:
                    break
                }
            }
        }
        if x < 0 {
            return false
        }
        ship.reset(x, y, dir:.East)
        gameField = field
        GameLevel.loadField(field, toScene: self.scene)
        return true
    }

    func keyDown(theEvent: NSEvent) -> Bool {
        if theEvent.keyCode == 123 {
            ship.rotate(.Left)
            return true
        } else if theEvent.keyCode == 124 {
            ship.rotate(.Right)
            return true
        } else if theEvent.keyCode == 125 {
            moveShip(.Backwards)
            return true
        } else if theEvent.keyCode == 126 {
            moveShip(.Forward)
            return true
        } else {
            return false
        }
    }

    private func moveShip(dir: GameShip.MoveDirection) {
        switch(ship.move(dir)) {
        case .NextLevel:
            loadNextLevel()
        case .GameOver:
            gameOver()
        case .Success:
            break
        }
    }

    private func gameOver() {
        print("You're dead!")
        reloadLevel()
    }

    func keyUp(theEvent: NSEvent) -> Bool {
        return false
    }

    func renderer(aRenderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
    }

    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
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
            }
        }
    }

    func itemAt(coordinates: (Int, Int)) -> GameItem {
        if coordinates.0 < 0 || coordinates.0 >= gameField.count || coordinates.1 < 0 || coordinates.1 >= gameField[coordinates.0].count {
            return .Exit
        }
        return gameField[coordinates.0][coordinates.1]
    }

    func setItemAt(coordinates: (Int, Int), item: GameItem) {
        gameField[coordinates.0][coordinates.1] = item
    }
}