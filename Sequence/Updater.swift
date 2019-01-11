//
//  Updater.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-17.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class Updater: SKSpriteNode {
    
    let gameScene : GameScene
    let counter = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let counterBack : SKShapeNode
    var countDown = 10
    let nextLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var nextCombo : Int = 0
    var combosChanged = 0
    var bonusType = 3
    //bonusType: 1 = new number, 2 = new shape, 3 = new combo
    var comboList : [Int] = [1, 2, 3]
    
    var image = SKSpriteNode(imageNamed: "ComboShape.png")
    var imageLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    
    init(gameScene: GameScene){
        self.gameScene = gameScene
        counterBack = SKShapeNode(circleOfRadius: gameScene.frame.height*0.015)
        
        super.init(texture: SKTexture(imageNamed: "RoundedFrame.png"), color: SKColor.whiteColor(), size: CGSize(width: gameScene.frame.height*0.08, height: gameScene.frame.height*0.08))
        
        self.position = CGPoint(x: gameScene.frame.width - self.size.width/2, y: self.size.height/2)
        self.zPosition = 5
        self.alpha = 0.6
        
        nextCombo = comboList.removeAtIndex(Int(arc4random_uniform(UInt32(comboList.count))))
        
        switch nextCombo{
        case 1:
            image.texture = SKTexture(imageNamed: "ComboLaser.png")
            break
        case 2:
            image.texture = SKTexture(imageNamed: "ComboXplode.png")
            break
        default:
            break
        }
        
        
        counter.fontSize = 15
        counter.position = CGPoint(x: self.position.x - self.size.width*0.3, y: self.position.y + self.size.height*0.3)
        counter.text = String(countDown)
        counter.zPosition = 6
        counter.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        counter.alpha = 0.6
        
        nextLabel.fontSize = 15
        nextLabel.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height*0.5)
        nextLabel.text = "Next in:"
        nextLabel.zPosition = 6
        nextLabel.alpha = 0.6
        
        imageLabel.fontSize = 24
        imageLabel.position = self.position
        imageLabel.text = ""
        imageLabel.zPosition = 6
        imageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        image.position = self.position
        image.size = CGSize(width: self.size.width, height: self.size.height)
        image.zPosition = 3
        
        counterBack.position = counter.position
        counterBack.zPosition = 4
        counterBack.strokeColor = SKColor.blackColor()
        counterBack.fillColor = SKColor.blackColor()
        
        gameScene.addChild(counterBack)
        gameScene.addChild(self)
        gameScene.addChild(counter)
        gameScene.addChild(imageLabel)
        gameScene.addChild(image)
        gameScene.addChild(nextLabel)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func launch(){
        countDown -= 1
        counter.text = String(countDown)
        
        if (countDown == 0){
            countDown = 10
            counter.text = String(countDown)
            
            if (bonusType == 1){
                addNewNumber()
                self.image.texture = nil
                self.imageLabel.text = ""
                self.image.size = self.size
            }
            
            else if (bonusType == 2){
                addNewShape()
                self.image.size = self.size
            }
            
            else if (bonusType == 3){
                changeCombo()
            }
            
            else {
                bonusType += 2
            }
            
            bonusType += 1
            if(bonusType>3){
                bonusType -= 3
            }
            
            if (bonusType == 1){
                self.image.texture = SKTexture(imageNamed: "Circle.png")
                self.imageLabel.text = String(gameScene.totalNums + 1)
                self.image.size = CGSize(width: self.size.width*0.8, height: self.size.height*0.8)
            }
                
            else if (bonusType == 2){
                self.image.size = CGSize(width: self.size.width*0.8, height: self.size.height*0.8)
                switch gameScene.totalShapes{
                case 3:
                    self.image.texture = SKTexture(imageNamed: "Hexagon.png")
                    break
                case 4:
                    self.image.texture = SKTexture(imageNamed: "Star.png")
                    break
                case 5:
                    self.image.texture = SKTexture(imageNamed: "Trapezoid.png")
                default:
                    countDown = 1
                    bonusType = 0
                    launch()
                }
            }
                
            else { //bonusType == 3
                self.image.size = self.size
                nextCombo = comboList.removeAtIndex(Int(arc4random_uniform(UInt32(comboList.count))))
                switch nextCombo{
                case 1:
                    image.texture = SKTexture(imageNamed: "ComboLaser.png")
                    break
                case 2:
                    image.texture = SKTexture(imageNamed: "ComboXplode.png")
                    break
                default:
                    image.texture = SKTexture(imageNamed: "ComboShape.png")
                    break
                }
            }
        }
    }
    
    func addNewNumber(){
        self.gameScene.totalNums += 1
        self.gameScene.loadedTiles.last!.changeNumber(gameScene.totalNums)
        
        self.gameScene.tileChoices.append(gameScene.lastTile2)
        self.gameScene.lastTile2 = gameScene.totalNums
        
        gameScene.announcementCentre!.newAnnouncement("New Number " + String(gameScene.totalNums))
    }
    
    func addNewShape(){
        self.gameScene.totalShapes += 1
        switch gameScene.totalShapes{
        case 4:
            gameScene.loadedTiles.append(HexagonTile(gameScene: gameScene, number: gameScene.loadedTiles[2].number, angle: gameScene.currAngle))
            gameScene.announcementCentre!.newAnnouncement("New Hexagon Tile")
            break
        case 5:
            gameScene.loadedTiles.append(StarTile(gameScene: gameScene, number: gameScene.loadedTiles[2].number, angle: gameScene.currAngle))
            gameScene.announcementCentre!.newAnnouncement("New Star Tile")
            break
        case 6:
            gameScene.loadedTiles.append(TrapezoidTile(gameScene: gameScene, number: gameScene.loadedTiles[2].number, angle: gameScene.currAngle))
            gameScene.announcementCentre!.newAnnouncement("New Trapezoid Tile")
            break
        default:
            break
        }
        self.gameScene.loadedTiles[2].numLabel.removeFromParent()
        self.gameScene.loadedTiles.removeAtIndex(2).removeFromParent()
        
        
        
    }
    
    func changeCombo(){
        combosChanged += 1
        switch nextCombo{
        case 1:
            if (combosChanged % 2 == 1){
                if (gameScene.combo4!.type != 0){
                    comboList.append(Int(gameScene.combo4!.type))
                }
                gameScene.combo4!.changeCombo(2)
                gameScene.announcementCentre!.newAnnouncement("X4 Combo Updated")
            }
            else {
                if (gameScene.combo7!.type != 0){
                    comboList.append(Int(gameScene.combo7!.type))
                }
                gameScene.combo7!.changeCombo(2)
                gameScene.announcementCentre!.newAnnouncement("X7 Combo Updated")
            }
            break
        case 2:
            if (combosChanged % 2 == 1){
                if (gameScene.combo4!.type != 0){
                    comboList.append(Int(gameScene.combo4!.type))
                }
                gameScene.combo4!.changeCombo(3)
                gameScene.announcementCentre!.newAnnouncement("X4 Combo Updated")
            }
            else {
                if (gameScene.combo7!.type != 0){
                    comboList.append(Int(gameScene.combo7!.type))
                }
                gameScene.combo7!.changeCombo(3)
                gameScene.announcementCentre!.newAnnouncement("X7 Combo Updated")
            }
            break
        default:
            if (combosChanged % 2 == 1){
                if (gameScene.combo4!.type != 0){
                    comboList.append(Int(gameScene.combo4!.type))
                }
                gameScene.combo4!.changeCombo(1)
                gameScene.announcementCentre!.newAnnouncement("X4 Combo Updated")
            }
            else {
                if (gameScene.combo7!.type != 0){
                    comboList.append(Int(gameScene.combo7!.type))
                }
                gameScene.combo7!.changeCombo(1)
                gameScene.announcementCentre!.newAnnouncement("X7 Combo Updated")
            }
            break
        }
    }
}