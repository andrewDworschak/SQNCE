//
//  MenuItem.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-25.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class MenuItem : SKSpriteNode{
    let label : SKSpriteNode
    let gameScene : GameScene
    let type : Int
    var actionInProgress = false
    
    
    init(gameScene: GameScene, type : Int){
        self.gameScene = gameScene
        self.type = type
        
        switch type{
        case 1:
            label = SKSpriteNode(imageNamed: "Question.png")
            super.init(texture: SKTexture(imageNamed: "CircleBig.png"), color: SKColor.blackColor(), size: CGSize(width: gameScene.frame.height*0.2, height: gameScene.frame.height*0.2))
            self.position = CGPoint(x: gameScene.frame.width*0.7, y: gameScene.frame.height*0.45)
            break
        case 2:
            label = SKSpriteNode(imageNamed: "Cog.png")
            super.init(texture: SKTexture(imageNamed: "TriangleBig.png"), color: SKColor.blackColor(), size: CGSize(width: gameScene.frame.height*0.3, height: gameScene.frame.height*0.3))
            self.position = CGPoint(x: gameScene.frame.width*0.3, y: gameScene.frame.height*0.2)
            self.zRotation = CGFloat(M_PI/7)
            break
        default:
            label = SKSpriteNode(imageNamed: "Restart.png")
            super.init(texture: SKTexture(imageNamed: "SquareBig.png"), color: SKColor.blackColor(), size: CGSize(width: gameScene.frame.height*0.2, height: gameScene.frame.height*0.2))
            
            self.position = CGPoint(x: gameScene.frame.width*0.3, y: gameScene.frame.height*0.68)
            self.zRotation = CGFloat(M_PI/8)
            break
        }
        
        label.zPosition = 10
        self.zPosition = 9
        label.size = CGSize(width: gameScene.frame.height*0.1, height: gameScene.frame.height*0.1)
        label.position = self.position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appear() {
        actionInProgress = true
        self.alpha = 0
        label.alpha = 0
        gameScene.addChild(self)
        gameScene.addChild(label)
        self.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
        label.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.5))
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.actionInProgress = false
        }
    }
    
    func act() {
        switch type{
        case 1:
            let tutorialScene = TutorialScene(size: gameScene.size)
            tutorialScene.gameScene = self.gameScene
            self.gameScene.view!.presentScene(tutorialScene, transition: SKTransition.crossFadeWithDuration(0.5))
            break
        case 2:
            let optionsScene = OptionsScene(size: gameScene.size)
            optionsScene.gameScene = self.gameScene
            self.gameScene.view!.presentScene(optionsScene, transition: SKTransition.crossFadeWithDuration(0.5))
            break
        default:
            for item in gameScene.menuItems{
                item.disappear()
            }
            gameScene.menuCover.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
            gameScene.pauseButton?.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            gameScene.score!.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            gameScene.score!.border.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            gameScene.score!.logo.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            gameScene.score!.finalScoreText.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            gameScene.score!.highscoreText.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            gameScene.score!.newPersonalBest.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
            let newGame = GameScene(size: gameScene.size)
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.gameScene.view!.presentScene(newGame, transition: SKTransition.crossFadeWithDuration(0.5))
            }
        }
    }
    
    func disappear(){
        self.actionInProgress = true
        self.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
        label.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.removeFromParent()
            self.label.removeFromParent()
            self.actionInProgress = false
        }
    }
    
}