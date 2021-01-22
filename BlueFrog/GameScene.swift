//
//  GameScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/15/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //let playerTypeCategory: Unit
    
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
    
    var hpSprite:SKSpriteNode!
    var hitPoints:Int = 0
    var difficulty:String = ""
    var laneDirectionSpeed:Int = 0
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        difficulty = "easy"
        if difficulty == "easy" {
            addHitPoints(maxHitPoints: 3)
            laneDirectionSpeed = 128
        } else if difficulty == "hard" {
            addHitPoints(maxHitPoints: 1)
            laneDirectionSpeed = 256
        }
        
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 0, y: -448)
        player.zPosition = 2
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: max(player.size.width / 2, player.size.height / 2))
        //player.physicsBody.categoryBitMask = playerTypeCategory
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
        
    }
    func addHitPoints(maxHitPoints: Int){
        var lastHitPointPosition = 320
        while hitPoints < maxHitPoints {
            hpSprite = SKSpriteNode(imageNamed: "player")
            hpSprite.setScale(0.5)
            hpSprite.position = CGPoint(x: lastHitPointPosition, y: +448)
            hpSprite.zPosition = 3
            self.addChild(hpSprite)
            
            lastHitPointPosition -= 64
            hitPoints += 1
        }
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
        
        let maxObjects = 3
        var currentObjects = 0
        var newObjectPosition = -256
        let laneDirectionRandomBool = Bool.random()
        var LaneDirection = 0

        if laneDirectionRandomBool == true && rowType != "forest"{
            LaneDirection = laneDirectionSpeed * -1
        }else if rowType != "forest"{
            LaneDirection = laneDirectionSpeed
        }
        let action = SKAction.moveBy(x: CGFloat(LaneDirection), y: 0, duration: 100)
        
        while currentObjects < maxObjects {
            object = SKSpriteNode(imageNamed: "object")
            object.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
            object.physicsBody = SKPhysicsBody(circleOfRadius: max(player.size.width / 2, player.size.height / 2))
            object.zPosition = 2
            self.addChild(object)
            object.run(action)
            
            let randomBool = Bool.random()
            if randomBool == true {
                newObjectPosition += 256
            } else {
                newObjectPosition += 128
            }
            currentObjects += 1
        }
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        print("objects did collide")
    }
    
}
