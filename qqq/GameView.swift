//
//  GameView.swift
//  qqq
//
//  Created by Pavel Samarkin on 12/10/14.
//  Copyright (c) 2014 Pavel Samarkin. All rights reserved.
//

import SceneKit


class GameView: SCNView {
    weak var keyEventsHandler : KeyEventsHandler?

    override func keyDown(theEvent: NSEvent) {
        if let handler = keyEventsHandler {
            if !handler.keyDown(theEvent) {
                super.keyDown(theEvent)
            }
        }
    }

    override func keyUp(theEvent: NSEvent) {
        if let handler = keyEventsHandler {
            if !handler.keyUp(theEvent) {
                super.keyUp(theEvent)
            }
        }
    }

    
}