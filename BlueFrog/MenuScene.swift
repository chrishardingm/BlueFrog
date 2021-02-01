//
//  MenuScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/22/21.
//

import SpriteKit

class MenuScene: SKScene {

    var difficultyLabel: SKLabelNode!
    let userDefaults = UserDefaults.standard

    
    override func didMove(to view: SKView) {
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
                if name == "startGameButton"
                {
                    print("play again touched")
                    let transition:SKTransition = SKTransition.fade(withDuration: 5)
                    if let scene:SKScene = GameOverScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: transition)
                    }
                }
                if name == "difficultyButton"
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
