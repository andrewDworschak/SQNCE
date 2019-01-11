//
//  Score.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-10.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class Score : SKLabelNode {
    
    let gameScene: GameScene
    var score = 0
    let border = SKSpriteNode(imageNamed: "ScoreBorder.png")
    let logo = SKSpriteNode(imageNamed: "Logo.png")
    let finalScoreText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let highscoreText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let newPersonalBest = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    
    init(gameScene: GameScene){
        self.gameScene = gameScene
        super.init()
        
        self.fontName = "Futura-CondensedExtraBold"
        self.fontSize = 30
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        self.zPosition = 8
        self.fontColor = SKColor.whiteColor()
        self.position = CGPoint(x: gameScene.frame.width*0.5 + gameScene.frame.height*0.12, y: gameScene.frame.height*0.85+8)
        self.alpha = 0.4
        self.text = "0"
        
        border.size = CGSize(width: gameScene.frame.height*0.34, height: gameScene.frame.height*0.08)
        border.position = CGPoint(x: gameScene.frame.width*0.5-gameScene.frame.height*0.035, y: gameScene.frame.height*0.85 + 10)
        border.zPosition = 8
        border.alpha = 0.4
        
        logo.size = CGSize(width: gameScene.frame.height*0.075, height: gameScene.frame.height*0.075)
        logo.position = CGPoint(x: gameScene.frame.width*0.5 - gameScene.frame.height*0.17, y: gameScene.frame.height*0.85 + 10)
        logo.zPosition = 8
        
        gameScene.addChild(logo)
        gameScene.addChild(self)
        gameScene.addChild(border)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(amount: Int){
        self.score+=amount
        if (score<1000){
            self.text = String(score)
        }
        else if (score<1000000){
            self.text = String(format: "%3d,%03d", score/1000, score%1000)
        }
        else {
            self.text = String(format: "%3d,%03d,%03d", score/1000000, (score%1000000)/1000, score%1000)
        }
        self.alpha = 1
        border.alpha = 1
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(Double(NSEC_PER_SEC)*0.5))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.runAction(SKAction.fadeAlphaTo(0.4, duration: 0.5))
            self.border.runAction(SKAction.fadeAlphaTo(0.4, duration: 0.5))
        }
    }
    
    func orientTo(angle: CGFloat){
        /*if (angle == 0){
            self.runAction(SKAction.rotateToAngle(angle, duration: 0))
            self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        }
        else if (angle == CGFloat(M_PI)){
            self.runAction(SKAction.rotateToAngle(angle, duration: 0))
            self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        }*/
    }
    
    func displayGameOver(){
        
        self.runAction(SKAction.moveBy(CGVector(dx: gameScene.frame.height*0.035, dy: -gameScene.frame.height*0.12), duration: 0.5))
        self.border.runAction(SKAction.moveBy(CGVector(dx: gameScene.frame.height*0.035, dy: -gameScene.frame.height*0.12), duration: 0.5))
        self.logo.runAction(SKAction.moveBy(CGVector(dx: gameScene.frame.height*0.035, dy: -gameScene.frame.height*0.12), duration: 0.5))
        self.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
        self.border.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
        self.logo.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
        
        finalScoreText.position = CGPoint(x: gameScene.frame.width*0.5, y: gameScene.frame.height*0.8)
        finalScoreText.zPosition = 11
        finalScoreText.alpha = 0
        finalScoreText.text = "Final Score:"
        finalScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        finalScoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        finalScoreText.fontSize = 36
        gameScene.addChild(finalScoreText)
        
        highscoreText.position = CGPoint(x: gameScene.frame.width*0.5, y: gameScene.frame.height*0.65)
        highscoreText.zPosition = 11
        highscoreText.alpha = 0
        highscoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        highscoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        highscoreText.fontSize = 18
        gameScene.addChild(highscoreText)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let highScore = defaults.stringForKey("highScore") {
            if (Int(highScore) != nil && self.score<Int(highScore)){
                 highscoreText.text = "Highscore: " + highScore
            }
            else {
                defaults.setValue(String(self.score), forKey: "highScore")
                if (Int(highScore) != nil){
                    highscoreText.text = "Old Highscore: " + highScore
                }
                else {
                    highscoreText.text = "Old Highscore: 0"
                }
                
                newPersonalBest.position = CGPoint(x: gameScene.frame.width*0.5+gameScene.frame.height*0.17, y: gameScene.frame.height*0.685)
                newPersonalBest.zPosition = 11
                newPersonalBest.alpha = 0
                newPersonalBest.text = "New Personal Best!"
                newPersonalBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
                newPersonalBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                newPersonalBest.fontSize = 18
                gameScene.addChild(newPersonalBest)
                
                newPersonalBest.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.5), SKAction.fadeAlphaTo(0, duration: 0.5)])))
            }
        }
        else {
            defaults.setValue(String(self.score), forKey: "highScore")
            highscoreText.text = "Old Highscore: 0"
            
            newPersonalBest.position = CGPoint(x: gameScene.frame.width*0.5+gameScene.frame.height*0.17, y: gameScene.frame.height*0.685)
            newPersonalBest.zPosition = 11
            newPersonalBest.alpha = 0
            newPersonalBest.text = "New Personal Best!"
            newPersonalBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            newPersonalBest.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            newPersonalBest.fontSize = 18
            gameScene.addChild(newPersonalBest)
            
            newPersonalBest.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.5), SKAction.fadeAlphaTo(0, duration: 0.5)])))
        }
        
        highscoreText.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
        finalScoreText.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
        
        for menuItem in gameScene.menuItems{
            menuItem.position.y = menuItem.position.y*0.65+gameScene.frame.height*0.07
            menuItem.label.position.y = menuItem.label.position.y*0.65+gameScene.frame.height*0.07
        }
        
    }
}