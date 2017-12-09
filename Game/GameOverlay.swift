import SpriteKit

protocol GameOverlay: class {
    var levelName: String? { get set }
    var bulletCount: Int { get set }
    func gameOver(readyToSwitch: @escaping () -> Void)
}

private func createLabel(color: GameColor) -> SKLabelNode {
    let label = SKLabelNode(fontNamed: "Helvetica")
    label.fontSize = 15
    label.fontColor = color
    return label
}

class GameSpriteKitOverlay: SKScene, GameOverlay {
    private let levelLabel: SKLabelNode
    private let bulletLabel: SKLabelNode

    override init(size: CGSize) {
        levelLabel = createLabel(color: .red)
        levelName = nil
        bulletLabel = createLabel(color: .green)
        bulletLabel.horizontalAlignmentMode = .left
        bulletCount = 0

        super.init(size: size)

        self.addChild(levelLabel)
        self.addChild(bulletLabel)

        //automatically resize to fill the viewport
        self.scaleMode = .aspectFit
    }

    var levelName: String? {
        didSet {
            guard let levelName = levelName else {
                levelLabel.text = ""
                return
            }
            levelLabel.text = "Level: \(levelName)"
            levelLabel.position = CGPoint(x: levelLabel.frame.width/2, y: self.size.height - levelLabel.frame.height)
        }
    }

    var bulletCount: Int {
        didSet {
            guard bulletCount >= 0 else {
                bulletLabel.text = ""
                return
            }
            bulletLabel.text = "Bullets: \(bulletCount)"
            bulletLabel.position = CGPoint(x: self.size.width - bulletLabel.frame.width, y: self.size.height - bulletLabel.frame.height)
        }
    }

    func gameOver(readyToSwitch: @escaping () -> Void) {
        let text = SKLabelNode(fontNamed: "Helvetica")
        text.fontSize = 114
        text.fontColor = .green
        text.text = "You're dead!"
        text.horizontalAlignmentMode = .center
        text.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - text.frame.height/2)
        text.xScale = 0.01
        text.yScale = 0.01

        self.addChild(text)
        let scaleAction = SKAction.scale(to: 1, duration: 0.5)
        text.run(scaleAction) {
            readyToSwitch()
            let hideAction = SKAction.fadeAlpha(to: 0, duration: 1)
            text.run(hideAction) {
                text.removeFromParent()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        levelLabel = createLabel(color: .red)
        levelName = nil
        bulletLabel = createLabel(color: .green)
        bulletCount = 0
        super.init(coder: aDecoder)
        return nil
    }
}
