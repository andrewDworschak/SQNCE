//
//  PauseButton.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-25.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode {
    let gameScene : GameScene
    var actionInProgress = false
    let giveUpTop = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let giveUpBottom = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var giveUpShown = false
    var flashing = false
    
    
    init(gameScene: GameScene){
        self.gameScene = gameScene
        
        super.init(texture: SKTexture(imageNamed: "Pause.png"), color: SKColor.blackColor(), size: CGSize(width: gameScene.frame.height*0.04, height: gameScene.frame.height*0.04))
        
        self.position = CGPoint(x: gameScene.frame.width - self.size.width, y: gameScene.frame.height*0.85 + 10)
        self.zPosition = 11
        self.alpha = 0.6
        gameScene.addChild(self)
        
        giveUpTop.position = CGPoint(x: self.position.x, y: self.position.y+9)
        giveUpTop.zPosition = 11
        giveUpTop.alpha = 0
        giveUpTop.text = "Give"
        giveUpTop.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        giveUpTop.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        giveUpTop.fontSize = 16
        gameScene.addChild(giveUpTop)
        
        giveUpBottom.position = CGPoint(x: self.position.x, y: self.position.y-9)
        giveUpBottom.zPosition = 11
        giveUpBottom.alpha = 0
        giveUpBottom.text = "Up?"
        giveUpBottom.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        giveUpBottom.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        giveUpBottom.fontSize = 16
        gameScene.addChild(giveUpBottom)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pauseGame(){
        if (!actionInProgress){
            actionInProgress = true
            for item in gameScene.menuItems{
                item.appear()
            }
            self.texture = SKTexture(imageNamed: "Resume.png")
            gameScene.physicsWorld.speed = 0.0
            gameScene.waiting = true
            gameScene.addChild(gameScene.menuCover)
            if (!flashing){
                self.giveUpTop.alpha = 0
                self.giveUpBottom.alpha = 0
            }
            else {
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.giveUpTop.alpha = 0
                    self.giveUpBottom.alpha = 0
                }
            }
            self.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
            gameScene.menuCover.runAction(SKAction.fadeAlphaTo(0.8, duration: 0.5))
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.actionInProgress = false
            }
        }
        
    }
    
    func resumeGame(){
        if (!actionInProgress){
            giveUpShown = false
            actionInProgress = true
            for item in gameScene.menuItems{
                item.disappear()
            }
            self.texture = SKTexture(imageNamed: "Pause.png")
            self.runAction(SKAction.fadeAlphaTo(0.6, duration: 0.5))
            gameScene.menuCover.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.gameScene.physicsWorld.speed = 1.0
                self.gameScene.waiting = false
                self.gameScene.menuCover.removeFromParent()
                self.actionInProgress = false
            }
        }
    }
    
    func flashGiveUp(){
        if (!flashing){
            flashing = true
            if (!giveUpShown){
                giveUpShown = true
                self.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.giveUpTop.runAction(SKAction.fadeAlphaTo(0.6, duration: 0.3))
                    self.giveUpBottom.runAction(SKAction.fadeAlphaTo(0.6, duration: 0.3))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.flashing = false
                        
                    }
                }
            }
            else {
                giveUpShown = false
                self.giveUpTop.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                self.giveUpBottom.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.runAction(SKAction.fadeAlphaTo(0.6, duration: 0.3))
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.flashing = false
                        
                    }
                    
                }
            }
        }
        else {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.flashGiveUp()
            }
        }
        
    }
}