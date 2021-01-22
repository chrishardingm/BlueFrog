//
//  GameScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/15/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var player:SKSpriteNode!
    var road:SKSpriteNode!
    var water:SKSpriteNode!
    
    var rowOne:SKSpriteNode!
    var rowTwo:SKSpriteNode!
    var rowThree:SKSpriteNode!
    var rowFour:SKSpriteNode!
    var rowFive:SKSpriteNode!
    var rowSix:SKSpriteNode!
    
    var object:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 0, y: -448)
        player.zPosition = 2
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: max(player.size.width / 2, player.size.height / 2))
        self.addChild(player)
        
        scoreLabel = SKLabelNode(text: "Score 0")
        scoreLabel.position = CGPoint(x: 0, y: +448)
        scoreLabel.fontSize = 36
        scoreLabel.fontName = "Arial-Bold"
        scoreLabel.fontColor = UIColor.black
        score = 0
        self.addChild(scoreLabel)
        
        createLevel()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
               let position = touch.location(in: self)
               print("touch position\(position)")
               print("Player position\(player.position)")
            
            // Moves the player forward or backward
                if position.y > player.position.y + 72{
                    player.position = CGPoint(x: player.position.x, y: player.position.y + 128)
                }
                if position.y < player.position.y - 72{
                    player.position = CGPoint(x: player.position.x, y: player.position.y - 128)
                }

            // Moves the player left or right
            if position.y > player.position.y - 60 && position.y < player.position.y + 60{
                if position.x < player.position.x && player.position.x > -200{
                    player.position = CGPoint(x: player.position.x - 128, y: player.position.y)
                }
                if position.x > player.position.x + 64 && player.position.x < 200{
                    player.position = CGPoint(x: player.position.x + 128, y: player.position.y)
                }
            }
        }
        //newcode
    }
    func createLevel() {
        let rowType = ["road","water","forest","road"]
        var lastRowPosition = player.position.y
        
        
        var shuffled = rowType.shuffled()
        rowOne = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowOne.position = CGPoint(x: 0, y: lastRowPosition + 128)
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowOne)
        lastRowPosition = rowOne.position.y
        
        shuffled = rowType.shuffled()
        rowTwo = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowTwo.position = CGPoint(x: 0, y: lastRowPosition + 128)
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowTwo)
        lastRowPosition = rowTwo.position.y
        
        shuffled = rowType.shuffled()
        rowThree = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowThree.position = CGPoint(x: 0, y: lastRowPosition + 128)
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowThree)
        lastRowPosition = rowThree.position.y
        
        shuffled = rowType.shuffled()
        rowFour = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowFour.position = CGPoint(x: 0, y: lastRowPosition + 128)
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowFour)
        lastRowPosition = rowFour.position.y
        
        shuffled = rowType.shuffled()
        rowFive = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowFive.position = CGPoint(x: 0, y: lastRowPosition + 128)
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowFive)
        lastRowPosition = rowFive.position.y
        
        shuffled = rowType.shuffled()
        rowSix = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowSix.position = CGPoint(x: 0, y: lastRowPosition + 128)
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowSix)
        lastRowPosition = rowSix.position.y

    }
    func populateRow (rowType: String, rowPosition: Int) {
        print(rowType, rowPosition)
        
        let maxObjects = 2
        var currentObjects = 0
        var newObjectPosition = -1024
        while currentObjects < maxObjects {
        object = SKSpriteNode(imageNamed: "object")
        object.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
        self.addChild(object)
        
        newObjectPosition += 128
        currentObjects += 1
        }
        
    }
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
