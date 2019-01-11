//
//  TutorialScene.swift
//  SQNCE
//
//  Created by Andy Dworschak on 2016-04-16.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene: SKScene {
    
    var gameScene : GameScene?
    var frameReady = false
    var currFrame = 1
    
    let label = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let labelLine2 = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let box = SKSpriteNode(imageNamed: "Box.png")
    
    let descriptor = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    
    let bg = SKSpriteNode(imageNamed: "Background.png")
    let flashWhite = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 1, height: 1))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.grayColor()
        bg.size = self.size
        bg.zPosition = -3
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(bg)
        
        let overlay1 = SKSpriteNode(imageNamed: "Overlay1.png")
        overlay1.size = CGSize(width: 1.5*(self.size.width+self.size.height), height: 1.5*(self.size.width+self.size.height))
        overlay1.zPosition = -2
        overlay1.alpha = 1
        overlay1.position = CGPoint(x: -self.frame.width/4, y: self.frame.height/2)
        self.addChild(overlay1)
        
        let overlay2 = SKSpriteNode(imageNamed: "Overlay2.png")
        overlay2.size = CGSize(width: 1.5*(self.size.width+self.size.height), height: 1.5*(self.size.width+self.size.height))
        overlay2.zPosition = -1
        overlay2.position = CGPoint(x: self.frame.width*1.25, y: self.frame.height/2)
        overlay2.alpha = 1
        self.addChild(overlay2)
        
        overlay1.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2*M_PI), duration: 50)))
        overlay2.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2*M_PI), duration: 45)))
        
        
        
        let sqnce = SKSpriteNode(imageNamed: "SQNCE.png")
        sqnce.size = CGSize(width: self.frame.width - self.frame.height*0.34, height: self.frame.height*0.06)
        sqnce.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.04)
        sqnce.zPosition = 15
        sqnce.alpha = 0.6
        self.addChild(sqnce)
        
        let appapplogo = SKSpriteNode(imageNamed: "AppAppLogo.png")
        appapplogo.size = CGSize(width: self.frame.height*0.07, height: self.frame.height*0.07)
        appapplogo.position = CGPoint(x: self.frame.width - self.frame.height*0.128, y: self.frame.height*0.04)
        appapplogo.zPosition = 15
        appapplogo.alpha = 0.6
        self.addChild(appapplogo)
        
        flashWhite.size = self.size
        flashWhite.alpha = 0
        flashWhite.zPosition = 20
        flashWhite.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(flashWhite)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.stringForKey("bgImage") != "Default" && defaults.stringForKey("bgImage") != nil){
            let oldImagePath = defaults.objectForKey("bgImage") as! String
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            // here is your saved image:
            let oldImage = UIImage(data: oldImageData!)
            bg.texture = SKTexture(image: oldImage!)
            overlay1.alpha = 0.6
            overlay2.alpha = 0.6
        }
        
        changeToFrame1()
    }
    
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = NSURL(fileURLWithPath: paths[0]);
        let fullPath = path.URLByAppendingPathComponent(name)
        return fullPath.absoluteString.substringFromIndex(fullPath.absoluteString.startIndex.advancedBy(7))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for _ in touches{
            if (frameReady){
                frameReady = false
                currFrame += 1
                switch currFrame{
                case 2:
                    changeToFrame2()
                    break
                case 3:
                    changeToFrame3()
                    break
                case 4:
                    changeToFrame4()
                    break
                case 5:
                    changeToFrame5()
                    break
                case 6:
                    changeToFrame6()
                    break
                case 7:
                    self.gameScene!.numTouches = 0
                    self.view!.presentScene(self.gameScene!, transition: SKTransition.crossFadeWithDuration(0.5))
                    break
                default: //Not possible
                    break
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func changeToFrame1(){
        box.size = CGSize(width: self.frame.height*0.45, height: self.frame.height*0.65)
        box.zPosition = 0
        box.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        box.alpha = 0.4
        self.addChild(box)
        
        label.zPosition = 1
        label.text = "Welcome"
        label.alpha = 0.6
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.55)
        self.addChild(label)
        adjustFontSizeToFit(label)
        
        labelLine2.zPosition = 1
        labelLine2.text = "To SQNCE"
        labelLine2.alpha = 0.6
        labelLine2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelLine2.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.45)
        self.addChild(labelLine2)
        adjustFontSizeToFit(labelLine2)
        
        frameReady = true
    }
    
    func changeToFrame2(){
        flashScreenWhite()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.box.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 1), SKAction.fadeAlphaTo(0.2, duration: 1)])))
            self.label.alpha = 0
            self.labelLine2.alpha = 0
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.frameReady = true
            }
        }
    }
    
    func changeToFrame3(){
        flashScreenWhite()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.box.removeFromParent()
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.frameReady = true
            }
        }
    }
    
    func changeToFrame4(){
        flashScreenWhite()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.frameReady = true
        }
    }
    
    func changeToFrame5(){
        flashScreenWhite()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.frameReady = true
        }
    }
    
    func changeToFrame6(){
        flashScreenWhite()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.addChild(self.box)
            self.label.text = "Are You"
            self.label.alpha = 0.6
            self.adjustFontSizeToFit(self.label)
            
            self.labelLine2.text = "Ready?"
            self.labelLine2.alpha = 0.6
            self.adjustFontSizeToFit(self.labelLine2)
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.2*Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.frameReady = true
            }
        }
    }
    
    func adjustFontSizeToFit(labelNode: SKLabelNode) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = self.frame.height*0.35 / labelNode.frame.width
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
    }
    
    func flashScreenWhite(){
        flashWhite.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.2), SKAction.fadeAlphaTo(0, duration: 0.2)]))
    }
    
}