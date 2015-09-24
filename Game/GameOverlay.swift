import SpriteKit

protocol GameOverlay {
    func setLevel(name: String)
    func setBullets(count: Int)
    func gameOver(readyToSwitch: () -> Void)
}

private func createLabel(color color: GameColor) -> SKLabelNode {
    let label = SKLabelNode(fontNamed: "Helvetica")
    label.fontSize = 15
    label.fontColor = color
    return label
}

class GameSpriteKitOverlay: SKScene, GameOverlay {
    private let levelLabel: SKLabelNode
    private let bulletLabel: SKLabelNode

    override init(size: CGSize) {
        levelLabel = createLabel(color: .redColor())
        bulletLabel = createLabel(color: .greenColor())
        bulletLabel.horizontalAlignmentMode = .Left

        super.init(size: size)

        self.addChild(levelLabel)
        self.addChild(bulletLabel)

        //automatically resize to fill the viewport
        self.scaleMode = .AspectFit
    }

    func setLevel(name: String) {
        levelLabel.text = "Level: \(name)"
        levelLabel.position = CGPoint(x: levelLabel.frame.width/2, y: self.size.height - levelLabel.frame.height)
    }

    func setBullets(count: Int) {
        guard count >= 0 else {
            bulletLabel.text = ""
            return
        }
        bulletLabel.text = "Bullets: \(count)"
        bulletLabel.position = CGPoint(x: self.size.width - bulletLabel.frame.width, y: self.size.height - bulletLabel.frame.height)
    }

    func gameOver(readyToSwitch: () -> Void) {
        let text = SKLabelNode(fontNamed: "Helvetica")
        text.fontSize = 114
        text.fontColor = .greenColor()
        text.text = "You're dead!"
        text.horizontalAlignmentMode = .Center
        text.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - text.frame.height/2)
        text.xScale = 0.01
        text.yScale = 0.01

        self.addChild(text)
        let scaleAction = SKAction.scaleTo(1, duration: 0.5)
        text.runAction(scaleAction) {
            readyToSwitch()
            let hideAction = SKAction.fadeAlphaTo(0, duration: 1)
            text.runAction(hideAction) {
                text.removeFromParent()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        levelLabel = createLabel(color: .redColor())
        bulletLabel = createLabel(color: .greenColor())
        super.init(coder: aDecoder)
        return nil
    }
}
