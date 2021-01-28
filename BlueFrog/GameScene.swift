//
//  GameScene.swift
//  BlueFrog
//
//  Created by Chris Harding on 1/15/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var rowSeven:SKSpriteNode!
    
    var waterObject:SKSpriteNode!
    var waterFlowobject:SKSpriteNode!
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
    var maxObjects:Int = 0
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Time: \(score)"
        }
    }
    enum CollisionType: UInt32 {
        case player = 0b01
        case object = 0b10
        case goal = 0b11
        case border = 0b100
        case waterObjectleft = 0b101
        case waterObjectright = 0b110
    }
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
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
            physicsWorld.gravity = CGVector(dx: 0, dy: -0.025)
            laneDirectionSpeed = 1024
            maxHitPoints = 3
            hitPoints = 3
            maxObjects = 10
            addLivesEasy()
        } else if difficulty == "hard" {
            physicsWorld.gravity = CGVector(dx: 0, dy: -0.04)
            laneDirectionSpeed = 2048
            maxHitPoints = 1
            hitPoints = 1
            maxObjects = 14
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
        player.setScale(0.8)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: max(player.size.width / 2, player.size.height / 2))
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionType.object.rawValue
        player.physicsBody?.isDynamic = true
        self.addChild(player)
        
        scoreLabel = SKLabelNode(text: "Score 0")
        scoreLabel.position = CGPoint(x: 0, y: +512)
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
                    player.removeAllActions()
                }
                if position.y < player.position.y - 72{
                    player.position = CGPoint(x: player.position.x, y: player.position.y - 128)
                    player.removeAllActions()
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
            playerdeath()
        }
        let flashRedAction = SKAction.sequence([
            SKAction.colorize(with: .orange, colorBlendFactor: 1.0, duration: 0.15),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
        player.run(flashRedAction)
        hitPoints -= 1
    }
    func playerdeath() {
        
        let shrink = SKAction.scale(to: 0.5, duration: 2)
        let spin = SKAction.rotate(byAngle: 180, duration: 2)
        
        player.run(spin)
        player.run(shrink)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let transition:SKTransition = SKTransition.fade(withDuration: 5)
            if let scene:SKScene = GameOverScene(fileNamed: "GameOverScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    func createLevel() {
        let rowType = ["road","water","forest","road","water"]
        var lastRowPosition = player.position.y
        
        
        var shuffled = rowType.shuffled()
        rowOne = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowOne.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowOne.physicsBody = SKPhysicsBody(texture: rowOne.texture!, size: CGSize(width: rowOne.size.width, height: rowOne.size.height / 2))
        rowOne.physicsBody?.isDynamic = true
        rowOne.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowOne)
        lastRowPosition = rowOne.position.y
        
        shuffled = rowType.shuffled()
        rowTwo = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowTwo.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowTwo.physicsBody = SKPhysicsBody(texture: rowTwo.texture!, size: CGSize(width: rowTwo.size.width, height: rowTwo.size.height / 2))
        rowTwo.physicsBody?.isDynamic = true
        rowTwo.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowTwo)
        lastRowPosition = rowTwo.position.y
        
        shuffled = rowType.shuffled()
        rowThree = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowThree.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowThree.physicsBody = SKPhysicsBody(texture: rowThree.texture!, size: CGSize(width: rowThree.size.width, height: rowThree.size.height / 2))
        rowThree.physicsBody?.isDynamic = true
        rowThree.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowThree)
        lastRowPosition = rowThree.position.y
        
        shuffled = rowType.shuffled()
        rowFour = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowFour.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowFour.physicsBody = SKPhysicsBody(texture: rowFour.texture!, size: CGSize(width: rowFour.size.width, height: rowFour.size.height / 2))
        rowFour.physicsBody?.isDynamic = true
        rowFour.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowFour)
        lastRowPosition = rowFour.position.y
        
        shuffled = rowType.shuffled()
        rowFive = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowFive.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowFive.physicsBody = SKPhysicsBody(texture: rowFive.texture!, size: CGSize(width: rowFive.size.width, height: rowFive.size.height / 2))
        rowFive.physicsBody?.isDynamic = true
        rowFive.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowFive)
        lastRowPosition = rowFive.position.y
        
        shuffled = rowType.shuffled()
        rowSix = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowSix.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowSix.physicsBody = SKPhysicsBody(texture: rowSix.texture!, size: CGSize(width: rowSix.size.width, height: rowSix.size.height / 2))
        rowSix.physicsBody?.isDynamic = true
        rowSix.physicsBody?.collisionBitMask = 0
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
        
        var currentObjects = 0
        var currentFilledCollums = 0
        var newObjectPosition = -2048
        let laneDirectionRandomBool = Bool.random()
        var LaneDirection = 0

        if laneDirectionRandomBool == true && rowType != "forest"{
            LaneDirection = laneDirectionSpeed * -1
        }else if rowType != "forest"{
            LaneDirection = laneDirectionSpeed
        }
        if rowType == "water" {
            waterFlowobject = SKSpriteNode(imageNamed: "water")
            waterFlowobject.position = CGPoint(x: 0, y: rowPosition + 128)
            waterFlowobject.zPosition = 0
            waterFlowobject.physicsBody?.isDynamic = true
            waterFlowobject.physicsBody = SKPhysicsBody(texture: waterFlowobject.texture!, size: CGSize(width: waterFlowobject.size.width, height: waterFlowobject.size.height / 2))
            waterFlowobject.physicsBody?.collisionBitMask = 0
            if LaneDirection == -1024 {
                waterFlowobject.physicsBody?.categoryBitMask = CollisionType.waterObjectleft.rawValue
            }else{
                waterFlowobject.physicsBody?.categoryBitMask = CollisionType.waterObjectright.rawValue
            }
            waterFlowobject.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
            self.addChild(waterFlowobject)
        }
        
        let action = SKAction.moveBy(x: CGFloat(LaneDirection), y: 0, duration: 60)
        //let actionMove = SKAction.move(to: CGPoint(x: 500, y: 0), duration: 0.1)
        //let actionSequence = SKAction.sequence([action,actionMove,action])
        
        while currentFilledCollums < 32 {
            object = SKSpriteNode(imageNamed: "object")
            object.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
            object.setScale(0.8)
            object.physicsBody = SKPhysicsBody(circleOfRadius: max(object.size.width /  4, object.size.height / 4))
            object.physicsBody?.isDynamic = true
            object.physicsBody?.collisionBitMask = 0
            
            if rowType == "road" {
                object.texture = SKTexture(imageNamed: "object")
                object.zPosition = 3
                object.physicsBody?.categoryBitMask = CollisionType.object.rawValue
                object.physicsBody?.collisionBitMask = 0
                object.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
                
            } else if rowType == "water" {
                object.texture = SKTexture(imageNamed: "object")
                object.zPosition = 1
                object.physicsBody?.categoryBitMask = CollisionType.object.rawValue
                object.physicsBody?.collisionBitMask = 0
                object.physicsBody?.contactTestBitMask = CollisionType.player.rawValue

            } else if rowType == "forest"{
                object.texture = SKTexture(imageNamed: "tree")
                object.zPosition = 1
                object.physicsBody?.collisionBitMask = 0
            }
            
            waterObject = SKSpriteNode(imageNamed: "waterobject")
            waterObject.zPosition = 1
            waterObject.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
            waterObject.physicsBody = SKPhysicsBody(circleOfRadius: max(object.size.width /  4, object.size.height / 4))
            waterObject.physicsBody?.collisionBitMask = 0
            //waterObject.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
            waterObject.physicsBody?.isDynamic = true

            let randomBool = Bool.random()
            
            if randomBool == true && currentObjects < maxObjects{
                self.addChild(object)
                object.run(action)
                currentObjects += 1
            } else if rowType == "water"{
                self.addChild(waterObject)
                waterObject.run(action)
            }
            newObjectPosition += 128
            currentFilledCollums += 1
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
    //print("Objects did collide")
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
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
            
            
            let rotateleft = SKAction.rotate(byAngle: -1, duration: 0.25)
            let wait = SKAction.wait(forDuration: 0.25)
            let rotateright = SKAction.rotate(byAngle: 1, duration: 0.25)
            let turnaround = SKAction.rotate(byAngle: 10, duration: 0.25)
            let winAnimation = SKAction.sequence([rotateleft,wait,rotateright,wait,turnaround])

            player.run(winAnimation)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let transition:SKTransition = SKTransition.fade(withDuration: 5)
                if let scene:SKScene = GameOverScene(fileNamed: "GameOverScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
                }
            }
        }
        if firstBody.categoryBitMask == CollisionType.object.rawValue && secondBody.categoryBitMask == CollisionType.border.rawValue {
            //print("Object has reached the border")
        }
        if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectleft.rawValue {
            print("Entered River flowing left")
            let action = SKAction.moveBy(x: -1024, y: 0, duration: 60)
            player.run(action)

        }else if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectright.rawValue {
            print("Entered River flowing Right")
            let action = SKAction.moveBy(x: 1024, y: 0, duration: 60)
            player.run(action)
        }
    }
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectleft.rawValue {
            print("outside of River")
            player.removeAllActions()

        }else if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectright.rawValue {
            print("outside of River")
            player.removeAllActions()

        }
        
    }
    
}
