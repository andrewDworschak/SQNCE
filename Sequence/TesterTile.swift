//
//  TesterTile.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-12.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class TesterTile : SKSpriteNode, GameTile {
    var number : Int32
    let gameScene : GameScene
    var lineupPos = 3
    var adjacents = [GameTile]()
    let numLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var destroying = false
    let highlight = SKSpriteNode()
    let white = SKSpriteNode()
    var numConflicts = 0
    var prepped = false
    var prepping = false
    var gameOver = false
    let initialSpace :Bool
    var destroyedThroughCombo = false
    var edgeDist: CGFloat = 0
    var bottomDist: CGFloat = 0
    
    required init(gameScene: GameScene, number: Int32, angle: CGFloat){
        self.gameScene = gameScene
        self.number = number
        self.initialSpace = false
        
        super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: 1, height: 1))
    }
    
    init(gameScene: GameScene, shape: Int, initialSpace: Bool){
        self.gameScene = gameScene
        self.number = 1
        self.initialSpace = initialSpace
        
        if (initialSpace){
            if (shape == 1){ //Square
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.125, height: gameScene.frame.height*0.125))
                edgeDist = self.size.width*0.4725
                bottomDist = self.size.width*0.4725
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.25, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width*0.945, height: self.size.height*0.945))
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
                
            else if (shape == 2) { //Triangle
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.18, height: gameScene.frame.height*0.18))
                edgeDist = self.size.width*0.41
                bottomDist = self.size.width*0.225
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.25, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, 0, self.size.width*0.44)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.385, -self.size.width*0.225)
                CGPathAddLineToPoint(path, nil, self.size.width*0.385, -self.size.width*0.225)
                CGPathAddLineToPoint(path, nil, 0, self.size.width*0.44)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
                
            else if (shape == 3){ //Circle
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.135, height: gameScene.frame.height*0.135))
                edgeDist = self.size.width*0.485
                bottomDist = self.size.width*0.485
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.25, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width*0.485)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
            
            else if (shape == 4){ //Hexagon
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.135, height: gameScene.frame.height*0.135))
                edgeDist = self.size.width*0.47
                bottomDist = self.size.width*0.41
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.25, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, -self.size.width*0.47, 0)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.24, self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, self.size.width*0.24, self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, self.size.width*0.47, 0)
                CGPathAddLineToPoint(path, nil, self.size.width*0.24, -self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.24, -self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.47, 0)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
            
            else if (shape == 5){ //Star
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.18, height: gameScene.frame.height*0.18))
                edgeDist = self.size.width*0.42
                bottomDist = self.size.width*0.37
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.25, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, 0, self.size.width*0.47)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.10, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.42, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.15, -self.size.width*0.04)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.27, -self.size.width*0.37)
                CGPathAddLineToPoint(path, nil, 0, -self.size.width*0.16)
                CGPathAddLineToPoint(path, nil, self.size.width*0.27, -self.size.width*0.37)
                CGPathAddLineToPoint(path, nil, self.size.width*0.15, -self.size.width*0.04)
                CGPathAddLineToPoint(path, nil, self.size.width*0.42, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, self.size.width*0.10, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, 0, self.size.width*0.47)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
            
            else { //Trapezoid
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.15, height: gameScene.frame.height*0.15))
                edgeDist = self.size.width*0.485
                bottomDist = self.size.width*0.275
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.25, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, -self.size.width*0.485, -self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.27, self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, self.size.width*0.27, self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, self.size.width*0.485, -self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.485, -self.size.width*0.275)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
        }
        else{
            gameOver = true
            if (shape == 1){ //Square
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.125, height: gameScene.frame.height*0.125))
                edgeDist = self.size.width*0.4725
                bottomDist = self.size.width*0.4725
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width*0.945, height: self.size.height*0.945))
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.edgeDist = self.size.width*0.4725*sqrt(2)
                    self.bottomDist = self.size.width*0.4725*sqrt(2)
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0))
                    self.runAction(SKAction.rotateToAngle(CGFloat(M_PI/4), duration: 0))
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.removeFromParent()
                    }
                }
                
                
            }
                
            else if (shape == 2) { //Triangle
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.18, height: gameScene.frame.height*0.18))
                edgeDist = self.size.width*0.385
                bottomDist = self.size.width*0.225
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, 0, self.size.width*0.44)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.385, -self.size.width*0.225)
                CGPathAddLineToPoint(path, nil, self.size.width*0.385, -self.size.width*0.225)
                CGPathAddLineToPoint(path, nil, 0, self.size.width*0.44)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.bottomDist = self.size.width*0.44
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0))
                    self.runAction(SKAction.rotateToAngle(CGFloat(M_PI/3), duration: 0))
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.removeFromParent()
                    }
                }
            }
                
            else if (shape == 3){ //Circle
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.135, height: gameScene.frame.height*0.135))
                edgeDist = self.size.width*0.485
                bottomDist = self.size.width*0.485
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width*0.485)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                }
            }
            
            else if (shape == 4){ //Hexagon
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.135, height: gameScene.frame.height*0.135))
                edgeDist = self.size.width*0.47
                bottomDist = self.size.width*0.41
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + self.edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, -self.size.width*0.47, 0)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.24, self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, self.size.width*0.24, self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, self.size.width*0.47, 0)
                CGPathAddLineToPoint(path, nil, self.size.width*0.24, -self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.24, -self.size.width*0.41)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.47, 0)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.edgeDist = self.size.width*0.41
                    self.bottomDist = self.size.width*0.47
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0))
                    self.runAction(SKAction.rotateToAngle(CGFloat(M_PI/6), duration: 0))
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.removeFromParent()
                    }
                }
            }
            
            else if (shape == 5){ //Star
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.18, height: gameScene.frame.height*0.18))
                edgeDist = self.size.width*0.42
                bottomDist = self.size.width*0.37
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, 0, self.size.width*0.47)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.10, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.42, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.15, -self.size.width*0.04)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.27, -self.size.width*0.37)
                CGPathAddLineToPoint(path, nil, 0, -self.size.width*0.16)
                CGPathAddLineToPoint(path, nil, self.size.width*0.27, -self.size.width*0.37)
                CGPathAddLineToPoint(path, nil, self.size.width*0.15, -self.size.width*0.04)
                CGPathAddLineToPoint(path, nil, self.size.width*0.42, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, self.size.width*0.10, self.size.width*0.14)
                CGPathAddLineToPoint(path, nil, 0, self.size.width*0.47)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.bottomDist = self.size.width*0.47
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0))
                    self.runAction(SKAction.rotateToAngle(CGFloat(M_PI/5), duration: 0))
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.removeFromParent()
                    }
                }
            }
            
            else { //Trapezoid
                super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.15, height: gameScene.frame.height*0.15))
                edgeDist = self.size.width*0.485
                bottomDist = self.size.width*0.275
                gameScene.addChild(self)
                self.alpha = 0
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + edgeDist, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, -self.size.width*0.485, -self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.27, self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, self.size.width*0.27, self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, self.size.width*0.485, -self.size.width*0.275)
                CGPathAddLineToPoint(path, nil, -self.size.width*0.485, -self.size.width*0.275)
                
                self.physicsBody = SKPhysicsBody(polygonFromPath: path)
                self.physicsBody!.restitution = 0
                self.physicsBody!.mass = 1
                self.physicsBody!.categoryBitMask = gameScene.TESTERCATEGORY
                self.physicsBody!.contactTestBitMask = gameScene.TILECATEGORY
                self.physicsBody!.collisionBitMask = 0
                self.physicsBody!.affectedByGravity = false
                
                self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.edgeDist = self.size.width*0.275
                    self.bottomDist = self.size.width*0.485
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.2 - self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0))
                    self.runAction(SKAction.rotateToAngle(CGFloat(M_PI/2), duration: 0))
                    self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.2 + self.edgeDist, y: gameScene.frame.height*0.20 + self.bottomDist), duration: 0.25))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.removeFromParent()
                    }
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveAttachments(position: CGPoint){
        
    }
    
    func advance(){
        
    }
    
    func prepare(x: CGFloat){
        
    }
    
    func reset(){
        
    }
    
    func movePrep(x: CGFloat){
        
    }
    
    func launch(x: CGFloat){
        
    }
    
    func buildSequence(){
        
    }
    
    func buildSequence(currSeq: [GameTile]){
        
    }
    
    func destroy(){
        
    }
    
    func orientTo(angle: CGFloat){
        
    }
    
    func rotate(){
        
    }
    
    func swap(secondTile : GameTile){
        
    }
    
    func turnRed(){
        if (initialSpace){
            gameOver = true
        }
    }
    
    func turnBlack() {
        gameOver = false
    }
    
    func changeNumber(num: Int32) {
    }
    func changeLineupPos(newPos: Int){
    }
}