//
//  TrapezoidTile.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-18.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class TrapezoidTile: SKSpriteNode, GameTile {
    var number : Int32
    let gameScene : GameScene
    var lineupPos = 3
    var adjacents = [GameTile]()
    let numLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var destroying = false
    let highlight = SKSpriteNode(imageNamed: "TrapezoidHighlight.png")
    let white = SKSpriteNode(imageNamed: "TrapezoidWhite.png")
    var numConflicts = 0
    var prepped = false
    var prepping = false
    var destroyedThroughCombo = false
    var edgeDist: CGFloat = 0
    var bottomDist: CGFloat = 0
    
    
    required init(gameScene: GameScene, number: Int32, angle: CGFloat) {
        self.number = number
        self.gameScene = gameScene
        let texture = SKTexture(imageNamed: "Trapezoid.png")
        
        super.init(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.05, height: gameScene.frame.height*0.05))
        edgeDist = self.size.width*0.485*3/self.xScale
        bottomDist = self.size.width*0.275*3/self.xScale
        
        self.zPosition = 2
        self.position = CGPoint(x: gameScene.frame.width*0.825, y: gameScene.frame.height*0.1375)
        self.alpha = 0
        
        numLabel.zPosition = 4
        numLabel.position = self.position
        numLabel.alpha = 0
        numLabel.fontSize = 12
        numLabel.text = String(number)
        numLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        numLabel.zRotation = angle
        
        highlight.size = CGSize(width: self.size.width*3.0, height: self.size.height*3.0)
        highlight.alpha = 0
        white.alpha = 0
        white.size = CGSize(width: self.size.width*3.0, height: self.size.height*3.0)
        highlight.zPosition = 4
        white.zPosition = 4
        
        self.gameScene.addChild(self)
        self.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
        self.gameScene.addChild(numLabel)
        numLabel.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveAttachments(position: CGPoint) {
        numLabel.position = position
        if (destroying){
            highlight.position = position
            highlight.zRotation = self.zRotation
            white.position = position
            white.zRotation = self.zRotation
        }
    }
    
    func advance(){
        switch lineupPos{
        case 2:
            self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5, y: gameScene.frame.height*0.15), duration: 0.05))
            self.runAction(SKAction.scaleTo(1.5, duration: 0.05))
            numLabel.fontSize = 18
            lineupPos -= 1
            break
        case 3:
            self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.675, y: gameScene.frame.height*0.1375), duration: 0.05))
            lineupPos -= 1
            break
        default:
            break
        }
    }
    
    func prepare(x: CGFloat){
        
        self.prepping = true
        self.runAction(SKAction.moveTo(CGPoint(x: x, y: gameScene.frame.height*0.20 + bottomDist), duration: 0.03))
        self.runAction(SKAction.scaleTo(3, duration: 0.03))
        numLabel.fontSize = 24
        self.gameScene.sweep.play()
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.04*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, -self.size.width*0.485, -self.size.width*0.275)
            CGPathAddLineToPoint(path, nil, -self.size.width*0.27, self.size.width*0.275)
            CGPathAddLineToPoint(path, nil, self.size.width*0.27, self.size.width*0.275)
            CGPathAddLineToPoint(path, nil, self.size.width*0.485, -self.size.width*0.275)
            CGPathAddLineToPoint(path, nil, -self.size.width*0.485, -self.size.width*0.275)
            
            self.numConflicts = 0
            self.physicsBody = SKPhysicsBody(polygonFromPath: path)
            self.physicsBody!.restitution = 0
            self.physicsBody!.mass = 1
            self.physicsBody!.categoryBitMask = self.gameScene.TESTERCATEGORY
            self.physicsBody!.contactTestBitMask = self.gameScene.TILECATEGORY
            self.physicsBody!.collisionBitMask = 0
            self.physicsBody!.affectedByGravity = false
            self.physicsBody!.fieldBitMask = 0
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.01*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.prepped = true
                self.prepping = false
            }
        }
        
    }
    
    func reset(){
        self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5, y: gameScene.frame.height*0.15), duration: 0.05))
        self.runAction(SKAction.scaleTo(1.5, duration: 0.05))
        numLabel.fontSize = 18
        prepped = false
        self.gameScene.sweepback.play()
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.05*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.numConflicts = 0
            self.turnBlack()
            self.prepped = false
        }
    }
    
    func movePrep(x: CGFloat){
        
        self.runAction(SKAction.moveTo(CGPoint(x: x, y: gameScene.frame.height*0.20 + bottomDist), duration: 0))
        
    }
    
    func launch(x: CGFloat){
        self.physicsBody!.categoryBitMask = gameScene.TILECATEGORY
        self.physicsBody!.collisionBitMask = gameScene.TILECATEGORY | gameScene.BOXCATEGORY
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.fieldBitMask = gameScene.GRAVFIELD
        self.numConflicts = 0
        self.turnBlack()
        self.gameScene.snare.play()
    }
    
    func buildSequence(){
        var currSeq = [GameTile]()
        currSeq.append(self)
        for adjacent in adjacents{
            adjacent.buildSequence(currSeq)
        }
    }
    
    func buildSequence(currSeq: [GameTile]){
        var valid = true
        for tile in currSeq{
            if (self.number == tile.number){
                valid = false
            }
        }
        if (valid) {
            var newSeq = [GameTile]()
            for tile in currSeq {
                newSeq.append(tile)
            }
            newSeq.append(self)
            for adjacent in adjacents{
                adjacent.buildSequence(newSeq)
            }
            if (newSeq.count >= 3){
                for tile in newSeq{
                    if (!gameScene.toDestroy.contains({$0.position == tile.position})){
                        gameScene.toDestroy.append(tile)
                        if (!destroying && newSeq.count > gameScene.longestChain){
                            gameScene.longestChain = newSeq.count
                            gameScene.longestChainTile = self
                        }
                    }
                }
            }
        }
    }
    
    func destroy(){
        if (!destroying){
            destroying = true
            self.gameScene.addChild(self.highlight)
            highlight.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.gameScene.addChild(self.white)
                self.white.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.removeFromParent()
                    self.highlight.removeFromParent()
                    self.white.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                    self.numLabel.removeFromParent()
                    self.gameScene.tiles.removeAtIndex(self.gameScene.tiles.indexOf({$0.position == self.position})!)
                    for var adjacent in self.adjacents{
                        if (adjacent.adjacents.contains({$0.position == self.position})){
                            adjacent.adjacents.removeAtIndex(adjacent.adjacents.indexOf({$0.position == self.position})!)
                            self.adjacents.removeAtIndex(self.adjacents.indexOf({$0.position == adjacent.position})!)
                        }
                    }
                    for cable in self.gameScene.cables{
                        if (cable.tileA.position == self.position || cable.tileB.position == self.position){
                            self.gameScene.cables.removeAtIndex(self.gameScene.cables.indexOf({$0.serial == cable.serial})!)
                            cable.remove()
                        }
                    }
                    self.destroying = false
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.white.removeFromParent()
                    }
                }
            }
        }
    }
    
    func orientTo(angle: CGFloat){
        var rotation = angle-numLabel.zRotation
        if (rotation > CGFloat(M_PI)){
            rotation -= CGFloat(2*M_PI)
        }
        self.numLabel.runAction(SKAction.rotateByAngle(rotation, duration: 0.3))
    }
    
    func rotate() {
        self.runAction(SKAction.rotateByAngle(CGFloat(-M_PI/2), duration: 0.3))
        if (edgeDist == self.size.width*0.275*3/self.xScale){
            edgeDist = self.size.width*0.485*3/self.xScale
            bottomDist = self.size.width*0.275*3/self.xScale
        }
        else {
            edgeDist = self.size.width*0.275*3/self.xScale
            bottomDist = self.size.width*0.485*3/self.xScale
        }
    }
    
    func swap(secondTile: GameTile) {
        (secondTile as! SKSpriteNode).runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.5, y: gameScene.frame.height*0.15), duration: 0.3))
        (secondTile as! SKSpriteNode).runAction(SKAction.scaleTo(1.5, duration: 0.3))
        secondTile.numLabel.fontSize = 18
        secondTile.changeLineupPos(1)
        
        self.runAction(SKAction.moveTo(CGPoint(x: gameScene.frame.width*0.675, y: gameScene.frame.height*0.1375), duration: 0.3))
        self.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        self.numLabel.fontSize = 12
        self.lineupPos = 2
        
        gameScene.loadedTiles.insert(gameScene.loadedTiles.removeFirst(), atIndex: 1)
    }
    
    func turnRed() {
        self.texture = SKTexture(imageNamed: "TrapezoidRed.png")
    }
    
    func turnBlack() {
        self.texture = SKTexture(imageNamed: "Trapezoid.png")
    }
    
    func changeNumber(num: Int32) {
        self.number = num
        self.numLabel.text = String(num)
    }
    
    func changeLineupPos(newPos: Int){
        self.lineupPos = newPos
    }
}