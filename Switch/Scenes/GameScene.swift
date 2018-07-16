//
//  GameScene.swift
//  Switch
//
//  Created by Eric Friedman on 7/11/18.
//  Copyright © 2018 EF Enterprises. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}
enum SwitchState: Int {
    case red, yellow, green, blue
}


class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
        //self.view?.showsPhysics = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if score == 10 {
            physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
            let speedUp = SKLabelNode(text: "SPEED UP!")
            speedUp.fontName = "AvenirNext-Bold"
            speedUp.fontColor = UIColor.white
            speedUp.fontSize = 60.0
            speedUp.position = CGPoint(x: frame.midX, y: frame.midY + 150.0)
            speedUp.zPosition = ZPositions.label
            speedUp.run(SKAction.fadeIn(withDuration: 0.5))
            addChild(speedUp)
            speedUp.run(SKAction.fadeOut(withDuration: 0.5))
        }
        if score == 20 {
            let switchLabel = SKLabelNode(text: "SWITCH!")
            switchLabel.fontName = "AvenirNext-Bold"
            switchLabel.fontColor = UIColor.white
            switchLabel.fontSize = 60.0
            switchLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150.0)
            switchLabel.zPosition = ZPositions.label
            switchLabel.run(SKAction.fadeIn(withDuration: 0.5))
            addChild(switchLabel)
            switchLabel.run(SKAction.fadeOut(withDuration: 0.5))
            let levelTwo = LevelTwo(size: self.view!.bounds.size)
            self.view!.presentScene(levelTwo)
        }
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 61/255, green: 66/255, blue: 71/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
        
      
    }
    
    func updateScoreLabel(){
        scoreLabel.text = "\(score)"
    }
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 20.0, height: 20.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
    func turnWheelRight() {
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        } else {
            switchState = .red
        }
    }
    func turnWheelLeft() {
        colorSwitch.run(SKAction.rotate(byAngle: -.pi/2, duration: 0.25))
        if switchState.rawValue == 0 {
            let newState = SwitchState(rawValue: switchState.rawValue + 3)
            switchState = newState!
        } else {
            let newState = SwitchState(rawValue: switchState.rawValue - 1)
            switchState = newState!
        }
    }
    
    
    func gameOver(){
        UserDefaults.standard.set(score, forKey: "Recent Score")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
    }
    
    //Collision when ball matches correct color
    func collision(ball:SKSpriteNode){
        let collision = SKEmitterNode(fileNamed: "CorrectColor")!
        collision.position = ball.position
        self.addChild(collision)
        self.run(SKAction.wait(forDuration: 2)) {
            collision.removeFromParent()
        }
    }
    
    //Explosion when ball hits wrong color
    func explosion(ball:SKSpriteNode){
        //Red
        let explosion = SKEmitterNode(fileNamed: "ExplosionRed")!
        explosion.position = ball.position
        self.addChild(explosion)
        //Blue
        let explosion2 = SKEmitterNode(fileNamed: "ExplosionBlue")!
        explosion2.position = ball.position
        self.addChild(explosion2)
        //Yellow
        let explosion3 = SKEmitterNode(fileNamed: "ExplosionYellow")!
        explosion3.position = ball.position
        self.addChild(explosion3)
        //Green
        let explosion4 = SKEmitterNode(fileNamed: "ExplosionGreen")!
        explosion4.position = ball.position
        self.addChild(explosion4)
        
        ball.removeFromParent()
        self.run(SKAction.wait(forDuration: 1)){
            let postGameScene = PostGameScene(size: self.view!.bounds.size)
            self.view!.presentScene(postGameScene)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        var rightSide: Bool = false
        var leftSide: Bool = false
        if (location.x > 180) {
            rightSide = true
            turnWheelRight()
            print("rightSide touched")
        } else if (location.x < 180){
            leftSide = true
            turnWheelLeft()
            print("leftSide touched")
            }
        }
    }

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ?
                contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as?
                SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    score += 1
                    updateScoreLabel()
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    ball.removeFromParent()
                    self.spawnBall()
                } else {
                    gameOver()
                    explosion(ball: ball)
                    let generator2 = UIImpactFeedbackGenerator(style: .heavy)
                    generator2.impactOccurred()
                }
            }
        }
        
    }
}
