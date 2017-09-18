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
    var leftCatType = CatType.cat2
    var rightCatType = CatType.cat3
    var switchLeftCat = true
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var arrow: SKSpriteNode!
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
        
        arrow = SKSpriteNode(texture: SKTexture(imageNamed: "arrow"))
        arrow.zPosition = 2
        animateArrow()
        addChild(arrow)
        
        let coinsLabel = SKLabelNode(fontNamed: "BradyBunchRemastered")
        coinsLabel.fontColor = UIColor.red
        coinsLabel.text = "\(UserData.shared.coins)"
        coinsLabel.fontSize = 50
        coinsLabel.zPosition = 15
        coinsLabel.position = CGPoint(x: 380, y: -990)
        addChild(coinsLabel)
        
        for i in 1...3 {
            let currentCat = CatType(raw: i + pageNumber)
            let owned = UserData.shared.catsOwned[i] == 1
            let selected = currentCat == leftCatType || currentCat == rightCatType
            var buttonImageName = "unlockButton"
            var coinImageName = "coin"
            if owned && selected{
                buttonImageName = "selectedButton"
                coinImageName = "editButton"
            } else if owned {
                buttonImageName = "selectButton"
                coinImageName = "editButton"
            }
            
            let catBlock = SKSpriteNode(texture: SKTexture(imageNamed: "catBlock"))
            catBlock.zPosition = 2
            catBlock.position = CGPoint(x: 0, y: 540 - (i-1)*330)
            catBlock.name = "catBlock\(i)"
            addChild(catBlock)
            
            let catImage = SKSpriteNode(texture: SKTexture(imageNamed: (currentCat?.image)!), color: UIColor.clear, size: CGSize(width: 240, height: 240))
            catImage.zPosition = 3
            catImage.position = CGPoint(x: -191, y: 517 - (i-1)*330)
            catImage.name = "catImage\(i)"
            addChild(catImage)
            
            let coinImage = SKSpriteNode(texture: SKTexture(imageNamed: coinImageName))
            coinImage.zPosition = 3
            coinImage.position = CGPoint(x: -22, y: 614 - (i-1)*330)
            coinImage.name = "coinImage\(i)"
            addChild(coinImage)
            
            let textLabel = SKLabelNode(fontNamed: "BradyBunchRemastered")
            textLabel.text = "\((currentCat?.price)!)"
            textLabel.zPosition = 3
            textLabel.fontSize = 72
            textLabel.fontColor = UIColor.black
            textLabel.position = CGPoint(x: 154, y: 592 - (i-1)*330)
            textLabel.name = "textLabel\(i)"
            addChild(textLabel)
            
            let button = SKSpriteNode(texture: SKTexture(imageNamed: buttonImageName))
            button.zPosition = 3
            button.name = "button\(i)"
            button.position = CGPoint(x: 125,y: 495 - (i-1)*330)
            addChild(button)
        }
    }
    
    func animateArrow() {
        let bounce = SKAction.move(by: CGVector(dx: 50, dy: 0), duration: 0.4)
        let reverse = bounce.reversed()
        let sequence = SKAction.sequence([bounce, reverse])
        
        if switchLeftCat {
            arrow.position = CGPoint(x: -467, y: -690)
            arrow.run(SKAction.repeatForever(sequence), withKey: "bounce")
            arrow.xScale = 1
        } else {
            if !switchLeftCat {
                arrow.position = CGPoint(x: 467, y: -690)
                arrow.run(SKAction.repeatForever(sequence), withKey: "bounce")
                arrow.xScale = -1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        
        if let touchedNode = atPoint(touch.location(in: self)) as? SKSpriteNode {
            guard let nodeName = touchedNode.name else { return }
            if nodeName.characters.count > 6 && nodeName.substring(to: 6) == "button" {
                if let num = Int(nodeName.substring(from: 6)){
                    switchCat(num: num, node: touchedNode)
                }
            } else if nodeName == "leftCat" || nodeName == "rightCat" {
                switchLeftCat = !switchLeftCat
                animateArrow()
            } else if nodeName == "levelsLongButton" {
                transitionToLevelSelect()
            }
        }
    }
    
    func switchCat(num: Int, node: SKSpriteNode) {
        let newCat = CatType(raw: num)!
        print(newCat == leftCatType)
        print(newCat == rightCatType)
        
        // Disallow Duplicate cats
        if newCat == leftCatType || newCat == rightCatType {
            print("Duplicate Cat")
            return
        }
        
        if UserData.shared.catsOwned[num] == 1 && switchLeftCat{
            let oldCatButton = childNode(withName: "button\(leftCatType.rawValue)") as! SKSpriteNode
            oldCatButton.texture = SKTexture(imageNamed: "selectButton")
            node.texture = SKTexture(imageNamed: "selectedButton")

            leftCatNode.changeCatTypeTo(newType: newCat)
            leftCatType = newCat
            UserData.shared.switchCat(newType: leftCatType, isLeftCat: true)
            
        } else if UserData.shared.catsOwned[num] == 1 && !switchLeftCat{
            let oldCatButton = childNode(withName: "button\(rightCatType.rawValue)") as! SKSpriteNode
            oldCatButton.texture = SKTexture(imageNamed: "selectButton")
            node.texture = SKTexture(imageNamed: "selectedButton")
            
            rightCatNode.changeCatTypeTo(newType: newCat)
            rightCatType = newCat
            UserData.shared.switchCat(newType: rightCatType, isLeftCat: false)
        }
    }
    
    func addCats() {
        
        leftCatType = UserData.shared.leftCat
        rightCatType = UserData.shared.rightCat
        rightCatNode = CatSpriteNode(catType: rightCatType, isLeftCat: false)
        leftCatNode = CatSpriteNode(catType: leftCatType, isLeftCat: true)
        
        rightCatNode.position = CGPoint(x: 185, y: -690)
        rightCatNode.zPosition = 10
        rightCatNode.physicsBody?.isDynamic = false
        rightCatNode.physicsBody?.affectedByGravity = false
        rightCatNode.name = "rightCat"
        
        leftCatNode.position = CGPoint(x: -171, y: -690)
        leftCatNode.zPosition = 10
        leftCatNode.physicsBody?.isDynamic = false
        leftCatNode.physicsBody?.affectedByGravity = false
        leftCatNode.name = "leftCat"
        
        addChild(rightCatNode)
        addChild(leftCatNode)
    }

    func transitionToLevelSelect() {
        print("Transitionaing to level select")
        guard let newScene = SKScene(fileNamed: "LevelSelectionScene")
            as? LevelSelectionScene else {
                fatalError("Cannot load level selection scene")
        }
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene,
                           transition: SKTransition.flipVertical(withDuration: 0.5))
    }
}
