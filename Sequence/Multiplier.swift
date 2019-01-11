//
//  Multiplier.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-10.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class Multiplier : SKLabelNode {
    
    let gameScene: GameScene
    var timer = 0
    var growing = true
    var level = 0
    var scaling = false
    var interimScore = 0
    let interimScoreLabel = SKLabelNode()
    let arrow = SKSpriteNode(imageNamed: "Arrow.png")
    let overlay = SKLabelNode()
    
    init(gameScene: GameScene){
        self.gameScene = gameScene
        super.init()
        
        self.fontName = "Futura-CondensedExtraBold"
        self.fontSize = 28
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.zPosition = 1
        self.position = CGPoint(x: gameScene.frame.width*0.5+gameScene.frame.height*0.17, y: gameScene.frame.height*0.85)
        
        overlay.fontName = self.fontName
        overlay.fontSize = self.fontSize
        overlay.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        overlay.zPosition = 2
        overlay.position = self.position
        
        
        interimScoreLabel.fontName = "Futura-CondensedExtraBold"
        interimScoreLabel.fontSize = 20
        interimScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        interimScoreLabel.zPosition = 1
        interimScoreLabel.position = CGPoint(x: gameScene.frame.width*0.5+gameScene.frame.height*0.17, y: gameScene.frame.height*0.85 + self.fontSize*0.7)
        
        arrow.size = CGSize(width: gameScene.frame.size.height*0.07, height: gameScene.frame.size.height*0.08)
        arrow.position = CGPoint(x: self.position.x, y: self.position.y+self.fontSize*0.35)
        arrow.zPosition = 3
        arrow.alpha = 0
        
        gameScene.addChild(self)
        gameScene.addChild(interimScoreLabel)
        gameScene.addChild(arrow)
        gameScene.addChild(overlay)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        if (!scaling){
            if (growing){
                self.scaling = true
                self.growing = false
                self.runAction(SKAction.scaleTo(1.2, duration: 1))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.scaling = false
                }
            }
            else{
                self.scaling = true
                self.growing = true
                self.runAction(SKAction.scaleTo(1.0, duration: 1))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.scaling = false
                }
            }
        }
    }
    
    func levelUp(amount: Int){
        self.level += amount
        self.interimScore += amount*100
        self.text = "X" + String(level)
        interimScoreLabel.text = String(interimScore)
        self.alpha = 0
        overlay.text = self.text
        overlay.alpha = 1
        overlay.runAction(SKAction.scaleTo(1.5, duration: 0))
        overlay.runAction(SKAction.scaleTo(1.2, duration: 0.2))
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.overlay.alpha = 0
            self.alpha = 1
        }
    }
    
    func addToInterim(amount: Int){
        self.interimScore += amount
        interimScoreLabel.text = String(interimScore)
    }
    
    func apply(){
        gameScene.score!.add(level*interimScore)
        self.text = " "
        self.interimScoreLabel.text = ""
        self.interimScore = 0
        self.level = 0
        
        arrow.alpha = 1
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.arrow.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
        }
        
        /*let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, self.position.x, self.position.y)
        CGPathAddCurveToPoint(path, nil, (gameScene.score!.position.x + 2*self.position.x)/3 + randNum(), (gameScene.score!.position.y + 2*self.position.y)/3 + randNum(), (2*gameScene.score!.position.x + self.position.x)/3 + randNum(), (2*gameScene.score!.position.y + self.position.y)/3 + randNum(), gameScene.score!.position.x, gameScene.score!.position.y)
        
        let shapeNode = SKShapeNode()
        shapeNode.path = path
        shapeNode.name = "line"
        shapeNode.strokeColor = UIColor.init(colorLiteralRed: 0xff, green: 0xd7, blue: 0x00, alpha: 1.0)
        shapeNode.lineWidth = 1
        shapeNode.zPosition = 11
        
        gameScene.addChild(shapeNode)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            shapeNode.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                shapeNode.removeFromParent()
            }
        }
*/
    }
    
    func randNum() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * gameScene.frame.height*0.06 - gameScene.frame.height*0.03
    }
    
    func orientTo(angle: CGFloat){
        /*var rotation = angle-self.zRotation
        if (rotation > CGFloat(M_PI)){
            rotation -= CGFloat(2*M_PI)
        }
        self.runAction(SKAction.rotateByAngle(rotation, duration: 0.3))*/
    }
}