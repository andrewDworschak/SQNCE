//
//  OptionsScene.swift
//  SQNCE
//
//  Created by Andy Dworschak on 2016-03-30.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsScene: SKScene, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var gameScene : GameScene?
    let sliderButton1 = SKSpriteNode(imageNamed: "SliderButton.png")
    let sliderButton2 = SKSpriteNode(imageNamed: "SliderButton.png")
    var slide1Moving = false
    var slide2Moving = false
    
    let xBack = SKSpriteNode(imageNamed: "Xback.png")
    let defaultLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let cameraImage = SKSpriteNode(imageNamed: "CameraOutline.png")
    let selectionBox = SKSpriteNode(imageNamed: "Box.png")
    
    let bg = SKSpriteNode(imageNamed: "Background.png")
    let overlay1 = SKSpriteNode(imageNamed: "Overlay1.png")
    let overlay2 = SKSpriteNode(imageNamed: "Overlay2.png")
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.grayColor()
        bg.size = self.size
        bg.zPosition = -3
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(bg)
        
        overlay1.size = CGSize(width: 1.5*(self.size.width+self.size.height), height: 1.5*(self.size.width+self.size.height))
        overlay1.zPosition = -2
        overlay1.alpha = 1
        overlay1.position = CGPoint(x: -self.frame.width/4, y: self.frame.height/2)
        self.addChild(overlay1)
        
        overlay2.size = CGSize(width: 1.5*(self.size.width+self.size.height), height: 1.5*(self.size.width+self.size.height))
        overlay2.zPosition = -1
        overlay2.position = CGPoint(x: self.frame.width*1.25, y: self.frame.height/2)
        overlay2.alpha = 1
        self.addChild(overlay2)
        
        overlay1.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2*M_PI), duration: 50)))
        overlay2.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2*M_PI), duration: 45)))
        
        let box = SKSpriteNode(imageNamed: "Box.png")
        box.size = CGSize(width: self.frame.height*0.45, height: self.frame.height*0.65)
        box.zPosition = 0
        box.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        box.alpha = 0.4
        self.addChild(box)
        
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
        
        let optionsLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        optionsLabel.text = "Options"
        optionsLabel.fontSize = 48
        optionsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        optionsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        optionsLabel.position = CGPoint(x: self.frame.width*0.5, y: self.frame.height*0.85+10)
        optionsLabel.zPosition = 2
        optionsLabel.alpha = 1
        self.addChild(optionsLabel)
        
        let slider1Label = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        slider1Label.text = "Music Volume"
        slider1Label.fontSize = 24
        slider1Label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        slider1Label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        slider1Label.position = CGPoint(x: self.frame.width*0.5 - self.frame.height*0.15, y: self.frame.height*0.7)
        slider1Label.zPosition = 2
        slider1Label.alpha = 1
        self.addChild(slider1Label)
        
        let slider2Label = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        slider2Label.text = "Effect Volume"
        slider2Label.fontSize = 24
        slider2Label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        slider2Label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        slider2Label.position = CGPoint(x: self.frame.width*0.5 - self.frame.height*0.15, y: self.frame.height*0.55)
        slider2Label.zPosition = 2
        slider2Label.alpha = 1
        self.addChild(slider2Label)
        
        let cameraLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        cameraLabel.text = "Background Image"
        cameraLabel.fontSize = 24
        cameraLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        cameraLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        cameraLabel.position = CGPoint(x: self.frame.width*0.5 - self.frame.height*0.15, y: self.frame.height*0.35)
        cameraLabel.zPosition = 2
        cameraLabel.alpha = 1
        self.addChild(cameraLabel)
        
        xBack.size = CGSize(width: self.frame.height*0.04, height: self.frame.height*0.04)
        xBack.position = CGPoint(x: self.frame.width - xBack.size.width, y: self.frame.height*0.85 + 10)
        xBack.zPosition = 2
        xBack.alpha = 1
        self.addChild(xBack)
        
        let sliderPath = CGPathCreateMutable()
        CGPathMoveToPoint(sliderPath, nil, self.frame.width*0.5-self.frame.height*0.15, 0)
        CGPathAddLineToPoint(sliderPath, nil, self.frame.width*0.5+self.frame.height*0.15, 0)
        
        let slider1 = SKShapeNode(path: sliderPath)
        slider1.strokeColor = SKColor.whiteColor()
        slider1.alpha = 0.4
        slider1.position = CGPoint(x: 0, y: self.frame.height*0.65)
        slider1.lineWidth = 4
        slider1.zPosition = 1
        self.addChild(slider1)
        
        let slider2 = SKShapeNode(path: sliderPath)
        slider2.strokeColor = SKColor.whiteColor()
        slider2.alpha = 0.4
        slider2.position = CGPoint(x: 0, y: self.frame.height*0.5)
        slider2.lineWidth = 4
        slider2.zPosition = 1
        self.addChild(slider2)
        
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
        
        if let musicVolume = defaults.stringForKey("musicVolume") {
            if (Double(musicVolume) != nil){
                sliderButton1.position = CGPoint(x: self.frame.width/2+self.frame.height*0.3*CGFloat(sqrt(Double(musicVolume)!)-0.5), y: self.frame.height*0.65)
            }
            else {
                sliderButton1.position = CGPoint(x: self.frame.width/2+self.frame.height*0.15, y: self.frame.height*0.65)
            }
        }
        else{
            sliderButton1.position = CGPoint(x: self.frame.width/2+self.frame.height*0.15, y: self.frame.height*0.65)
        }
        
        if let fxVolume = defaults.stringForKey("fxVolume") {
            if (Double(fxVolume) != nil){
                sliderButton2.position = CGPoint(x: self.frame.width/2+self.frame.height*0.3*CGFloat(sqrt(Double(fxVolume)!)-0.5), y: self.frame.height*0.5)
            }
            else {
                sliderButton2.position = CGPoint(x: self.frame.width/2+self.frame.height*0.15, y: self.frame.height*0.5)
            }
        }
        else{
            sliderButton2.position = CGPoint(x: self.frame.width/2+self.frame.height*0.15, y: self.frame.height*0.5)
        }
        
        sliderButton1.size = CGSize(width: self.frame.height*0.05, height: self.frame.height*0.05)
        sliderButton1.zPosition = 2
        self.addChild(sliderButton1)
        
        sliderButton2.size = CGSize(width: self.frame.height*0.05, height: self.frame.height*0.05)
        sliderButton2.zPosition = 2
        self.addChild(sliderButton2)
        
        cameraImage.size = CGSize(width: self.frame.height*0.1, height: self.frame.height*0.1)
        cameraImage.position = CGPoint(x: self.frame.width*0.5 + self.frame.height*0.08, y: self.frame.height*0.3)
        cameraImage.zPosition = 3
        cameraImage.alpha = 1
        self.addChild(cameraImage)
        
        defaultLabel.text = "Default"
        defaultLabel.fontSize = 20
        defaultLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        defaultLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        defaultLabel.position = CGPoint(x: self.frame.width*0.5 - self.frame.height*0.08, y: self.frame.height*0.3)
        defaultLabel.zPosition = 3
        defaultLabel.alpha = 1
        self.addChild(defaultLabel)
        
        selectionBox.size = CGSize(width: self.frame.height*0.15, height: self.frame.height*0.08)
        selectionBox.position = CGPoint(x: self.frame.width*0.5 + self.frame.height*0.08, y: self.frame.height*0.3)
        selectionBox.zPosition = 2
        selectionBox.alpha = 1
        if (defaults.stringForKey("bgImage") == "Default" || defaults.stringForKey("bgImage") == nil){
            selectionBox.position = defaultLabel.position
        }
        else {
            selectionBox.position = cameraImage.position
        }
        self.addChild(selectionBox)
    }
    
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = NSURL(fileURLWithPath: paths[0]);
        let fullPath = path.URLByAppendingPathComponent(name)
        return fullPath.absoluteString.substringFromIndex(fullPath.absoluteString.startIndex.advancedBy(7))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            let node = self.nodeAtPoint(touchLocation)
            
            if (node == sliderButton1){
                slide1Moving = true
            }
            else if (node == sliderButton2){
                slide2Moving = true
            }
            else if (distanceFromPoint(touchLocation, pointB: xBack.position) < self.frame.height*0.025){
                self.gameScene!.numTouches = 0
                self.view!.presentScene(self.gameScene!, transition: SKTransition.crossFadeWithDuration(0.5))
            }
            else if (node == defaultLabel){
                bg.texture = SKTexture(imageNamed: "Background.png")
                gameScene!.bg.texture = SKTexture(imageNamed: "Background.png")
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue("Default", forKey: "bgImage")
                defaults.synchronize()
                selectionBox.position = defaultLabel.position
                gameScene!.overlay1.alpha = 1
                self.overlay1.alpha = 1
                gameScene!.overlay2.alpha = 1
                self.overlay2.alpha = 1
            }
            
            else if (node == cameraImage){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                (self.view!.window!.rootViewController as! GameViewController).presentViewController(picker, animated: true,
                                           completion: nil)
            }
        }
    }
    
    func distanceFromPoint(pointA: CGPoint, pointB: CGPoint) -> CGFloat{
        let xDist = pointB.x-pointA.x
        let yDist = pointB.y-pointA.y
        return sqrt(xDist*xDist + yDist*yDist)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            if (slide1Moving){
                if (touchLocation.x > self.frame.width*0.5-self.frame.height*0.15 && touchLocation.x < self.frame.width*0.5+self.frame.height*0.15){
                sliderButton1.position = CGPoint(x: touchLocation.x, y: self.frame.height*0.65)
                }
                else if (touchLocation.x <= self.frame.width*0.5-self.frame.height*0.15){
                    sliderButton1.position = CGPoint(x: self.frame.width*0.5-self.frame.height*0.15, y: self.frame.height*0.65)
                }
                else if (touchLocation.x >= self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton1.position = CGPoint(x: self.frame.width*0.5+self.frame.height*0.15, y: self.frame.height*0.65)
                }
            }
            if (slide2Moving){
                if (touchLocation.x > self.frame.width*0.5-self.frame.height*0.15 && touchLocation.x < self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton2.position = CGPoint(x: touchLocation.x, y: self.frame.height*0.5)
                }
                else if (touchLocation.x <= self.frame.width*0.5-self.frame.height*0.15){
                    sliderButton2.position = CGPoint(x: self.frame.width*0.5-self.frame.height*0.15, y: self.frame.height*0.5)
                }
                else if (touchLocation.x >= self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton2.position = CGPoint(x: self.frame.width*0.5+self.frame.height*0.15, y: self.frame.height*0.5)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            let defaults = NSUserDefaults.standardUserDefaults()
            if (slide1Moving){
                if (touchLocation.x > self.frame.width*0.5-self.frame.height*0.15 && touchLocation.x < self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton1.position = CGPoint(x: touchLocation.x, y: self.frame.height*0.65)
                    let num = (touchLocation.x-self.frame.width*0.5)/(self.frame.height*0.3)+0.5
                    defaults.setValue(String(num*num), forKey: "musicVolume")
                    (self.view!.window!.rootViewController as! GameViewController).backgroundMusic.volume = Float(num*num)
                }
                else if (touchLocation.x <= self.frame.width*0.5-self.frame.height*0.15){
                    sliderButton1.position = CGPoint(x: self.frame.width*0.5-self.frame.height*0.15, y: self.frame.height*0.65)
                    defaults.setValue("0", forKey: "musicVolume")
                    (self.view!.window!.rootViewController as! GameViewController).backgroundMusic.volume = 0
                }
                else if (touchLocation.x >= self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton1.position = CGPoint(x: self.frame.width*0.5+self.frame.height*0.15, y: self.frame.height*0.65)
                    defaults.setValue("1", forKey: "musicVolume")
                    (self.view!.window!.rootViewController as! GameViewController).backgroundMusic.volume = 1
                }
            }
            if (slide2Moving){
                if (touchLocation.x > self.frame.width*0.5-self.frame.height*0.15 && touchLocation.x < self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton2.position = CGPoint(x: touchLocation.x, y: self.frame.height*0.5)
                    let num = (touchLocation.x-self.frame.width*0.5)/(self.frame.height*0.3) + 0.5
                    defaults.setValue(String(num*num), forKey: "fxVolume")
                    gameScene!.adjustVolume(Float(num*num))
                }
                else if (touchLocation.x <= self.frame.width*0.5-self.frame.height*0.15){
                    sliderButton2.position = CGPoint(x: self.frame.width*0.5-self.frame.height*0.15, y: self.frame.height*0.5)
                    defaults.setValue("0", forKey: "fxVolume")
                    gameScene!.adjustVolume(0.0)
                }
                else if (touchLocation.x >= self.frame.width*0.5+self.frame.height*0.15){
                    sliderButton2.position = CGPoint(x: self.frame.width*0.5+self.frame.height*0.15, y: self.frame.height*0.5)
                    defaults.setValue("1", forKey: "fxVolume")
                    gameScene!.adjustVolume(1.0)
                }
            }
            
            defaults.synchronize()
            
            slide1Moving = false
            slide2Moving = false
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = scaleAndRotateImage(pickedImage)
            selectionBox.position = cameraImage.position
            bg.texture = SKTexture(image: pickedImage)
            gameScene!.bg.texture = SKTexture(image: pickedImage)
            gameScene!.overlay1.alpha = 0.6
            self.overlay1.alpha = 0.6
            gameScene!.overlay2.alpha = 0.6
            self.overlay2.alpha = 0.6
            let imageData = UIImageJPEGRepresentation(pickedImage, 1)
            let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
            let path = self.documentsPathForFileName(relativePath)
            imageData!.writeToFile(path, atomically: true)
            NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "bgImage")
            NSUserDefaults.standardUserDefaults().synchronize() 
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scaleAndRotateImage(image: UIImage) -> UIImage {
        let kMaxResolution = 640 // Or whatever
        
        let imgRef: CGImageRef = image.CGImage!;
        
        let width: CGFloat = CGFloat(CGImageGetWidth(imgRef))
        let height: CGFloat = CGFloat(CGImageGetHeight(imgRef))
        
        
        var transform: CGAffineTransform = CGAffineTransformIdentity;
        var bounds: CGRect = CGRectMake(0, 0, width, height);
        if (width > CGFloat(kMaxResolution) || height > CGFloat(kMaxResolution)) {
            let ratio = width/height
            if (ratio > 1) {
                bounds.size.width = CGFloat(kMaxResolution)
                bounds.size.height = CGFloat(bounds.size.width / ratio)
            }
            else {
                bounds.size.height = CGFloat(kMaxResolution)
                bounds.size.width = CGFloat(bounds.size.height * ratio)
            }
        }
        
        let scaleRatio = bounds.size.width / width;
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        let boundHeight: CGFloat
        let orient: UIImageOrientation = image.imageOrientation;
        switch(orient) {
            
        case UIImageOrientation.Up: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientation.UpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientation.Down: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            break;
            
        case UIImageOrientation.DownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientation.LeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            break;
            
        case UIImageOrientation.Left: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            break;
            
        case UIImageOrientation.RightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            break;
            
        case UIImageOrientation.Right: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            break;
        }
        
        UIGraphicsBeginImageContext(bounds.size);
        
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        if (orient == UIImageOrientation.Right || orient == UIImageOrientation.Left) {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio)
            CGContextTranslateCTM(context, -height, 0)
        }
        else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio)
            CGContextTranslateCTM(context, 0, -height)
        }
        
        CGContextConcatCTM(context, transform)
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef)
        let imageCopy: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy
    }
    
}