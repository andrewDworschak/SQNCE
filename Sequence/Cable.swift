//
//  Cable.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-09.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

class Cable {
    
    let gameScene: GameScene
    let tileA: GameTile
    let tileB: GameTile
    var chainlinks = [SKSpriteNode]()
    var numLinks = 0
    let serial : Int
    
    init(tileA: GameTile, tileB: GameTile, gameScene: GameScene, serial: Int){
        self.gameScene = gameScene
        self.serial = serial
        self.tileA = tileA
        self.tileB = tileB
        let distX = (tileB.position.x-tileA.position.x)
        let distY = (tileB.position.y-tileA.position.y)
        let distance = sqrt(distX*distX + distY*distY)
        let angle = CGFloat(atan(distY/distX))
        
        
        numLinks = Int((distance / (gameScene.frame.height*0.025))-0.5)
        
        for i in 1...numLinks{
            addChainlink(CGPoint(x: tileA.position.x+distX/CGFloat(numLinks)*(CGFloat(i)-0.5), y: tileA.position.y+distY/CGFloat(numLinks)*(CGFloat(i)-0.5)), angle: angle)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        let distX = (tileB.position.x-tileA.position.x)
        let distY = (tileB.position.y-tileA.position.y)
        let distance = sqrt(distX*distX + distY*distY)
        let angle = CGFloat(atan(distY/distX))
        
        let prevNumLinks = numLinks
        numLinks = Int((distance / (gameScene.frame.height*0.025))-0.5)
        
        for i in 0...(chainlinks.count-1){
            chainlinks[i].position = CGPoint(x: tileA.position.x+distX/CGFloat(numLinks)*(CGFloat(i)+0.5), y: tileA.position.y+distY/CGFloat(numLinks)*(CGFloat(i)+0.5))
            chainlinks[i].zRotation = angle
        }
        
        if (prevNumLinks-numLinks < 0){
            for i in (prevNumLinks-numLinks)..<0{
                addChainlink(CGPoint(x: tileA.position.x + distX/(CGFloat(numLinks+i)+0.5), y: tileA.position.y + distY/(CGFloat(numLinks+i)+0.5)), angle: angle)
            }
        }
        
        if (numLinks - prevNumLinks < 0){
            for _ in (numLinks - prevNumLinks)..<0{
                chainlinks.removeLast().removeFromParent()
            }
        }
    }
    
    func remove(){
        for chainlink in chainlinks{
            chainlink.removeFromParent()
        }
    }
    
    func addChainlink(position: CGPoint, angle: CGFloat){
        chainlinks.append(SKSpriteNode(imageNamed: "Chainlink.png"))
        chainlinks.last!.size = CGSize(width: gameScene.frame.height*0.04, height: gameScene.frame.height*0.04)
        chainlinks.last!.zPosition = 3
        chainlinks.last!.position = position
        chainlinks.last!.zRotation = angle
        
        self.gameScene.addChild(chainlinks.last!)
    }
}