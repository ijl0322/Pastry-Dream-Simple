//
//  MovingWood.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 16/09/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit
import SpriteKit

class MovingWood: SKSpriteNode {
    var xPosition: CGFloat = 0.0
    var yPosition: CGFloat = 0.0
    
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "shortWood")
        let size = CGSize(width: 350, height: 45)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: x, y: y)
        self.zPosition = 1
        self.name = "movingWood"
        xPosition = x
        yPosition = y
        physicsSetUp()
        animationSetUP()
    }
    
    func physicsSetUp() {
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.collisionBitMask = PhysicsCategory.LeftCat | PhysicsCategory.RightCat
        physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
    }
    
    func animationSetUP() {
        let moveLeft = SKAction.moveTo(x: xPosition - 700, duration: 1.5)
        let moveRight =  SKAction.moveTo(x: xPosition, duration: 1.5)
        let moveSequence = SKAction.sequence([moveLeft, moveRight])
        let moveForever = SKAction.repeatForever(moveSequence)
        run(moveForever)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
}
