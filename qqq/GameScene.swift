//
//  GameScene.swift
//  qqq
//
//  Created by Pavel Samarkin on 3/15/15.
//  Copyright (c) 2015 Pavel Samarkin. All rights reserved.
//

import Foundation
import SceneKit

class GameScene {
    private let nativeScene: SCNScene
    init(native: SCNScene) {
        nativeScene = native
    }

    func addChildNode(node: SCNNode) {
        nativeScene.rootNode.addChildNode(node)
    }

    var cameraNode: SCNNode {
        get {
            return nativeScene.rootNode.childNodeWithName("camera", recursively: true)!
        }
    }
}