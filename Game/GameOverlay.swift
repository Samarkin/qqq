import SpriteKit

protocol GameOverlay {
    func setLevel(name: String)
}

private func createLabel(color color: GameColor) -> SKLabelNode {
    let label = SKLabelNode(fontNamed: "Helvetica")
    label.fontSize = 15
    label.fontColor = color
    return label
}

class GameSpriteKitOverlay: SKScene, GameOverlay {
    private let levelLabel: SKLabelNode

    override init(size: CGSize) {
        levelLabel = createLabel(color: .redColor())

        super.init(size: size)

        self.addChild(levelLabel)

        //automatically resize to fill the viewport
        self.scaleMode = .AspectFit
    }

    func setLevel(name: String) {
        levelLabel.text = "Level: \(name)"
        levelLabel.position = CGPoint(x: levelLabel.frame.width/2, y: self.size.height - levelLabel.frame.height)
    }

    required init?(coder aDecoder: NSCoder) {
        levelLabel = createLabel(color: .redColor())
        super.init(coder: aDecoder)
        return nil
    }
}
