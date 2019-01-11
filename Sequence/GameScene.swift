//
//  GameScene.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-06.
//  Copyright (c) 2016 App App n Away. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var tiles = [GameTile]()
    var loadedTiles = [GameTile]()
    var loaded = false
    var toDestroy = [GameTile]()
    var menuItems = [MenuItem]()
    let menuCover = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 1, height: 1))
    var pauseButton : PauseButton?
    
    let TILECATEGORY : UInt32 = 0x1 << 1
    let TESTERCATEGORY : UInt32 = 0x1 << 2
    let BOXCATEGORY : UInt32 = 0x1 << 3
    let TESTBOXCATEGORY : UInt32 = 0x1 << 4
    let GRAVFIELD : UInt32 = 0x1 << 5
    
    var cables = [Cable]()
    var currAngle : CGFloat = 0
    var multiplier : Multiplier?
    var score : Score?
    var updater : Updater?
    let rotator = SKSpriteNode(imageNamed: "Rotate.png")
    let switcher = SKSpriteNode(imageNamed: "Switch.png")
    var lastTile1 = Int32(arc4random_uniform(6) + 1)
    var lastTile2 = Int32(arc4random_uniform(6) + 1)
    var tileChoices = [Int32]()
    var swapping = false
    var gameOverTimer = -1
    var gameOver = false
    var cableSerials = 0
    var waiting = false
    var totalNums : Int32 = 6
    var totalShapes : UInt32 = 3
    var combo4 : Combo?
    var combo7 : Combo?
    var longestChain = 0
    var longestChainTile : GameTile?
    var announcementCentre : AnnouncementCentre?
    var numTouches = 0
    var prepping = false
    let bg = SKSpriteNode(imageNamed: "Background.png")
    let overlay1 = SKSpriteNode(imageNamed: "Overlay1.png")
    let overlay2 = SKSpriteNode(imageNamed: "Overlay2.png")
    var firstGameOverCheck = true
    var gameEnded = false
    
    
    var soundPlaying = false
    let xplosion = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Xplode", ofType: "wav")!), fileTypeHint: "wav")
    let ding = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Ding", ofType: "wav")!), fileTypeHint: "wav")
    let laser = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Laser", ofType: "wav")!), fileTypeHint: "wav")
    let hiss = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Static", ofType: "wav")!), fileTypeHint: "wav")
    let snare = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Snare", ofType: "wav")!), fileTypeHint: "wav")
    let sweep = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sweep", ofType: "wav")!), fileTypeHint: "wav")
    let sweepback = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("SweepBack", ofType: "wav")!), fileTypeHint: "wav")
    
    var initialized = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if (!initialized){
            initialize()
        }
    }
    
    func initialize(){
        initialized = true
        let volume : Float
        let defaults = NSUserDefaults.standardUserDefaults()
        if let fxVolume = defaults.stringForKey("fxVolume") {
            if (Float(fxVolume) != nil){
                volume = Float(fxVolume)!
            }
            else {
                volume = 1
            }
        }
        else {
            volume = 1
        }
        
        xplosion.volume = volume
        ding.volume = volume
        laser.volume = volume
        hiss.volume = volume
        snare.volume = volume
        sweep.volume = volume*0.2
        sweepback.volume = volume*0.2
        
        self.physicsWorld.contactDelegate = self
        self.multiplier = Multiplier(gameScene: self)
        self.score = Score(gameScene: self)
        self.updater = Updater(gameScene: self)
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
        
        self.announcementCentre = AnnouncementCentre(gameScene: self)
        
        rotator.position = CGPoint(x: self.frame.width*0.35, y: self.frame.height*0.15)
        rotator.size = CGSize(width: self.frame.height*0.04, height: self.frame.height*0.04)
        rotator.zPosition = 1
        rotator.alpha = 0.7
        self.addChild(rotator)
        
        switcher.position = CGPoint(x: self.frame.width*0.59, y: self.frame.height*0.11)
        switcher.size = CGSize(width: self.frame.height*0.04, height: self.frame.height*0.04)
        switcher.zPosition = 1
        switcher.alpha = 0.7
        self.addChild(switcher)
        
        combo4 = Combo(gameScene: self, comboNum: 4)
        combo7 = Combo(gameScene: self, comboNum: 7)
        
        for i in 0...2{
            menuItems.append(MenuItem(gameScene: self, type: i))
        }
        
        menuCover.size = self.size
        menuCover.alpha = 0
        menuCover.zPosition = 8
        menuCover.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        pauseButton = PauseButton(gameScene: self)
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, self.frame.width*0.5-self.frame.height*0.2, self.frame.height*0.2)
        CGPathAddLineToPoint(path, nil, self.frame.width*0.5+self.frame.height*0.2, self.frame.height*0.2)
        CGPathAddLineToPoint(path, nil, self.frame.width*0.5+self.frame.height*0.2, self.frame.height*0.8)
        CGPathAddLineToPoint(path, nil, self.frame.width*0.5, self.frame.height*0.8001)
        CGPathAddLineToPoint(path, nil, self.frame.width*0.5-self.frame.height*0.2, self.frame.height*0.8)
        CGPathAddLineToPoint(path, nil, self.frame.width*0.5-self.frame.height*0.2, self.frame.height*0.2)
        self.physicsBody = SKPhysicsBody(edgeLoopFromPath: path)
        self.physicsBody!.categoryBitMask = BOXCATEGORY
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
        
        for i:Int32 in 1...6{
            if (i != lastTile1 && i != lastTile2){
                tileChoices.append(i)
            }
        }
        
        newTile()
        for tile in loadedTiles{
            tile.advance()
        }
        newTile()
        for tile in loadedTiles{
            tile.advance()
        }
        newTile()
    }
    
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = NSURL(fileURLWithPath: paths[0]);
        let fullPath = path.URLByAppendingPathComponent(name)
        return fullPath.absoluteString.substringFromIndex(fullPath.absoluteString.startIndex.advancedBy(7))
    }
    
    func newTile() {
        let type = Int32(arc4random_uniform(totalShapes) + 1)
        let randNum = Int(arc4random_uniform(UInt32(totalNums-2)))
        let tileNum = tileChoices[randNum]
        tileChoices.removeAtIndex(randNum)
        tileChoices.append(lastTile1)
        lastTile1 = lastTile2
        lastTile2 = tileNum
        
        switch type{
            
        case 2:
            loadedTiles.append(SquareTile(gameScene: self, number: tileNum, angle: currAngle))
            break
        case 3:
            loadedTiles.append(TriangleTile(gameScene: self, number: tileNum, angle: currAngle))
            break
        case 4:
            loadedTiles.append(HexagonTile(gameScene: self, number: tileNum, angle: currAngle))
            break
        case 5:
            loadedTiles.append(StarTile(gameScene: self, number: tileNum, angle: currAngle))
            break
        case 6:
            loadedTiles.append(TrapezoidTile(gameScene: self, number: tileNum, angle: currAngle))
            break
        default:
            loadedTiles.append(CircleTile(gameScene: self, number: tileNum, angle: currAngle))
            break
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            numTouches += 1
            if (!waiting && !prepping && numTouches==1){
                if (distanceFromPoint(touchLocation, pointB: pauseButton!.position) < self.frame.height*0.025){
                    pauseButton!.pauseGame()
                }
                else if (!loaded){
                    if (distanceFromPoint(touchLocation, pointB: rotator.position) < self.frame.height*0.025){
                        loadedTiles.first!.rotate()
                    }
                    else if (self.swapping == false && distanceFromPoint(touchLocation, pointB: switcher.position) < self.frame.height*0.025){
                        loadedTiles.first!.swap(loadedTiles[1])
                        swapping = true
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.3*Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.swapping = false
                        }
                        
                    }
                    else if (touchLocation.y >= self.frame.height*0.2 && touchLocation.y <= self.frame.height*0.8){
                        let middle = self.frame.width/2
                        let columnWidth = self.frame.height*0.1
                        if (touchLocation.x > middle-2*columnWidth+loadedTiles.first!.edgeDist && touchLocation.x < middle+2*columnWidth-loadedTiles.first!.edgeDist){
                            loadedTiles.first!.prepare(touchLocation.x)
                            loaded = true
                        }
                        else if (touchLocation.x >= middle-2*columnWidth && touchLocation.x <= middle-2*columnWidth+loadedTiles.first!.edgeDist){
                            loadedTiles.first!.prepare(middle-2*columnWidth+loadedTiles.first!.edgeDist)
                            loaded = true
                        }
                        else if (touchLocation.x >= middle+2*columnWidth-loadedTiles.first!.edgeDist && touchLocation.x <= middle+2*columnWidth){
                            loadedTiles.first!.prepare(middle+2*columnWidth-loadedTiles.first!.edgeDist)
                            loaded = true
                        }
                    }
                }
            }
            else if (numTouches==1){
                let node = self.nodeAtPoint(touchLocation)
                for i in 0...2{
                    if (node == menuItems[i] || node == menuItems[i].label){
                        menuItems[i].act()
                    }
                }
                if (!gameEnded && distanceFromPoint(touchLocation, pointB: pauseButton!.position) < self.frame.height*0.025){
                    pauseButton!.resumeGame()
                }
            }
            
            else if (!waiting && !prepping){
                loadedTiles.first!.reset()
                loaded = false
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
            if (!waiting && !prepping && numTouches == 1){
                if (!loaded){
                    if (touchLocation.y >= self.frame.height*0.2 && touchLocation.y <= self.frame.height*0.8){
                        let middle = self.frame.width/2
                        let columnWidth = self.frame.height*0.1
                        if (touchLocation.x > middle-2*columnWidth+loadedTiles.first!.edgeDist && touchLocation.x < middle+2*columnWidth-loadedTiles.first!.edgeDist){
                            loadedTiles.first!.prepare(touchLocation.x)
                            loaded = true
                        }
                        else if (touchLocation.x >= middle-2*columnWidth && touchLocation.x <= middle-2*columnWidth+loadedTiles.first!.edgeDist){
                            loadedTiles.first!.prepare(middle-2*columnWidth+loadedTiles.first!.edgeDist)
                            loaded = true
                        }
                        else if (touchLocation.x >= middle+2*columnWidth-loadedTiles.first!.edgeDist && touchLocation.x <= middle+2*columnWidth){
                            loadedTiles.first!.prepare(middle+2*columnWidth-loadedTiles.first!.edgeDist)
                            loaded = true
                        }
                    }
                }
                else {
                    if (touchLocation.y >= self.frame.height*0.2 && touchLocation.y <= self.frame.height*0.8){
                        let middle = self.frame.width/2
                        let columnWidth = self.frame.height*0.1
                        if (touchLocation.x > middle-2*columnWidth+loadedTiles.first!.edgeDist && touchLocation.x < middle+2*columnWidth-loadedTiles.first!.edgeDist){
                            loadedTiles.first!.movePrep(touchLocation.x)
                        }
                        else if (touchLocation.x >= middle-2*columnWidth && touchLocation.x <= middle-2*columnWidth+loadedTiles.first!.edgeDist){
                            loadedTiles.first!.movePrep(middle-2*columnWidth+loadedTiles.first!.edgeDist)
                        }
                        else if (touchLocation.x >= middle+2*columnWidth-loadedTiles.first!.edgeDist && touchLocation.x <= middle+2*columnWidth){
                            loadedTiles.first!.movePrep(middle+2*columnWidth-loadedTiles.first!.edgeDist)
                        }
                        else {
                            loadedTiles.first!.reset()
                            loaded = false
                        }
                    }
                    else {
                        loadedTiles.first!.reset()
                        loaded = false
                    }
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            numTouches-=1
            if (numTouches<0){
                numTouches = 0
            }
            if (!waiting && !prepping && numTouches == 0){
                if (loaded){
                    loaded = false
                    if (touchLocation.y >= self.frame.height*0.2 && touchLocation.y <= self.frame.height*0.8 && !combo4!.comboActive && !combo7!.comboActive){
                        if (loadedTiles.first!.prepping){
                            prepping = true
                            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.05*Double(NSEC_PER_SEC)))
                            dispatch_after(time, dispatch_get_main_queue()) {
                                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.06*Double(NSEC_PER_SEC)))
                                dispatch_after(time, dispatch_get_main_queue()) {
                                    self.prepping = false
                                }
                                let middle = self.frame.width/2
                                let columnWidth = self.frame.height*0.1
                                if (touchLocation.x > middle-2*columnWidth+self.loadedTiles.first!.edgeDist && touchLocation.x < middle+2*columnWidth-self.loadedTiles.first!.edgeDist){
                                    if (self.loadedTiles.first!.numConflicts == 0 && self.loadedTiles.first!.position.y > self.frame.height*0.2){
                                        self.loadedTiles.first!.launch(touchLocation.x)
                                        if (self.multiplier!.level > 0){
                                            self.multiplier!.apply()
                                        }
                                        self.tiles.append(self.loadedTiles.removeFirst())
                                        for tile in self.loadedTiles{
                                            tile.advance()
                                        }
                                        self.newTile()
                                        self.updater!.launch()
                                        self.gameOverTimer = 10
                                        self.firstGameOverCheck = true
                                        if (self.pauseButton!.giveUpShown){
                                            self.pauseButton!.flashGiveUp()
                                        }
                                    }
                                    else {
                                        self.loadedTiles.first!.reset()
                                    }
                                }
                                else if (touchLocation.x >= middle-2*columnWidth && touchLocation.x <= middle-2*columnWidth+self.loadedTiles.first!.edgeDist){
                                    if (self.loadedTiles.first!.numConflicts == 0 && self.loadedTiles.first!.position.y > self.frame.height*0.2){
                                        self.loadedTiles.first!.launch(middle-2*columnWidth+self.loadedTiles.first!.edgeDist)
                                        if (self.multiplier!.level > 0){
                                            self.multiplier!.apply()
                                        }
                                        self.tiles.append(self.loadedTiles.removeFirst())
                                        for tile in self.loadedTiles{
                                            tile.advance()
                                        }
                                        self.newTile()
                                        self.updater!.launch()
                                        self.gameOverTimer = 10
                                        self.firstGameOverCheck = true
                                        if (self.pauseButton!.giveUpShown){
                                            self.pauseButton!.flashGiveUp()
                                        }
                                    }
                                    else {
                                        self.loadedTiles.first!.reset()
                                    }
                                }
                                else if (touchLocation.x >= middle+2*columnWidth-self.loadedTiles.first!.edgeDist && touchLocation.x <= middle+2*columnWidth){
                                    if (self.loadedTiles.first!.numConflicts == 0 && self.loadedTiles.first!.position.y > self.frame.height*0.2){
                                        self.loadedTiles.first!.launch(middle+2*columnWidth-self.loadedTiles.first!.edgeDist)
                                        if (self.multiplier!.level > 0){
                                            self.multiplier!.apply()
                                        }
                                        self.tiles.append(self.loadedTiles.removeFirst())
                                        for tile in self.loadedTiles{
                                            tile.advance()
                                        }
                                        self.newTile()
                                        self.updater!.launch()
                                        self.gameOverTimer = 10
                                        self.firstGameOverCheck = true
                                        if (self.pauseButton!.giveUpShown){
                                            self.pauseButton!.flashGiveUp()
                                        }
                                    }
                                    else {
                                        self.loadedTiles.first!.reset()
                                    }
                                }
                                else{
                                    self.loadedTiles.first!.reset()
                                }
                            }
                        }
                        else if (loadedTiles.first!.prepped){
                            let middle = self.frame.width/2
                            let columnWidth = self.frame.height*0.1
                            if (touchLocation.x > middle-2*columnWidth+loadedTiles.first!.edgeDist && touchLocation.x < middle+2*columnWidth-loadedTiles.first!.edgeDist){
                                if (self.loadedTiles.first!.numConflicts == 0 && self.loadedTiles.first!.position.y > self.frame.height*0.2){
                                    loadedTiles.first!.launch(touchLocation.x)
                                    if (multiplier!.level > 0){
                                        multiplier!.apply()
                                    }
                                    tiles.append(loadedTiles.removeFirst())
                                    for tile in loadedTiles{
                                        tile.advance()
                                    }
                                    newTile()
                                    updater!.launch()
                                    gameOverTimer = 10
                                    self.firstGameOverCheck = true
                                    if (self.pauseButton!.giveUpShown){
                                        self.pauseButton!.flashGiveUp()
                                    }
                                }
                                else {
                                    loadedTiles.first!.reset()
                                }
                            }
                            else if (touchLocation.x >= middle-2*columnWidth && touchLocation.x <= middle-2*columnWidth+loadedTiles.first!.edgeDist){
                                if (self.loadedTiles.first!.numConflicts == 0 && self.loadedTiles.first!.position.y > self.frame.height*0.2){
                                    loadedTiles.first!.launch(middle-2*columnWidth+loadedTiles.first!.edgeDist)
                                    if (multiplier!.level > 0){
                                        multiplier!.apply()
                                    }
                                    tiles.append(loadedTiles.removeFirst())
                                    for tile in loadedTiles{
                                        tile.advance()
                                    }
                                    newTile()
                                    updater!.launch()
                                    gameOverTimer = 10
                                    self.firstGameOverCheck = true
                                    if (self.pauseButton!.giveUpShown){
                                        self.pauseButton!.flashGiveUp()
                                    }
                                }
                                else {
                                    loadedTiles.first!.reset()
                                }
                            }
                            else if (touchLocation.x >= middle+2*columnWidth-loadedTiles.first!.edgeDist && touchLocation.x <= middle+2*columnWidth){
                                if (self.loadedTiles.first!.numConflicts == 0 && self.loadedTiles.first!.position.y > self.frame.height*0.2){
                                    loadedTiles.first!.launch(middle+2*columnWidth-loadedTiles.first!.edgeDist)
                                    if (multiplier!.level > 0){
                                        multiplier!.apply()
                                    }
                                    tiles.append(loadedTiles.removeFirst())
                                    for tile in loadedTiles{
                                        tile.advance()
                                    }
                                    newTile()
                                    updater!.launch()
                                    gameOverTimer = 10
                                    self.firstGameOverCheck = true
                                    if (self.pauseButton!.giveUpShown){
                                        self.pauseButton!.flashGiveUp()
                                    }
                                }
                                else {
                                    loadedTiles.first!.reset()
                                }
                            }
                            else{
                                loadedTiles.first!.reset()
                            }
                        }
                        else {
                            loadedTiles.first!.reset()
                        }
                    }
                    else {
                        loadedTiles.first!.reset()
                    }
                    
                }
            }
        }
    }

   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (!waiting){
            multiplier!.update()
            if (gameOverTimer == 0){
                checkGameOver()
            }
            if (gameOverTimer >= -1){
                gameOverTimer -= 1
            }
            
            let angle : CGFloat
            switch UIDevice.currentDevice().orientation{
            case UIDeviceOrientation.Portrait:
                angle = 0
                break
            case UIDeviceOrientation.LandscapeLeft:
                angle = CGFloat(-M_PI_2)
                break
            case UIDeviceOrientation.LandscapeRight:
                angle = CGFloat(M_PI_2)
                break
            case UIDeviceOrientation.PortraitUpsideDown:
                angle = CGFloat(M_PI)
                break
            default:
                angle = 1
                break
            }
            
            if (angle != currAngle && (angle != 1)){
                currAngle = angle
                multiplier!.orientTo(angle)
                score!.orientTo(angle)
                for tile in tiles{
                    tile.orientTo(angle)
                }
                for tile in loadedTiles{
                    tile.orientTo(angle)
                }
            }
            self.announcementCentre!.update()
            for cable in cables{
                cable.update()
            }
            for tile in loadedTiles{
                tile.moveAttachments(tile.position)
            }
            for tile in tiles{
                tile.moveAttachments(CGPoint(x: tile.position.x+tile.physicsBody!.velocity.dx/60, y: tile.position.y+tile.physicsBody!.velocity.dy/60))
                tile.buildSequence()
            }
            var newDestroyCount = 0
            for tile in toDestroy{
                if (!tile.destroying){
                    tile.destroy()
                    newDestroyCount += 1
                }
            }
            var boardClear = true
            for tile in tiles{
                if (!tile.destroying){
                    boardClear = false
                    break
                }
            }
            if (newDestroyCount > 0 && boardClear){
                clearBoard()
            }
            toDestroy.removeAll()
            if (newDestroyCount>0){
                multiplier!.levelUp(newDestroyCount)
                if (!soundPlaying){
                    soundPlaying = true
                    self.hiss.play()
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(1.1*Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.soundPlaying = false
                    }
                }
                if (multiplier!.level-newDestroyCount<4 && multiplier!.level >= 4){
                    self.combo4!.apply()
                }
                else if (multiplier!.level-newDestroyCount<7 && multiplier!.level >= 7){
                    self.combo7!.apply()
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        if (contact.bodyA.node is GameTile && contact.bodyB.node is GameTile){
            var tileA : GameTile = contact.bodyA.node as! GameTile
            var tileB : GameTile = contact.bodyB.node as! GameTile
            
            if (contact.bodyA.categoryBitMask == TESTERCATEGORY){
                tileA.numConflicts += 1
                if (tileA.numConflicts == 1){
                    tileA.turnRed()
                }
            }
                
            else if (contact.bodyB.categoryBitMask == TESTERCATEGORY){
                tileB.numConflicts += 1
                if (tileB.numConflicts == 1){
                    tileB.turnRed()
                }
            }
            
            else if (abs(tileA.number - tileB.number) == 1){
                tileA.adjacents.append(tileB)
                tileB.adjacents.append(tileA)
                cables.append(Cable(tileA: tileA, tileB: tileB, gameScene: self, serial: cableSerials))
                cableSerials += 1
            }
        }
        else if (contact.bodyA.node is GameTile && contact.bodyB.categoryBitMask == TESTBOXCATEGORY){
            if (combo4!.type == 2){
                combo4!.laserHitTile(contact.bodyA.node as! GameTile)
            }
            else if (combo7!.type == 2){
                combo7!.laserHitTile(contact.bodyA.node as! GameTile)
            }
        }
        else if (contact.bodyB.node is GameTile && contact.bodyA.categoryBitMask == TESTBOXCATEGORY){
            if (combo4!.type == 2){
                combo4!.laserHitTile(contact.bodyB.node as! GameTile)
            }
            else if (combo7!.type == 2){
                combo7!.laserHitTile(contact.bodyB.node as! GameTile)
            }
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        if (contact.bodyA.node is GameTile && contact.bodyB.node is GameTile){
            var tileA : GameTile = contact.bodyA.node as! GameTile
            var tileB : GameTile = contact.bodyB.node as! GameTile
            
            if (contact.bodyA.categoryBitMask == TESTERCATEGORY){
                tileA.numConflicts -= 1
                if (tileA.numConflicts == 0){
                    tileA.turnBlack()
                }
            }
                
            else if (contact.bodyB.categoryBitMask == TESTERCATEGORY){
                tileB.numConflicts -= 1
                if (tileB.numConflicts == 0){
                    tileB.turnBlack()
                }
            }
            
            else if (tileA.adjacents.contains({$0.position == tileB.position})){
                tileA.adjacents.removeAtIndex(tileA.adjacents.indexOf({$0.position == tileB.position})!)
                tileB.adjacents.removeAtIndex(tileB.adjacents.indexOf({$0.position == tileA.position})!)
                if (!tileA.destroying || !tileB.destroying){
                    for cable in cables{
                        if ((cable.tileA.position == tileA.position || cable.tileB.position == tileA.position) && (cable.tileA.position == tileB.position || cable.tileB.position == tileB.position)){
                            cables.removeAtIndex(cables.indexOf({$0.serial == cable.serial})!)
                            cable.remove()
                            break
                        }
                    }
                }
            }
        }
    }
    
    func checkGameOver(){
        
        if (firstGameOverCheck){
            firstGameOverCheck = false
        }
        else{
            self.pauseButton!.flashGiveUp()
        }
        var testers = [TesterTile]()
        
        for i in 0...1{
            if (loadedTiles[i] is SquareTile){
                testers.append(TesterTile(gameScene: self, shape: 1, initialSpace: true))
                testers.append(TesterTile(gameScene: self, shape: 1, initialSpace: false))
            }
            else if (loadedTiles[i] is TriangleTile){
                testers.append(TesterTile(gameScene: self, shape: 2, initialSpace: true))
                testers.append(TesterTile(gameScene: self, shape: 2, initialSpace: false))
            }
            else if (self.loadedTiles[i] is CircleTile){
                testers.append(TesterTile(gameScene: self, shape: 3, initialSpace: true))
                testers.append(TesterTile(gameScene: self, shape: 3, initialSpace: false))
            }
            else if (self.loadedTiles[i] is HexagonTile){
                testers.append(TesterTile(gameScene: self, shape: 4, initialSpace: true))
                testers.append(TesterTile(gameScene: self, shape: 4, initialSpace: false))
            }
            else if (self.loadedTiles[i] is StarTile){
                testers.append(TesterTile(gameScene: self, shape: 5, initialSpace: true))
                testers.append(TesterTile(gameScene: self, shape: 5, initialSpace: false))
            }
            else { //self.loadedTiles[i] is TrapezoidTile
                testers.append(TesterTile(gameScene: self, shape: 0, initialSpace: true))
                testers.append(TesterTile(gameScene: self, shape: 0, initialSpace: false))
            }
        }
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            if (self.multiplier!.level == 0 && testers[0].gameOver == true && testers[1].gameOver == true && testers[2].gameOver == true && testers[3].gameOver == true){
                var nextTesters = [TesterTile]()
                for i in 0...1{
                    if (self.loadedTiles[i] is SquareTile){
                        nextTesters.append(TesterTile(gameScene: self, shape: 1, initialSpace: true))
                        nextTesters.append(TesterTile(gameScene: self, shape: 1, initialSpace: false))
                    }
                    else if (self.loadedTiles[i] is TriangleTile){
                        nextTesters.append(TesterTile(gameScene: self, shape: 2, initialSpace: true))
                        nextTesters.append(TesterTile(gameScene: self, shape: 2, initialSpace: false))
                    }
                    else if (self.loadedTiles[i] is CircleTile){
                        nextTesters.append(TesterTile(gameScene: self, shape: 3, initialSpace: true))
                        nextTesters.append(TesterTile(gameScene: self, shape: 3, initialSpace: false))
                    }
                    else if (self.loadedTiles[i] is HexagonTile){
                        nextTesters.append(TesterTile(gameScene: self, shape: 4, initialSpace: true))
                        nextTesters.append(TesterTile(gameScene: self, shape: 4, initialSpace: false))
                    }
                    else if (self.loadedTiles[i] is StarTile){
                        nextTesters.append(TesterTile(gameScene: self, shape: 5, initialSpace: true))
                        nextTesters.append(TesterTile(gameScene: self, shape: 5, initialSpace: false))
                    }
                    else { //self.loadedTiles[i] is TrapezoidTile
                        nextTesters.append(TesterTile(gameScene: self, shape: 0, initialSpace: true))
                        nextTesters.append(TesterTile(gameScene: self, shape: 0, initialSpace: false))
                    }
                    
                }
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.6*Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    if (self.multiplier!.level == 0 && nextTesters[0].gameOver == true && nextTesters[1].gameOver == true && nextTesters[2].gameOver == true && nextTesters[3].gameOver == true){
                        self.endGame()
                    }
                    else {
                        self.gameOverTimer = 180
                    }
                }
            }
            else {
                self.gameOverTimer = 180
            }
        }
    }
    
    func endGame(){
        if (!waiting){
            self.physicsWorld.speed = 0.0
            self.gameEnded = true
            self.waiting = true
            self.addChild(menuCover)
            self.pauseButton!.removeFromParent()
            self.pauseButton!.giveUpTop.removeFromParent()
            self.pauseButton!.giveUpBottom.removeFromParent()
            menuCover.runAction(SKAction.fadeAlphaTo(0.8, duration: 0.5))
            
            for item in menuItems{
                item.appear()
            }
            score!.displayGameOver()
        }
    }
    
    func clearBoard(){
        multiplier!.addToInterim(500)
        announcementCentre!.newAnnouncement("Board Cleared")
    }
    
    func adjustVolume(volume: Float){
        xplosion.volume = volume
        ding.volume = volume
        laser.volume = volume
        hiss.volume = volume
        snare.volume = volume
        sweep.volume = volume*0.2
        sweepback.volume = volume*0.2
    }
}
