//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Lidia Chou on 5/5/15.
//  Copyright (c) 2015 Lidia Chou. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won: Bool){
        
        super.init(size: size)
        
        backgroundColor = SKColor.blackColor()
        
        var message = won ? "You Won!" : "You Lose..."
        
        if message == "You Lose..." {
            var loseBgImg = SKSpriteNode(imageNamed: "loseBg")
            loseBgImg.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(loseBgImg)
        } else {
            var wonBgImg = SKSpriteNode(imageNamed: "wonBg")
            wonBgImg.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(wonBgImg)
        }
        
        
        let label = SKLabelNode(fontNamed: "Chalsduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height - 80)
        addChild(label)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }
    
}
