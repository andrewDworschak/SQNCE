//
//  GameTile.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-06.
//  Copyright © 2016 App App n Away. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameTile {
    var number : Int32 {get set}
    var gameScene : GameScene {get}
    var lineupPos : Int {get set}
    var adjacents : [GameTile] {get set}
    var numLabel : SKLabelNode {get}
    var destroying : Bool {get set}
    var highlight : SKSpriteNode {get}
    var white : SKSpriteNode {get}
    var physicsBody : SKPhysicsBody? {get set}
    var position: CGPoint {get set}
    var numConflicts : Int {get set}
    var prepped : Bool {get set}
    var prepping : Bool {get set}
    var destroyedThroughCombo : Bool {get set}
    var edgeDist : CGFloat {get set}
    var bottomDist : CGFloat {get set}
    
    
    init(gameScene: GameScene, number: Int32, angle: CGFloat)
    
    func moveAttachments(position: CGPoint)
    
    func advance()
    
    func prepare(x: CGFloat)
    
    func reset()
    
    func movePrep(x: CGFloat)
    
    func launch(x: CGFloat)
    
    func buildSequence()
    
    func buildSequence(currSeq: [GameTile])
    
    func destroy()
    
    func orientTo(angle: CGFloat)
    
    func rotate()
    
    func swap(secondTile : GameTile)
    
    func turnRed()
    
    func turnBlack()
    
    func changeNumber(num: Int32)
    
    func removeFromParent()
    
    func changeLineupPos(newPos: Int)
}