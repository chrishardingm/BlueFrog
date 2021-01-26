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
    var rowSeven:SKSpriteNode!
    
    var object:SKSpriteNode!
    var leftBorder:SKSpriteNode!
    var rightBorder:SKSpriteNode!
    
    var hpSprite1:SKSpriteNode!
    var hpSprite2:SKSpriteNode!
    var hpSprite3:SKSpriteNode!

    var hitPoints:Int = 0
    var maxHitPoints:Int = 0
    var difficulty:String = ""
    var laneDirectionSpeed:Int = 0
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    enum CollisionType: UInt32 {
        case player = 0b01
        case object = 0b10
        case goal = 0b11
        case border = 0b100
    }
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        hpSprite1 = SKSpriteNode(imageNamed: "player")
        hpSprite1.setScale(0.5)
        hpSprite1.zPosition = 3
        hpSprite1.position = CGPoint(x: 320, y: +448)
        
        hpSprite2 = SKSpriteNode(imageNamed: "player")
        hpSprite2.setScale(0.5)
        hpSprite2.zPosition = 3
        hpSprite2.position = CGPoint(x: 256, y: +448)
        
        hpSprite3 = SKSpriteNode(imageNamed: "player")
        hpSprite3.setScale(0.5)
        hpSprite3.zPosition = 3
        hpSprite3.position = CGPoint(x: 192, y: +448)
        
        // Detect difficulty and adjust game variables.
        difficulty = "easy"
        if difficulty == "easy" {
            laneDirectionSpeed = 512
            maxHitPoints = 3
            hitPoints = 3
            addLivesEasy()
        } else if difficulty == "hard" {
            laneDirectionSpeed = 1024
            maxHitPoints = 1
            hitPoints = 1
            addLivesHard()
        }
        // Creating the Border wall for objects.
        leftBorder = SKSpriteNode(imageNamed: "border")
        leftBorder.position = CGPoint(x: -439, y: 0)
        leftBorder.physicsBody = SKPhysicsBody(texture: leftBorder.texture!, size: CGSize(width: leftBorder.size.width, height: leftBorder.size.height))
        leftBorder.physicsBody?.categoryBitMask = CollisionType.border.rawValue
        leftBorder.physicsBody?.collisionBitMask = 0
        leftBorder.physicsBody?.contactTestBitMask = CollisionType.object.rawValue
        leftBorder.physicsBody?.isDynamic = true
        self.addChild(leftBorder)
        
        rightBorder = SKSpriteNode(imageNamed: "border")
        rightBorder.position = CGPoint(x: 439, y: 0)
        rightBorder.physicsBody = SKPhysicsBody(texture: rightBorder.texture!, size: CGSize(width: rightBorder.size.width, height: rightBorder.size.height))
        rightBorder.physicsBody?.categoryBitMask = CollisionType.border.rawValue
        rightBorder.physicsBody?.collisionBitMask = 0
        rightBorder.physicsBody?.contactTestBitMask = CollisionType.object.rawValue
        rightBorder.physicsBody?.isDynamic = true
        self.addChild(rightBorder)

        // Creating the player.
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 0, y: -448)
        player.zPosition = 2
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: max(player.size.width / 2, player.size.height / 2))
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionType.object.rawValue
        player.physicsBody?.isDynamic = false
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
               //print("Player position\(player.position)")
            
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
    func addLivesEasy(){
        self.addChild(hpSprite1)
        self.addChild(hpSprite2)
        self.addChild(hpSprite3)
    }
    func addLivesHard(){
        self.addChild(hpSprite1)
    }
    func takeDamage() {
        
        if hitPoints == 3 {
            hpSprite3.removeFromParent()
        }
        if hitPoints == 2 {
            hpSprite2.removeFromParent()
        }
        if hitPoints == 1 {
            hpSprite1.removeFromParent()
        }
        if hitPoints == 0 {
            print("You lose")
            let transition:SKTransition = SKTransition.fade(withDuration: 5)
            if let scene:SKScene = GameOverScene(fileNamed: "GameOverScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: transition)
            }
        }
        hitPoints -= 1
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
        
        rowSeven = SKSpriteNode(imageNamed: "goal")
        rowSeven.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowSeven.physicsBody = SKPhysicsBody(texture: rowSeven.texture!, size: CGSize(width: rowSeven.size.width, height: rowSeven.size.height / 2))
        rowSeven.physicsBody?.isDynamic = true
        rowSeven.physicsBody?.categoryBitMask = CollisionType.goal.rawValue
        rowSeven.physicsBody?.collisionBitMask = 0
        rowSeven.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        self.addChild(rowSeven)
        lastRowPosition = rowSeven.position.y

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
        let action = SKAction.moveBy(x: CGFloat(LaneDirection), y: 0, duration: 60)
        let actionMove = SKAction.move(to: CGPoint(x: 500, y: 0), duration: 0.1)
        let actionSequence = SKAction.sequence([action,actionMove,action])
        
        while currentObjects < maxObjects {
            object = SKSpriteNode(imageNamed: "object")
            object.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
            object.physicsBody = SKPhysicsBody(circleOfRadius: max(object.size.width /  4, object.size.height / 4))
            object.physicsBody?.isDynamic = true
            object.physicsBody?.categoryBitMask = CollisionType.object.rawValue
            object.physicsBody?.collisionBitMask = 0
            object.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
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
    func didBegin(_ contact: SKPhysicsContact) {
    //print("Objects did collide")
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        var collisionPoint:CGPoint
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.object.rawValue {
            print("player tocuhed an object")
            takeDamage()
        }
        else if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.goal.rawValue {
            print("player has reached the goal")
            let transition:SKTransition = SKTransition.fade(withDuration: 5)
            if let scene:SKScene = GameOverScene(fileNamed: "GameOverScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: transition)
            }
        }
        if firstBody.categoryBitMask == CollisionType.object.rawValue && secondBody.categoryBitMask == CollisionType.border.rawValue {
            print("Object has reached the border")
        }
    }
    
}
