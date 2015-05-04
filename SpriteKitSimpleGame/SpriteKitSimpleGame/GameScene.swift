//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Lidia Chou on 5/4/15.
//  Copyright (c) 2015 Lidia Chou. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
    }
    
}
