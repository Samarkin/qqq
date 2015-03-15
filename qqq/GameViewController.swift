//
//  GameViewController.swift
//  qqq
//
//  Created by Pavel Samarkin on 12/10/14.
//  Copyright (c) 2014 Pavel Samarkin. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController, SCNSceneRendererDelegate {
    @IBOutlet weak var gameView: GameView!
    var gameEngine: GameEngine!
    
    override func awakeFromNib(){
        // create a new scene
        // TODO: load ship in GameShip, not here
        let scene = SCNScene(named: "art.scnassets/ship.dae")!

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 4, z: -15)
        cameraNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI))

        // create and add a light to the scene
        let light = SCNLight()
        light.type = SCNLightTypeSpot
        light.spotInnerAngle = 0.1
        light.spotInnerAngle = 0.2
        light.castsShadow = true
        light.shadowColor = NSColor.blackColor()

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: CGFloat(M_PI))
        lightNode.position = SCNVector3(x: 0, y: 2, z: 0)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor(calibratedRed: 0.2, green: 0.2, blue: 0.2, alpha: 0)
        scene.rootNode.addChildNode(ambientLightNode)

        // retrieve the ship node
        var shipNode = scene.rootNode.childNodeWithName("ship", recursively: true)!

        // group a player
        shipNode.removeFromParentNode()
        var player = SCNNode()
        player.name = "player"
        //player.pivot = SCNMatrix4MakeTranslation(0, 0, -7.5)
        player.addChildNode(cameraNode)
        player.addChildNode(shipNode)
        player.addChildNode(lightNode)
        scene.rootNode.addChildNode(player)

        // add floor
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor() as SCNFloor
        floorNode.position = SCNVector3(x: 0, y: -2, z: 0)
        //scene.rootNode.addChildNode(floorNode)

        // create engine
        self.gameEngine = GameEngine(scene: scene)

        // set the scene to the view
        self.gameView!.scene = scene

        // add game engine
        self.gameView!.delegate = self.gameEngine
        self.gameView!.keyEventsHandler = self.gameEngine

        // allows the user to manipulate the camera
        //self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.blackColor()
    }
}
