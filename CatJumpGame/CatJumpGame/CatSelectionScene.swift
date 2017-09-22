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
    var blocksHolder: SKSpriteNode!
    var selectionBackground: SKSpriteNode!
    var leftCatType = CatType.cat1
    var rightCatType = CatType.cat2
    var switchLeftCat = true
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var arrow: SKSpriteNode!
    var pageNumber = 0
    
    override func didMove(to view: SKView) {
        leftCatType = UserData.shared.leftCat
        rightCatType = UserData.shared.rightCat
        selectionBackground = childNode(withName: "selectionBackground") as! SKSpriteNode
        populateBlocks()
        addCats()
        addButtons()
    }
    
    func addButtons() {
        upButton = SKSpriteNode(texture: SKTexture(imageNamed: ButtonName.noUp))
        upButton.position = CGPoint(x: 383, y: 735)
        upButton.zPosition = 2
        upButton.name = ButtonName.up
        addChild(upButton)
        
        downButton = SKSpriteNode(texture: SKTexture(imageNamed: ButtonName.down))
        downButton.position = CGPoint(x: 383, y: -330)
        downButton.zPosition = 2
        downButton.name = ButtonName.down
        addChild(downButton)
        
        arrow = SKSpriteNode(texture: SKTexture(imageNamed: ButtonName.arrow))
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
    }
    
    func populateBlocks() {
        blocksHolder = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1536, height: 2048))
        addChild(blocksHolder)
        
        for i in 1...3 {
            let catNum = i + pageNumber * 3
            guard let currentCat = CatType(raw: catNum) else {
                return
            }
            
            let owned = UserData.shared.catsOwned[catNum] == 1
            dump(UserData.shared.catsOwned)
            let selected = currentCat == leftCatType || currentCat == rightCatType
            var buttonImageName = ButtonName.unlock
            var coinImageName = ButtonName.coin
            if owned && selected{
                buttonImageName = ButtonName.selected
                coinImageName = ButtonName.edit
            } else if owned {
                buttonImageName = ButtonName.select
                coinImageName = ButtonName.edit
            }
            
            let catBlock = SKSpriteNode(texture: SKTexture(imageNamed: "catBlock"))
            catBlock.zPosition = 2
            catBlock.position = CGPoint(x: 0, y: 540 - (i-1)*330)
            catBlock.name = "catBlock\(catNum)"
            blocksHolder.addChild(catBlock)
            
            let catImage = SKSpriteNode(texture: SKTexture(imageNamed: currentCat.image), color: UIColor.clear, size: CGSize(width: 240, height: 240))
            catImage.zPosition = 3
            catImage.position = CGPoint(x: -191, y: 517 - (i-1)*330)
            catImage.name = "catImage\(catNum)"
            blocksHolder.addChild(catImage)
            
            let coinImage = SKSpriteNode(texture: SKTexture(imageNamed: coinImageName))
            coinImage.zPosition = 3
            coinImage.position = CGPoint(x: -22, y: 614 - (i-1)*330)
            coinImage.name = "coinImage\(catNum)"
            blocksHolder.addChild(coinImage)
            
            let textLabel = SKLabelNode(fontNamed: "BradyBunchRemastered")
            textLabel.text = "\(currentCat.price)"
            textLabel.zPosition = 3
            textLabel.fontSize = 72
            textLabel.fontColor = UIColor.black
            textLabel.position = CGPoint(x: 154, y: 592 - (i-1)*330)
            textLabel.name = "textLabel\(catNum)"
            blocksHolder.addChild(textLabel)
            
            let button = SKSpriteNode(texture: SKTexture(imageNamed: buttonImageName))
            button.zPosition = 3
            button.name = "button\(catNum)"
            button.position = CGPoint(x: 125,y: 495 - (i-1)*330)
            blocksHolder.addChild(button)
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
            } else if nodeName == ButtonName.levelsLong {
                transitionToLevelSelect()
            } else if nodeName == ButtonName.down && (pageNumber + 1) * 3 < CatType.cat1.catCount{
                handlePageChange(isUp: false)
            } else if nodeName == ButtonName.up && pageNumber > 0 {
                handlePageChange(isUp: true)
            } else if nodeName == ButtonName.no {
                removeUnlockNotice()
            }
        }
    }
    
    func removeUnlockNotice() {
        blocksHolder.removeFromParent()
        populateBlocks()
        selectionBackground.texture = SKTexture(imageNamed: "catSelect")
    }
    
    func handlePageChange(isUp: Bool) {
        
        if isUp {
            pageNumber -= 1
            blocksHolder.removeFromParent()
            populateBlocks()
        } else {
            pageNumber += 1
            upButton.texture = SKTexture(imageNamed: ButtonName.up)
            blocksHolder.removeFromParent()
            populateBlocks()
        }
        
        let noUp = pageNumber == 0
        let noDown = (pageNumber + 1) * 3 >= CatType.cat1.catCount
        
        if noUp && !noDown{
            upButton.texture = SKTexture(imageNamed: ButtonName.noUp)
            downButton.texture = SKTexture(imageNamed: ButtonName.down)
        }
        
        if noDown && !noUp {
            downButton.texture = SKTexture(imageNamed: ButtonName.noDown)
            upButton.texture = SKTexture(imageNamed: ButtonName.up)
        }
    }
    
    func switchCat(num: Int, node: SKSpriteNode) {
        let newCat = CatType(raw: num)!
        print(newCat == leftCatType)
        print(newCat == rightCatType)
        
        // Disallow Duplicate cats
        if newCat == leftCatType || newCat == rightCatType {
            return
        }
        
//        print(num)
//        dump(UserData.shared.catsOwned)
        
        if UserData.shared.catsOwned[num] == 1 && switchLeftCat{
            
            node.texture = SKTexture(imageNamed: ButtonName.selected)
            leftCatNode.changeCatTypeTo(newType: newCat)
            UserData.shared.switchCat(newType: newCat, isLeftCat: true)
            if let oldCatButton = childNode(withName: "//button\(leftCatType.rawValue)") as? SKSpriteNode {
                oldCatButton.texture = SKTexture(imageNamed: ButtonName.select)
            }
            leftCatType = newCat
            
        } else if UserData.shared.catsOwned[num] == 1 && !switchLeftCat{
            
            node.texture = SKTexture(imageNamed: ButtonName.selected)
            rightCatNode.changeCatTypeTo(newType: newCat)
            UserData.shared.switchCat(newType: newCat, isLeftCat: false)
            if let oldCatButton = childNode(withName: "//button\(rightCatType.rawValue)") as? SKSpriteNode {
                oldCatButton.texture = SKTexture(imageNamed: ButtonName.select)
            }
            rightCatType = newCat
        }
        
        if UserData.shared.catsOwned[num] != 1 {
            presentUnlockCat(num: num)
        }
    }
    
    func presentUnlockCat(num: Int) {
        guard let cat = CatType.init(raw: num) else {
            return
        }
        
        selectionBackground.texture = SKTexture(imageNamed: "unlockNotice")
        
        print("unlock this cat ?")
        blocksHolder.removeFromParent()
        upButton.isHidden = true
        downButton.isHidden = true
        arrow.isHidden = true
        blocksHolder = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1536, height: 2048))
        blocksHolder.zPosition = 10
        addChild(blocksHolder)
        
        let yesButton = SKSpriteNode(texture: SKTexture(imageNamed: ButtonName.yes))
        yesButton.position = CGPoint(x: -295,y: -343)
        yesButton.name = ButtonName.yes
        let noButton = SKSpriteNode(texture: SKTexture(imageNamed: ButtonName.no))
        noButton.position = CGPoint(x: 295,y: -343)
        noButton.name = ButtonName.no
        blocksHolder.addChild(yesButton)
        blocksHolder.addChild(noButton)
        
        let priceLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 140)
        priceLabel.borderWidth = 10
        priceLabel.borderOffset = CGPoint(x: -3, y: -3)
        priceLabel.borderColor = UIColor.red
        priceLabel.fontColor = UIColor.white
        priceLabel.outlinedText = "\(cat.price)"
        priceLabel.zPosition = 15
        priceLabel.position = CGPoint(x: 120, y: -80)
        blocksHolder.addChild(priceLabel)
        
        let catImage = SKSpriteNode(texture: SKTexture(imageNamed: cat.image), color: UIColor.clear, size: CGSize(width: 500, height: 500))
        catImage.zPosition = 3
        catImage.position = CGPoint(x: 0, y: 350)
        blocksHolder.addChild(catImage)
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
