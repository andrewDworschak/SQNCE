//
//  AnnouncementCentre.swift
//  SQNCE
//
//  Created by Andy Dworschak on 2016-03-28.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class AnnouncementCentre: SKLabelNode{
    let gameScene : GameScene
    var announcementQueue = [String]()
    var announcementActive = false
    let back = SKSpriteNode(imageNamed: "AnnouncementBack.png")
    
    init(gameScene: GameScene){
        self.gameScene = gameScene
        
        super.init()
        
        self.fontName = "Futura-CondensedExtraBold"
        self.position = CGPoint(x: gameScene.frame.width/2, y: gameScene.frame.height/2)
        self.zPosition = 6
        self.fontSize = 30
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.alpha = 0
        
        back.position = self.position
        back.size = CGSize(width: gameScene.frame.height*0.38, height: gameScene.frame.height*0.08)
        back.zPosition = 5
        back.alpha = 0
        
        gameScene.addChild(back)
        gameScene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newAnnouncement(text: String){
        announcementQueue.append(text)
    }
    
    func update(){
        if (announcementQueue.count > 0 && !announcementActive){
            announcementActive = true
            self.text = announcementQueue.removeFirst()
            adjustFontSizeToFit()
            
            self.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
            back.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.3))
            let soundTime = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
            dispatch_after(soundTime, dispatch_get_main_queue()) {
                    self.gameScene.ding.play()
            }
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.8*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                
                self.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                self.back.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.8*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.announcementActive = false
                }
            }
        }
    }
    
    func adjustFontSizeToFit() {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = gameScene.frame.height*0.35 / self.frame.width
        
        // Change the fontSize.
        self.fontSize *= scalingFactor
        
        back.size.height = self.fontSize+4
    }
}