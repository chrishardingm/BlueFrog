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
    
    var rowZero:SKSpriteNode!
    var rowOne:SKSpriteNode!
    var rowTwo:SKSpriteNode!
    var rowThree:SKSpriteNode!
    var rowFour:SKSpriteNode!
    var rowFive:SKSpriteNode!
    var rowSix:SKSpriteNode!
    var rowSeven:SKSpriteNode!
    var rowEight:SKSpriteNode!
    var lastRow:SKSpriteNode!
    
    var waterObject:SKSpriteNode!
    var waterFlowobject:SKSpriteNode!
    var object:SKSpriteNode!
    var leftBorder:SKSpriteNode!
    var rightBorder:SKSpriteNode!
    var bottomBorder:SKSpriteNode!
    
    var hpSprite1:SKSpriteNode!
    var hpSprite2:SKSpriteNode!
    var hpSprite3:SKSpriteNode!

    var hitPoints:Int = 0
    var maxHitPoints:Int = 0
    var difficulty:String = "Easy"
    var playerdirection:String = "Forward"
    var score:Int = 0
    var timer:Double = 0.0
    var gameHasEnded: Bool = false
    var laneDirectionRandomBool = true
    var laneDirectionSpeed:Int = 2048
    var maxObjects:Int = 0
    var playerXMovement:CGFloat = 128

    let userDefaults = UserDefaults.standard

    enum CollisionType: UInt32 {
        case player = 0b01
        case object = 0b10
        case goal = 0b11
        case border = 0b100
        case waterObjectleft = 0b101
        case waterObjectright = 0b110
    }
    override func didMove(to view: SKView) {
        
        self.scaleMode = .aspectFill
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        hpSprite1 = SKSpriteNode(imageNamed: "frog1")
        hpSprite1.setScale(0.5)
        hpSprite1.zPosition = 4
        hpSprite1.position = CGPoint(x: 320, y: +500)
        
        hpSprite2 = SKSpriteNode(imageNamed: "frog1")
        hpSprite2.setScale(0.5)
        hpSprite2.zPosition = 4
        hpSprite2.position = CGPoint(x: 256, y: +500)
        
        hpSprite3 = SKSpriteNode(imageNamed: "frog1")
        hpSprite3.setScale(0.5)
        hpSprite3.zPosition = 4
        hpSprite3.position = CGPoint(x: 192, y: +500)
        
        // Detect difficulty and adjust game variables.
        if let gameDifficulty = userDefaults.value(forKey: "GameDifficulty") as? String {
            difficulty = gameDifficulty
        }
        if difficulty == "Easy" {
            physicsWorld.gravity = CGVector(dx: 0, dy: -0.025)
            maxHitPoints = 3
            hitPoints = 3
            maxObjects = 16
            addLivesEasy()
        } else if difficulty == "Medium" {
            physicsWorld.gravity = CGVector(dx: 0, dy: -0.03)
            maxHitPoints = 2
            hitPoints = 2
            maxObjects = 18
            addLivesMedium()
        } else if difficulty == "Hard" {
            physicsWorld.gravity = CGVector(dx: 0, dy: -0.035)
            maxHitPoints = 1
            hitPoints = 1
            maxObjects = 20
            addLivesHard()
        }
        
        // Creating the Border wall for the Player.
        leftBorder = SKSpriteNode(imageNamed: "border")
        leftBorder.position = CGPoint(x: -567, y: 0)
        leftBorder.physicsBody = SKPhysicsBody(texture: leftBorder.texture!, size: CGSize(width: leftBorder.size.width, height: leftBorder.size.height))
        leftBorder.physicsBody?.categoryBitMask = CollisionType.border.rawValue
        leftBorder.physicsBody?.collisionBitMask = 0
        leftBorder.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        leftBorder.physicsBody?.isDynamic = false
        self.addChild(leftBorder)
        
        rightBorder = SKSpriteNode(imageNamed: "border")
        rightBorder.position = CGPoint(x: 567, y: 0)
        rightBorder.physicsBody = SKPhysicsBody(texture: rightBorder.texture!, size: CGSize(width: rightBorder.size.width, height: rightBorder.size.height))
        rightBorder.physicsBody?.categoryBitMask = CollisionType.border.rawValue
        rightBorder.physicsBody?.collisionBitMask = 0
        rightBorder.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        rightBorder.physicsBody?.isDynamic = false
        self.addChild(rightBorder)
        
        bottomBorder = SKSpriteNode(imageNamed: "border2")
        bottomBorder.position = CGPoint(x: 0, y: -740)
        bottomBorder.physicsBody = SKPhysicsBody(texture: bottomBorder.texture!, size: CGSize(width: bottomBorder.size.width, height: bottomBorder.size.height))
        bottomBorder.physicsBody?.categoryBitMask = CollisionType.border.rawValue
        bottomBorder.physicsBody?.collisionBitMask = 0
        bottomBorder.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        bottomBorder.physicsBody?.isDynamic = false
        self.addChild(bottomBorder)

        // Creating the player.
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 0, y: -448)
        player.zPosition = 2
        player.setScale(0.7)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: max(player.size.width / 2, player.size.height / 2))
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionType.object.rawValue
        player.physicsBody?.isDynamic = true
        self.addChild(player)
        
        createLevel()
    }
    // Game timer used to calculate the score
    override func update(_ currentTime: TimeInterval){
        timer = timer.advanced(by: 0.01)
        //print(timer)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
               let position = touch.location(in: self)
               //print("touch position\(position)")
               //print("Player position\(player.position)")
            
            // Animations for the players movemnet.
            let jump = SKAction.scale(to: 0.9, duration: 0.025)
            let shrink = SKAction.scale(to: 0.7, duration: 0.025)
            let wait = SKAction.wait(forDuration: 0.025)
            let jumpAnimation = SKAction.sequence([jump,wait,shrink])
            let moveLeft = SKAction.moveBy(x: -playerXMovement, y: 0, duration: 0.05)
            let moveRight = SKAction.moveBy(x: playerXMovement, y: 0, duration: 0.05)
            let moveUp = SKAction.moveBy(x: 0, y: 128, duration: 0.05)
            let MoveDown = SKAction.moveBy(x: 0, y: -128, duration: 0.05)
            let rotateLeft = SKAction.rotate(byAngle: 1.57, duration: 0.1)
            let rotateRight = SKAction.rotate(byAngle: -1.57, duration: 0.1)
            let turnaround = SKAction.rotate(byAngle: .pi, duration: 0.1)

            
            // Moves the player forward or backward
            if position.y > player.position.y + 72 || position.y < player.position.y - 72 && gameHasEnded == false{
                if position.y > player.position.y + 64{
                    player.run(jumpAnimation)
                    player.run(moveUp)
                    adjustXPosition2()
                    if playerdirection == "Left" {
                        player.run(rotateRight)
                    }
                    if playerdirection == "Right" {
                        player.run(rotateLeft)
                    }
                    if playerdirection == "Back" {
                        player.run(turnaround)
                    }
                    playerdirection = "Forward"
                }
                if position.y < player.position.y - 64{
                    player.run(jumpAnimation)
                    player.run(MoveDown)
                    adjustXPosition2()
                    if playerdirection == "Left" {
                        player.run(rotateLeft)
                    }
                    if playerdirection == "Right" {
                        player.run(rotateRight)
                    }
                    if playerdirection == "Forward" {
                        player.run(turnaround)
                    }
                    playerdirection = "Back"
                }
                
            }else if gameHasEnded == false{
            // Moves the player left or right
                if position.x < player.position.x && player.position.x > -200{
                    player.run(jumpAnimation)
                    player.run(moveLeft)
                    if playerdirection == "Forward" {
                        player.run(rotateLeft)
                    } else if playerdirection == "Back" {
                        player.run(rotateRight)
                    } else if playerdirection == "Right" {
                        player.run(turnaround)
                    }
                    playerdirection = "Left"
                }
                if position.x > player.position.x + 64 && player.position.x < 200{
                    player.run(jumpAnimation)
                    player.run(moveRight)
                    if playerdirection == "Forward" {
                        player.run(rotateRight)
                    } else if playerdirection == "Back" {
                        player.run(rotateLeft)
                    } else if playerdirection == "Left" {
                        player.run(turnaround)
                    }
                    playerdirection = "Right"
                }
            }
        }
    }
    //This function will help keep the player on the grid base movement.
    func adjustXPosition2() {
        if player.position.x.truncatingRemainder(dividingBy: playerXMovement) != 0 && player.position.x != 0 {
            let XPositionRemainder = player.position.x.remainder(dividingBy: playerXMovement)
            //print(XPositionRemainder)
            //print("Player position\(player.position)")
            let moveX = SKAction.moveBy(x: -XPositionRemainder, y: 0, duration: 0.01)
            player.run(moveX)
        }
    }
    func adjustXPosition3() {

        //Center block
        if player.position.x > 0 && player.position.x <= 64 {
            player.position.x = 0
        }
        if player.position.x < 0 && player.position.x >= -64 {
            player.position.x = 0
        }
        
        //First right block
        if player.position.x > 64 && player.position.x < 128 {
            player.position.x = 128
        }
        if player.position.x > 128 && player.position.x <= 192 {
            player.position.x = 128
        }
        
        //First left block
        if player.position.x > -64 && player.position.x < -128 {
            player.position.x = 128
        }
        if player.position.x > -128 && player.position.x <= -192 {
            player.position.x = 128
        }
        
        //Second Right block
        if player.position.x > 192 && player.position.x < 256 {
            player.position.x = 256
        }
        if player.position.x > 256 && player.position.x <= 500 {
            player.position.x = 256
        }
        
        //Second Left block
        if player.position.x > -192 && player.position.x < -256 {
            player.position.x = 256
        }
        if player.position.x > -256 && player.position.x <= -500 {
            player.position.x = 256
        }
        
    }
    func addLivesEasy(){
        self.addChild(hpSprite1)
        self.addChild(hpSprite2)
        self.addChild(hpSprite3)
    }
    func addLivesMedium(){
        self.addChild(hpSprite1)
        self.addChild(hpSprite2)
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
            print("You lose")
            playerdeath()
        }
        if hitPoints == 0 {
            
        }
        // Animation for player damage
        let flashRedAction = SKAction.sequence([
            SKAction.colorize(with: .orange, colorBlendFactor: 1.0, duration: 0.15),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
        player.run(flashRedAction)
        hitPoints -= 1
    }
    func playerdeath() {
        gameHasEnded = true
        let shrink = SKAction.scale(to: 0.5, duration: 2)
        let spin = SKAction.rotate(byAngle: 180, duration: 2)
        
        player.run(spin)
        player.run(shrink)
        userDefaults.setValue(0, forKey: "Score")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let transition:SKTransition = SKTransition.fade(withDuration: 5)
            if let scene:SKScene = GameOverScene(fileNamed: "GameOverScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    func createLevel() {
        let rowType = ["road","water"]
        var lastRowPosition = player.position.y
        
        rowZero = SKSpriteNode(imageNamed: "grass")
        rowZero.position = CGPoint(x: 0, y: lastRowPosition)
        rowZero.physicsBody = SKPhysicsBody(texture: rowZero.texture!, size: CGSize(width: rowZero.size.width, height: rowZero.size.height / 2))
        rowZero.physicsBody?.isDynamic = true
        rowZero.physicsBody?.collisionBitMask = 0
        self.addChild(rowZero)
        
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
        
        //shuffled = rowType.shuffled()
        rowThree = SKSpriteNode(imageNamed: "grass")
        rowThree.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowThree.physicsBody = SKPhysicsBody(texture: rowThree.texture!, size: CGSize(width: rowThree.size.width, height: rowThree.size.height / 2))
        rowThree.physicsBody?.isDynamic = true
        rowThree.physicsBody?.collisionBitMask = 0
        //populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
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
        
        //shuffled = rowType.shuffled()
        rowSix = SKSpriteNode(imageNamed: "grass")
        rowSix.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowSix.physicsBody = SKPhysicsBody(texture: rowSix.texture!, size: CGSize(width: rowSix.size.width, height: rowSix.size.height / 2))
        rowSix.physicsBody?.isDynamic = true
        rowSix.physicsBody?.collisionBitMask = 0
        //populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowSix)
        lastRowPosition = rowSix.position.y
        
        shuffled = rowType.shuffled()
        rowSeven = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowSeven.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowSeven.physicsBody = SKPhysicsBody(texture: rowSeven.texture!, size: CGSize(width: rowSeven.size.width, height: rowSeven.size.height / 2))
        rowSeven.physicsBody?.isDynamic = true
        rowSeven.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowSeven)
        lastRowPosition = rowSeven.position.y
        
        shuffled = rowType.shuffled()
        rowEight = SKSpriteNode(imageNamed: "\(shuffled[0])")
        rowEight.position = CGPoint(x: 0, y: lastRowPosition + 128)
        rowEight.physicsBody = SKPhysicsBody(texture: rowEight.texture!, size: CGSize(width: rowEight.size.width, height: rowEight.size.height / 2))
        rowEight.physicsBody?.isDynamic = true
        rowEight.physicsBody?.collisionBitMask = 0
        populateRow(rowType: "\(shuffled[0])", rowPosition: Int(lastRowPosition))
        self.addChild(rowEight)
        lastRowPosition = rowEight.position.y
        
        lastRow = SKSpriteNode(imageNamed: "grass")
        lastRow.position = CGPoint(x: 0, y: lastRowPosition + 128)
        lastRow.physicsBody = SKPhysicsBody(texture: lastRow.texture!, size: CGSize(width: lastRow.size.width, height: lastRow.size.height / 2))
        lastRow.physicsBody?.isDynamic = true
        lastRow.physicsBody?.categoryBitMask = CollisionType.goal.rawValue
        lastRow.physicsBody?.collisionBitMask = 0
        lastRow.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        self.addChild(lastRow)
        lastRowPosition = lastRow.position.y

    }
    func populateRow (rowType: String, rowPosition: Int) {
        var currentObjects = 0
        var currentFilledCollums = 0
        var newObjectPosition = -2048
        var LaneDirection = 0
        var objectsInARow = 0
        if rowType == "road" {
            laneDirectionSpeed = 2560
        }
        if laneDirectionRandomBool == true{
            LaneDirection = laneDirectionSpeed * -1
            laneDirectionRandomBool = false
        }else{
            LaneDirection = laneDirectionSpeed
            laneDirectionRandomBool = true
        }
        if rowType == "water" {
            waterFlowobject = SKSpriteNode(imageNamed: "road")
            waterFlowobject.position = CGPoint(x: 0, y: rowPosition + 128)
            waterFlowobject.zPosition = 0
            waterFlowobject.physicsBody?.isDynamic = true
            waterFlowobject.physicsBody = SKPhysicsBody(texture: waterFlowobject.texture!, size: CGSize(width: waterFlowobject.size.width, height: waterFlowobject.size.height / 1.1))
            waterFlowobject.physicsBody?.collisionBitMask = 0
            if LaneDirection < 0 {
                waterFlowobject.physicsBody?.categoryBitMask = CollisionType.waterObjectleft.rawValue
            }else{
                waterFlowobject.physicsBody?.categoryBitMask = CollisionType.waterObjectright.rawValue
            }
            waterFlowobject.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
            self.addChild(waterFlowobject)
        }
        let action = SKAction.moveBy(x: CGFloat(LaneDirection), y: 0, duration: 60)
        
        while currentFilledCollums < 32 {
            object = SKSpriteNode(imageNamed: "object")
            object.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
            object.setScale(1.0)
            object.physicsBody = SKPhysicsBody(circleOfRadius: max(object.size.width /  8, object.size.height / 8))
            object.physicsBody?.isDynamic = true
            object.physicsBody?.collisionBitMask = 0
            
            if rowType == "road" {
                print(LaneDirection)
                if LaneDirection == 2560 {
                    object.texture = SKTexture(imageNamed: "car")
                } else if LaneDirection == -2560 {
                    object.texture = SKTexture(imageNamed: "object")
                }
                object.zPosition = 3
                object.physicsBody?.categoryBitMask = CollisionType.object.rawValue
                object.physicsBody?.collisionBitMask = 0
                object.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
                
            } else if rowType == "water" {
                object.texture = SKTexture(imageNamed: "water")
                object.alpha = 0.7
                object.zPosition = 1
                object.setScale(1.0)
                object.physicsBody = SKPhysicsBody(circleOfRadius: max(object.size.width /  10, object.size.height / 10))
                object.physicsBody?.categoryBitMask = CollisionType.object.rawValue
                object.physicsBody?.collisionBitMask = 0
                object.physicsBody?.contactTestBitMask = CollisionType.player.rawValue

            }
            waterObject = SKSpriteNode(imageNamed: "waterobject")
            waterObject.alpha = 0.7
            waterObject.zPosition = 1
            waterObject.position = CGPoint(x: newObjectPosition, y: rowPosition + 128)
            waterObject.physicsBody = SKPhysicsBody(circleOfRadius: max(object.size.width /  4, object.size.height / 4))
            waterObject.physicsBody?.collisionBitMask = 0
            waterObject.physicsBody?.isDynamic = true

            let randomBool = Bool.random()
            
            if randomBool == true && currentObjects < maxObjects && objectsInARow < 1{
                self.addChild(object)
                object.run(action)
                currentObjects += 1
                objectsInARow += 1
            } else if rowType == "water"{
                self.addChild(waterObject)
                waterObject.run(action)
                objectsInARow = 0
            } else {
                objectsInARow = 0
            }
            newObjectPosition += 128
            currentFilledCollums += 1
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
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
            //print("player tocuhed an object")
            takeDamage()
        }
        else if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.goal.rawValue {
            //print("player has reached the goal")
            gameHasEnded = true
            if difficulty == "Easy" {
                let endtime:Double = timer
                score = 1000 / Int(endtime) * hitPoints
            }
            if difficulty == "Medium" {
                let endtime:Double = timer
                score = 800 / Int(endtime) * hitPoints * 2
            }
            if difficulty == "Hard" {
                let endtime:Double = timer
                score = 800 / Int(endtime) * hitPoints * 5
            }
            userDefaults.setValue(score, forKey: "Score")
            //print (score)
            
            let rotateleft = SKAction.rotate(byAngle: -0.75, duration: 0.25)
            let wait = SKAction.wait(forDuration: 0.5)
            let rotateright = SKAction.rotate(byAngle: 1.5, duration: 0.25)
            let facestraight = SKAction.rotate(byAngle: -0.75, duration: 0.25)
            let turnaround = SKAction.rotate(byAngle: .pi * 2, duration: 0.25)
            let winAnimation = SKAction.sequence([rotateleft,wait,rotateright,wait,facestraight,turnaround])

            player.run(winAnimation)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let transition:SKTransition = SKTransition.fade(withDuration: 5)
                if let scene:SKScene = GameOverScene(fileNamed: "GameOverScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
                }
            }
            if let highScore = userDefaults.value(forKey: "HighScore") as? Int {
                if score > highScore {
                    userDefaults.set(score, forKey: "HighScore")
                }
            }
        }
        if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.border.rawValue {
            gameHasEnded = true
            playerdeath()
            print("player has reached the border")
        }
        if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectleft.rawValue {
            //print("Entered River flowing left")
            let action = SKAction.moveBy(x: -2048, y: 0, duration: 60)
            player.run(action)

        }else if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectright.rawValue {
            //print("Entered River flowing Right")
            let action = SKAction.moveBy(x: 2048, y: 0, duration: 60)
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
            //print("outside of River")
            let action = SKAction.moveBy(x: 2048, y: 0, duration: 60)
            player.run(action)

        }else if firstBody.categoryBitMask == CollisionType.player.rawValue && secondBody.categoryBitMask == CollisionType.waterObjectright.rawValue {
            //print("outside of River")
            let action = SKAction.moveBy(x: -2048, y: 0, duration: 60)
            player.run(action)
        }
        
    }
    
}
