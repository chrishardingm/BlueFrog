//
//  MenuScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/22/21.
//

import SpriteKit

class MenuScene: SKScene {

    var difficultyLabel: SKLabelNode!
    var backroundImage: SKSpriteNode!
    var backroundImage2: SKSpriteNode!
    let userDefaults = UserDefaults.standard

    
    override func didMove(to view: SKView) {
        backroundImage = SKSpriteNode(imageNamed: "GrassB")
        backroundImage.position = CGPoint(x: 375, y: 345)
        backroundImage.zPosition = 0
        backroundImage.setScale(1.2)
        self.addChild(backroundImage)
        
        backroundImage2 = SKSpriteNode(imageNamed: "GrassB")
        backroundImage2.position = CGPoint(x: 375, y: 955)
        backroundImage2.zPosition = 0
        backroundImage2.setScale(1.2)
        self.addChild(backroundImage2)
        
        difficultyLabel = self.childNode(withName: "difficultyLabel") as? SKLabelNode
        if let gameDifficulty = userDefaults.value(forKey: "GameDifficulty") as? String {
            difficultyLabel.text = gameDifficulty
        } else {
            difficultyLabel.text = DifficultyOptions.Easy.description
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
                if name == "startGameButton" || name == "startGameButton2"
                {
                    print("play again touched")
                    let transition:SKTransition = SKTransition.fade(withDuration: 2)
                    if let scene:SKScene = GameOverScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: transition)
                    }
                }
                if name == "difficultyButton" || name == "difficultyButton2"
                {
                    print("Player touched difficulty button")
                    guard let difficulty = DifficultyOptions(rawValue: difficultyLabel.text!) else { return }
                    switch difficulty {
                    case .Easy:
                        difficultyLabel.text = DifficultyOptions.Medium.description
                        userDefaults.set(DifficultyOptions.Medium.description, forKey: "GameDifficulty")
                    case .Medium:
                        difficultyLabel.text = DifficultyOptions.Hard.description
                        userDefaults.set(DifficultyOptions.Hard.description, forKey: "GameDifficulty")
                    case .Hard:
                        difficultyLabel.text = DifficultyOptions.Easy.description
                        userDefaults.set(DifficultyOptions.Easy.description, forKey: "GameDifficulty")
                    }
                }
            }
        }
    }
}
