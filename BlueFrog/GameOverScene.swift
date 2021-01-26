//
//  GameOverScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/22/21.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var playAgain:SKSpriteNode!
    
    override func didMove(to view: SKView) {
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
                let transition:SKTransition = SKTransition.fade(withDuration: 5)
                if let scene:SKScene = GameOverScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
                }
            }
            if name == "mainMenu"
            {
                print("mainMenu was touched")
                let transition:SKTransition = SKTransition.fade(withDuration: 5)
                if let scene:SKScene = GameOverScene(fileNamed: "MenuScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
                }
            }
        }
        }
    }
}
