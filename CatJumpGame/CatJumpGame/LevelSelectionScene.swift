//
//  LevelSelectionScene.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 26/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
import GameplayKit

// An SKScene for level selection

class LevelSelectionScene: SKScene, SKPhysicsContactDelegate{
    
    let xPosition = [-350, -175, 0, 175, 350]
    let yPosition = [252, 70, -112]
    
    override func didMove(to view: SKView) {
        
        // Add level buttons according to how many levels the game can currently offer
        // Set button images according to the user's game status (one star, two star, three star, locked...)
        
        for i in 0..<AllLevels.shared.numberOfLevels {
            if i >= 15 {
                break
            }            
            var levelStatus = LevelCompleteType.locked
            if i < UserData.shared.unlockedLevels {
                levelStatus = UserData.shared.levelStatus[i]
            }
            let levelButton = LevelButtonNode(level: i+1, levelCompleteType: levelStatus)
            print("Adding level \(levelButton.level) button")
            levelButton.position = CGPoint(x: xPosition[(i%5)], y: yPosition[(i/5)])
            levelButton.zPosition = 10
            addChild(levelButton)
            if i < UserData.shared.unlockedLevels && UserData.shared.highScores[i] == 0 {
                levelButton.animateButton()
            }
        }
        
        let coinsLabel = SKLabelNode(fontNamed: "BradyBunchRemastered")
        coinsLabel.fontColor = UIColor.red
        coinsLabel.text = "\(UserData.shared.coins)"
        coinsLabel.fontSize = 50
        coinsLabel.zPosition = 15
        coinsLabel.position = CGPoint(x: 380, y: -990)
        addChild(coinsLabel)
        
        let leftCat = CatSpriteNode(catType: UserData.shared.leftCat, isLeftCat: true)
        leftCat.physicsBody?.isDynamic = false
        leftCat.position = CGPoint(x: -320, y: 630)
        leftCat.zPosition = 10
        addChild(leftCat)
        
        let rightCat = CatSpriteNode(catType: UserData.shared.rightCat, isLeftCat: false)
        rightCat.physicsBody?.isDynamic = false
        rightCat.position = CGPoint(x: 333, y: -704)
        rightCat.zPosition = 10
        addChild(rightCat)
                    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        
        if let touchedNode =
            atPoint(touch.location(in: self)) as? SKSpriteNode {
            if touchedNode.name == "levelButton" {
                let levelButton = touchedNode.parent as? LevelButtonNode
                if levelButton?.levelCompleteType != .locked {
                    print("Level button is \((levelButton?.level)!)")
                    transitionToScene(level: (levelButton?.level)!)
                }
            }
            if touchedNode.name == "level" {
                let levelButton = touchedNode as? LevelButtonNode
                if levelButton?.levelCompleteType != .locked {
                    transitionToScene(level: (levelButton?.level)!)
                }
            }
            if touchedNode.name == "catSelectionButton" {
                transitionToCatSelect()
            }
        }
    }
    
    // Handle transitioning to the level a user selected
    func transitionToScene(level: Int) {
        print("Transitionaing to new scene")
        print("Loading level \(level)")
        
        // When the user taps a level, try to load saved level from user's document directory, 
        // If no saved data exist, load a new game
        
        if let newScene = GameScene.loadLevel(num: level) as! GameScene? ?? SKScene(fileNamed: "GameScene") as? GameScene  {
            newScene.scaleMode = .aspectFill
            newScene.level = Level(num: level)
            _ = newScene.level.loadBread()
            view!.presentScene(newScene,
                               transition: SKTransition.flipVertical(withDuration: 0.5))
            
        }
    }
    
    func transitionToCatSelect() {
        print("Transitionaing to cat select")
        guard let newScene = SKScene(fileNamed: "CatSelectionScene")
            as? CatSelectionScene else {
                fatalError("Cannot load cat selection scene")
        }
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene,
                           transition: SKTransition.flipVertical(withDuration: 0.5))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


