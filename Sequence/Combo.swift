//
//  Combo.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-19.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class Combo: SKSpriteNode{
    let gameScene: GameScene
    let comboNum: Int32
    let numLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let numBack : SKShapeNode
    var type : Int32 = 0
    let combosLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let image : SKSpriteNode
    let flash : SKSpriteNode
    var toDestroy = [GameTile]()
    var comboActive = false
    var announcement = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    
    
    init(gameScene: GameScene, comboNum: Int32){
        self.gameScene = gameScene
        self.comboNum = comboNum
        
        flash = SKSpriteNode(texture: nil, color: SKColor.whiteColor(), size: gameScene.size)
        numBack = SKShapeNode(circleOfRadius: gameScene.frame.height*0.015)
        image = SKSpriteNode(texture: nil, color: SKColor.blackColor(), size: CGSize(width: gameScene.frame.height*0.08, height: gameScene.frame.height*0.08))
        
        super.init(texture: SKTexture(imageNamed: "RoundedFrame.png"), color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.08, height: gameScene.frame.height*0.08))
        
        self.zPosition = 5
        self.alpha = 0.6
        
        if (comboNum == 4){
            self.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            
            combosLabel.fontSize = 15
            combosLabel.position = CGPoint(x: self.position.x - self.size.width*0.5, y: self.position.y + self.size.height*0.5)
            combosLabel.text = "Combos:"
            combosLabel.zPosition = 6
            combosLabel.alpha = 0.6
            combosLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            
            numLabel.text = "X4"
            
            gameScene.addChild(combosLabel)
        }
        else { //comboNum == 7
            self.position = CGPoint(x: self.size.width*1.6, y: self.size.height/2)
            numLabel.text = "X7"
        }
        
        numLabel.position = CGPoint(x: self.position.x - self.size.width*0.3, y: self.position.y + self.size.height*0.3)
        numLabel.fontSize = 15
        numLabel.zPosition = 6
        numLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        numLabel.alpha = 0.6
        
        numBack.position = numLabel.position
        numBack.zPosition = 4
        numBack.strokeColor = SKColor.blackColor()
        numBack.fillColor = SKColor.blackColor()
        
        image.position = self.position
        image.zPosition = 3
        
        gameScene.addChild(announcement)
        gameScene.addChild(self)
        gameScene.addChild(numLabel)
        gameScene.addChild(numBack)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCombo(type: Int32){
        if (self.type == 0){
            gameScene.addChild(image)
        }
        self.type = type
        
        if (type == 1){
            self.image.texture = SKTexture(imageNamed: "ComboShape.png")
        }
        else if (type == 2){
            self.image.texture = SKTexture(imageNamed: "ComboLaser.png")
        }
        else if (type == 3){
            self.image.texture = SKTexture(imageNamed: "ComboXplode.png")
        }
    }
    
    func apply(){
        self.comboActive = true
        if(comboNum == 7 && gameScene.combo4!.comboActive == true){
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.25*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.apply()
            }
        }
        else if (type == 0 || gameScene.tiles.count-gameScene.toDestroy.count<=0){
            //do nothing
            self.comboActive = false
        }
        else {
            
            var settled = true
            for tile in gameScene.tiles{
                if (tile.destroying || tile.physicsBody!.velocity.dx + tile.physicsBody!.velocity.dy > 1){
                    settled = false
                    break
                }
            }
            if (!settled){
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.apply()
                }
            }
            else{
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    for tile in self.gameScene.tiles{
                        if (tile.destroying || tile.physicsBody!.velocity.dx + tile.physicsBody!.velocity.dy > 1){
                            settled = false
                            break
                        }
                    }
                    if (!settled){
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1*Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.apply()
                        }
                    }
                    else {
                        self.useCombo()
                    }
                }
            }
        }
    }
    func useCombo(){
        if(self.type == 1){ //Shape
            let shape = Int(arc4random_uniform(self.gameScene.totalShapes))+1
            var numDestroyed = 0
            for tile in self.gameScene.tiles{
                switch shape{
                case 1:
                    if(tile is SquareTile){
                        if (!self.gameScene.toDestroy.contains({$0.position == tile.position}) && !tile.destroying){
                            self.toDestroy.append(tile)
                            numDestroyed += 1
                        }
                    }
                    break
                case 2:
                    if(tile is TriangleTile){
                        if (!self.gameScene.toDestroy.contains({$0.position == tile.position}) && !tile.destroying){
                            self.toDestroy.append(tile)
                            numDestroyed += 1
                        }
                    }
                    break
                case 3:
                    if(tile is CircleTile){
                        if (!self.gameScene.toDestroy.contains({$0.position == tile.position}) && !tile.destroying){
                            self.toDestroy.append(tile)
                            numDestroyed += 1
                        }
                    }
                    break
                case 4:
                    if(tile is HexagonTile){
                        if (!self.gameScene.toDestroy.contains({$0.position == tile.position}) && !tile.destroying){
                            self.toDestroy.append(tile)
                            numDestroyed += 1
                        }
                    }
                    break
                case 5:
                    if(tile is StarTile){
                        if (!self.gameScene.toDestroy.contains({$0.position == tile.position}) && !tile.destroying){
                            self.toDestroy.append(tile)
                            numDestroyed += 1
                        }
                    }
                    break
                default:
                    if(tile is TrapezoidTile){
                        if (!self.gameScene.toDestroy.contains({$0.position == tile.position}) && !tile.destroying){
                            self.toDestroy.append(tile)
                            numDestroyed += 1
                        }
                    }
                    break
                }
            }
            if (numDestroyed == 0 && self.gameScene.tiles.count-self.gameScene.toDestroy.count>0){
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.02*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.apply()
                }
            }
            else {
                gameScene.announcementCentre!.newAnnouncement("X" + String(comboNum) + " Combo Activated")
                if (gameScene.tiles.count - toDestroy.count == 0){
                    gameScene.clearBoard()
                }
                var links = [SKShapeNode]()
                for i in 0..<self.toDestroy.count-1{
                    let path = CGPathCreateMutable()
                    CGPathMoveToPoint(path, nil, self.toDestroy[i].position.x, self.toDestroy[i].position.y)
                    CGPathAddLineToPoint(path, nil, self.toDestroy[i+1].position.x, self.toDestroy[i+1].position.y)
                    
                    links.append(SKShapeNode(path: path))
                    links[i].strokeColor = SKColor.whiteColor()
                    links[i].lineWidth = 5
                    links[i].zPosition = 7
                    links[i].alpha = 0
                    self.gameScene.addChild(links[i])
                    links[i].runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
                }
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    for tile in self.toDestroy{
                        if (!tile.destroying){
                            tile.destroy()
                            self.gameScene.multiplier!.addToInterim(100)
                        }
                    }
                    if (!self.gameScene.soundPlaying){
                        self.gameScene.soundPlaying = true
                        self.gameScene.hiss.play()
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(1.1*Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.gameScene.soundPlaying = false
                        }
                    }
                    self.toDestroy.removeAll()
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        for link in links{
                            link.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                        }
                        self.comboActive = false
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            for link in links{
                                link.removeFromParent()
                            }
                        }
                    }
                }
            }
        }
        else if (self.type == 2){ //Laser
            gameScene.announcementCentre!.newAnnouncement("X" + String(comboNum) + " Combo Activated")
            let pointer1 = SKSpriteNode(imageNamed: "Pointer.png")
            let pointer2 = SKSpriteNode(imageNamed: "Pointer.png")
            
            let startPoint = CGFloat(self.gameScene.frame.height*0.5)
            var highestPoint = self.gameScene.frame.height*0.8
            for tile in self.gameScene.tiles{
                if (tile.position.y - tile.bottomDist<highestPoint){
                    highestPoint = tile.position.y - tile.bottomDist
                }
            }
            let endPoint = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (self.gameScene.frame.height*0.76 - highestPoint) + highestPoint
            
            pointer1.size = CGSize(width: self.gameScene.size.height*0.02, height: self.gameScene.size.height*0.02)
            pointer2.size = pointer1.size
            pointer2.zRotation = CGFloat(M_PI)
            
            pointer1.position = CGPoint(x: self.gameScene.frame.width/2 - self.gameScene.frame.height*0.225, y: startPoint)
            pointer2.position = CGPoint(x: self.gameScene.frame.width/2 + self.gameScene.frame.height*0.225, y: startPoint)
            
            pointer1.alpha = 0
            pointer2.alpha = 0
            
            pointer1.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.3))
            pointer2.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.3))
            
            pointer1.runAction(SKAction.moveTo(CGPoint(x: self.gameScene.frame.width/2 - self.gameScene.frame.height*0.225, y: endPoint), duration: 1))
            pointer2.runAction(SKAction.moveTo(CGPoint(x: self.gameScene.frame.width/2 + self.gameScene.frame.height*0.225, y: endPoint), duration: 1))
            
            self.gameScene.addChild(pointer1)
            self.gameScene.addChild(pointer2)
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(1.0*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                let laser = SKSpriteNode(imageNamed: "Laser.png")
                laser.alpha = 0
                laser.position = CGPoint(x: self.gameScene.frame.width/2, y: endPoint)
                laser.size = CGSize(width: self.gameScene.frame.height*0.4, height: self.gameScene.frame.height*0.04)
                laser.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                laser.zPosition = 7
                laser.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: laser.size.width, height: 1))
                laser.physicsBody!.categoryBitMask = self.gameScene.TESTBOXCATEGORY
                laser.physicsBody!.dynamic = false
                laser.physicsBody!.collisionBitMask = 0
                laser.physicsBody!.contactTestBitMask = self.gameScene.TILECATEGORY
                self.gameScene.addChild(laser)
                self.gameScene.laser.play()

                
                let time2 = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1*Double(NSEC_PER_SEC)))
                dispatch_after(time2, dispatch_get_main_queue()) {
                    laser.physicsBody = nil
                }
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.8*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    laser.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                    pointer1.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                    pointer2.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                    self.comboActive = false
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        laser.removeFromParent()
                        pointer1.removeFromParent()
                        pointer2.removeFromParent()
                    }
                }
            }
            
        }
            
        else if (self.type == 3){ //Xplode
            gameScene.announcementCentre!.newAnnouncement("X" + String(comboNum) + " Combo Activated")
            if (gameScene.tiles.count == 1){
                gameScene.clearBoard()
            }
            if (self.gameScene.tiles.count-self.gameScene.toDestroy.count>0){
                var tile = self.gameScene.tiles[Int(arc4random_uniform(UInt32(self.gameScene.tiles.count)))]
                while (tile.destroying || self.gameScene.toDestroy.contains({$0.position == tile.position})){
                    tile = self.gameScene.tiles[Int(arc4random_uniform(UInt32(self.gameScene.tiles.count)))]
                }
                let circle = SKShapeNode(circleOfRadius: self.gameScene.frame.height*0.2)
                circle.strokeColor = SKColor.orangeColor()
                circle.fillColor = SKColor.clearColor()
                circle.lineWidth = 3
                circle.position = tile.position
                circle.zPosition = 7
                self.gameScene.addChild(circle)
                circle.runAction(SKAction.scaleTo(0, duration: 1))
                self.gameScene.multiplier!.addToInterim(100)
                let timeTillDestroy = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
                dispatch_after(timeTillDestroy, dispatch_get_main_queue()) {
                    self.gameScene.xplosion.play()
                    let timeTillDestroy = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1*Double(NSEC_PER_SEC)))
                    dispatch_after(timeTillDestroy, dispatch_get_main_queue()) {
                    tile.destroy()
                    }
                }
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(1.0*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    circle.runAction(SKAction.scaleTo(1, duration: 0.3))
                    var rings = [SKShapeNode]()
                    for i in 1...4{
                        rings.append(SKShapeNode(circleOfRadius: self.gameScene.frame.height*0.04*CGFloat(i)))
                        rings[i-1].strokeColor = SKColor.orangeColor()
                        rings[i-1].fillColor = SKColor.clearColor()
                        rings[i-1].lineWidth = 3
                        rings[i-1].position = tile.position
                        rings[i-1].zPosition = 7
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.06*Double(i)*Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.gameScene.addChild(rings[i-1])
                        }
                        
                    }
                    rings.first!.fillColor = SKColor.orangeColor()
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        let gravField = SKFieldNode.radialGravityField()
                        gravField.categoryBitMask = self.gameScene.GRAVFIELD
                        gravField.strength = -20.0
                        circle.addChild(gravField)
                        
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            circle.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                            gravField.removeFromParent()
                            for ring in rings{
                                ring.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                            }
                            self.comboActive = false
                            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
                            dispatch_after(time, dispatch_get_main_queue()) {
                                circle.removeFromParent()
                                for ring in rings{
                                    ring.removeFromParent()
                                }
                            }
                        }
                    }
                }
            }
            else {
                self.comboActive = false
            }
        }
    }
    
    func laserHitTile(tile: GameTile){
        if (!tile.destroying){
            tile.destroy()
            gameScene.multiplier!.addToInterim(100)
            toDestroy.append(tile)
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.toDestroy.removeAtIndex(self.toDestroy.indexOf({$0.position == tile.position})!)
            }
            if (gameScene.tiles.count - toDestroy.count == 0){
                gameScene.clearBoard()
            }
        }
    }
    
}