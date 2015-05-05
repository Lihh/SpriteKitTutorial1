//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Lidia Chou on 5/4/15.
//  Copyright (c) 2015 Lidia Chou. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Monster : UInt32 = 0b1
    static let Projectile : UInt32 = 0b10
}


//Functions to calculate the projectile course
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //ADDING PLAYER
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        
        //setting gravity 0 and setting the scene as the delegate to be notified when two physics bodies collide
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        //Monstrinhos foreverrr!!!
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
                ])
            )
        )
        
    }
    
    //ADDING MONSTERS
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        //Create Sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        //Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        //Position the monster slightly off-screen along the right edge, and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        addChild(monster)
        
        //setting physicalBody to monsters
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody?.dynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //Speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        //Actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    //SHOOTING PROJECTILES
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in touches as! Set<UITouch> {
            let touchLocation = touch.locationInNode(self)
        
            //Initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "projectile")
            projectile.position = player.position
        
            //Determine offset of location to projectile
            let offset = touchLocation - projectile.position
        
            //Bail out if you are shooting down or backwards
            if offset.x < 0 {
                return
            }
            
            //setting physical bodies to projectiles
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
        
            addChild(projectile)
        
            //Get the direction of where to shoot
            let direction = offset.normalized()
        
            //Make the shoot last more than enough to pass the screen
            let shootAmount = direction * 1000
            let realDest = shootAmount + projectile.position
        
            //Create the actions
            let actionMove = SKAction.moveTo(realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
    }
    
    //PROJECTILE AND MONSTER COLLIDE
    func projectileDidCollideWithMonster (projectile: SKSpriteNode, monster: SKSpriteNode) {
        println("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    func didBeginContact (contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask & PhysicsCategory.Monster != 0 && secondBody.categoryBitMask & PhysicsCategory.Projectile != 0 {
            projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
    }

    
}


