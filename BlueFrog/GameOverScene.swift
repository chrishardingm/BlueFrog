//
//  GameOverScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/22/21.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var playAgain:SKSpriteNode!
    var scoreNum: SKLabelNode!
    var highscoreNum: SKLabelNode!
    let userDefaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        scoreNum = self.childNode(withName: "scoreNum") as? SKLabelNode
        if let userScore = userDefaults.value(forKey: "Score") as? Int {
            print(userScore)
            scoreNum.text = "\(userScore)"
        }
        else {
            scoreNum.text = "0"
        }
        
        highscoreNum = self.childNode(withName: "highscoreNum") as? SKLabelNode
        if let userHighScore = userDefaults.value(forKey: "HighScore") as? Int {
            print(userHighScore)
            highscoreNum.text = "\(userHighScore)"
        }
        else {
            highscoreNum.text = "0"
            userDefaults.set(0, forKey: "HighScore")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first {
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        print(positionInScene)

        if let name = touchedNode.name
        {
            print(name)
            if name == "replay"
            {
                print("play again touched")
                let transition:SKTransition = SKTransition.fade(withDuration: 2)
                if let scene:SKScene = GameOverScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
                }
            }
            if name == "mainMenu"
            {
                print("mainMenu was touched")
                let transition:SKTransition = SKTransition.fade(withDuration: 2)
                if let scene:SKScene = GameOverScene(fileNamed: "MenuScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
                }
            }
        }
        }
    }
}
