//
//  CatSelectionScene.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 17/09/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit
import SpriteKit

class CatSelectionScene: SKScene {
    
    var rightCatNode: CatSpriteNode!
    var leftCatNode: CatSpriteNode!
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var pageNumber = 0
    
    override func didMove(to view: SKView) {
        addCats()
        addButtons()
    }
    
    func addButtons() {
        
        upButton = SKSpriteNode(texture: SKTexture(imageNamed: "upButton"))
        upButton.position = CGPoint(x: 383, y: 735)
        upButton.zPosition = 2
        addChild(upButton)
        
        downButton = SKSpriteNode(texture: SKTexture(imageNamed: "downButton"))
        downButton.position = CGPoint(x: 383, y: -330)
        downButton.zPosition = 2
        addChild(downButton)
        
        for i in 1...3 {
            let currentCat = CatType(raw: i + pageNumber)
            
            let catBlock = SKSpriteNode(texture: SKTexture(imageNamed: "catBlock"))
            catBlock.zPosition = 2
            catBlock.position = CGPoint(x: 0, y: 540 - (i-1)*330)
            catBlock.name = "catBlock\(i)"
            addChild(catBlock)
            
            let catImage = SKSpriteNode(texture: SKTexture(imageNamed: (currentCat?.image)!), color: UIColor.clear, size: CGSize(width: 240, height: 240))
            catImage.zPosition = 2
            catImage.position = CGPoint(x: -191, y: 517 - (i-1)*330)
            catImage.name = "catImage\(i)"
            addChild(catImage)
            
            let coinImage = SKSpriteNode(texture: SKTexture(imageNamed: "coin"))
            coinImage.zPosition = 2
            coinImage.position = CGPoint(x: -22, y: 614 - (i-1)*330)
            coinImage.name = "coinImage\(i)"
            addChild(coinImage)
            
            let textLabel = SKLabelNode(fontNamed: "BradyBunchRemastered")
            textLabel.text = "\((currentCat?.price)!)"
            textLabel.zPosition = 2
            textLabel.fontSize = 72
            textLabel.fontColor = UIColor.black
            textLabel.position = CGPoint(x: 154, y: 592 - (i-1)*330)
            textLabel.name = "textLabel\(i)"
            addChild(textLabel)
            
            let button = SKSpriteNode(texture: SKTexture(imageNamed: "selectButton"))
            button.zPosition = 2
            button.name = "button\(i)"
            button.position = CGPoint(x: 125,y: 495 - (i-1)*330)
            addChild(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        
        if let touchedNode =
            atPoint(touch.location(in: self)) as? SKSpriteNode {
            if let nodeName = touchedNode.name {
                if nodeName.characters.count > 6 && nodeName.substring(to: 6) == "button" {
                    print(nodeName)
                    touchedNode.texture = SKTexture(imageNamed: "selectedButton")
                }
            }
        }
    }
    
    func addCats() {
        rightCatNode = CatSpriteNode(catType: .cat3, isLeftCat: false)
        leftCatNode = CatSpriteNode(catType: .cat2, isLeftCat: true)
        
        rightCatNode.position = CGPoint(x: 185, y: -690)
        rightCatNode.zPosition = 10
        rightCatNode.physicsBody?.isDynamic = false
        rightCatNode.physicsBody?.affectedByGravity = false
        
        leftCatNode.position = CGPoint(x: -171, y: -690)
        leftCatNode.zPosition = 10
        leftCatNode.physicsBody?.isDynamic = false
        leftCatNode.physicsBody?.affectedByGravity = false
        addChild(rightCatNode)
        addChild(leftCatNode)
    }

}
