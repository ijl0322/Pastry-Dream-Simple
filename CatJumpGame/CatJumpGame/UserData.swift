//
//  UserData.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import Foundation
import UIKit

// A singleton that keeps track of the user's current game status
// Including the high scores/ levels status/ levels unlocked, 
// Save/Get data from user defaults, and also sends the status to firebase

class UserData {
    static let shared = UserData()
    let defaults = UserDefaults.standard
    var highScores = [0]
    var levelStatus: [LevelCompleteType] = [.lose]
    var nickName = "Anonymous"
    var coins = 0
    var catsOwned:[Int] = []
    var leftCat = CatType.cat1
    var rightCat = CatType.cat2
    var unlockedLevels: Int {
        return highScores.count
    }
    
    init() {
        
        //If there are data saved in user defaults, initialize the singleton using values from user defaults
        if let nickName = defaults.object(forKey: "nickName") as? String {
            self.nickName = nickName
            print("Getting from user defaults")
        } else {
            defaults.set(nickName, forKey: "nickName")
        }
        
        if let highScores = defaults.array(forKey: "highScores") as? [Int] {
            self.highScores = highScores
        } else {
            defaults.set(highScores, forKey: "highScores")
        }
        
        if let levelStatusRaw = defaults.array(forKey: "levelStatus") as? [Int] {
            self.levelStatus = rawToLevelStatus(raw: levelStatusRaw)
        } else {
            defaults.set(levelStatusToRaw(), forKey: "levelStatus")
        }
        
        if let coins = defaults.integer(forKey: "coins") as Int?{
            self.coins = coins
        } else {
            defaults.set(coins, forKey: "coins")
        }
        
        if let leftCatVal = defaults.integer(forKey: "leftCat") as Int?{
            if leftCatVal != 0 {
                leftCat = CatType(raw: leftCatVal)!
                print("Retrieving left cat to \(leftCat)")
            } else {
                defaults.set(leftCat.rawValue, forKey: "leftCat")
                print("Setting left cat to \(leftCat)")
            }
        }
        
        if let rightCatVal = defaults.integer(forKey: "rightCat") as Int? {
            if rightCatVal != 0 {
                rightCat = CatType(raw: rightCatVal)!
                print("Retrieving cat to \(rightCat)")
            } else {
                defaults.set(rightCat.rawValue, forKey: "rightCat")
                print("Setting cat to \(rightCat)")
            }
        }
        
        if let catsOwned = defaults.array(forKey: "catsOwned") as? [Int] {
            self.catsOwned = catsOwned
            if catsOwned.count < CatType.cat1.catCount {
                for _ in catsOwned.count..<CatType.cat1.catCount {
                    self.catsOwned.append(0)
                    defaults.set(self.catsOwned, forKey: "catsOwned")
                }
            }
        } else {
            for _ in 0...CatType.cat1.catCount {
                self.catsOwned.append(0)
            }
            self.catsOwned[1] = 1
            self.catsOwned[2] = 1
            defaults.set(self.catsOwned, forKey: "catsOwned")
        }
    }
    
    func switchCat(newType: CatType, isLeftCat: Bool) {
        if isLeftCat {
            leftCat = newType
            defaults.set(leftCat.rawValue, forKey: "leftCat")
        } else {
            rightCat = newType
            defaults.set(rightCat.rawValue, forKey: "rightCat")
        }
    }
        
    // Changes the user's nickname
    func changeNickname(name: String) {
        nickName = name
        print("Changing nickname to \(nickName)")
        defaults.set(nickName, forKey: "nickName")
    }
    
    // LevelCompleteType is a enumeration that can be initialized from Int value
    // This converts the levelStatus array to and Int array
    func levelStatusToRaw() -> [Int]{
        let newLevelStatusArray = levelStatus.map({ (value: LevelCompleteType) -> Int in
            return value.rawValue
        })
        return newLevelStatusArray
    }
    
    // Converts an Int array to a LevelCompleteType array
    func rawToLevelStatus(raw: [Int]) -> [LevelCompleteType] {
        let newLevelStatus = raw.map({ (value: Int) -> LevelCompleteType in
            return LevelCompleteType.init(raw: value)!
        })
        return newLevelStatus
    }
    
    // Update the High Score for a certain level and updates user defaults and firebase's data
    func updateHighScoreForLevel(_ num: Int, score: Int, levelCompleteType: LevelCompleteType) {
        print("Updating user high score")

        if num <= highScores.count {
            if highScores[num - 1] < score {
                highScores[num - 1] = score
                levelStatus[num - 1] = levelCompleteType
                print("High Score for level \(num) is: \(highScores[num - 1])")
            }
        } else {
            highScores.append(score)
            print("High Score for level \(num) is: \(highScores[num - 1])")
            levelStatus[num - 1] = levelCompleteType
        }
        
        if levelCompleteType != .lose && num == highScores.count{
            print("unlocking a new level")
            highScores.append(0)
            levelStatus.append(.lose)
        }
        
        coins += levelCompleteType.coins
        print("The user now has \(coins) coins")
        
        defaults.set(coins, forKey: "coins")
        defaults.set(highScores, forKey: "highScores")
        defaults.set(levelStatusToRaw(), forKey: "levelStatus")
    }
}
