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
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "shortWood")
        let size = CGSize(width: 350, height: 45)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: x, y: y)
        self.zPosition = 1
        self.name = "movingWood"
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
        let moveLeft = SKAction.move(by: CGVector(dx: -700, dy: 0), duration: 1.5)
        let moveRight = moveLeft.reversed()
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
