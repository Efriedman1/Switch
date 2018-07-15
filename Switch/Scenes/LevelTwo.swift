//
//  LevelTwo.swift
//  Switch
//
//  Created by Eric Friedman on 7/12/18.
//  Copyright © 2018 EF Enterprises. All rights reserved.
//

import UIKit
import SpriteKit

enum PlayColors2 {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
        UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        
        ]
}
enum SwitchState2: Int {
    case red, yellow, green, blue, purple
}

class LevelTwo: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState2 = SwitchState2.red
    var currentColorIndex2: Int?
    
    let scoreLabel = SKLabelNode(text: "10")
    var score = 20
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if score == 30 {
            physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
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
        if score == 40 {
            let switchLabel = SKLabelNode(text: "SWITCH!")
            switchLabel.fontName = "AvenirNext-Bold"
            switchLabel.fontColor = UIColor.white
            switchLabel.fontSize = 60.0
            switchLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150.0)
            switchLabel.zPosition = ZPositions.label
            switchLabel.run(SKAction.fadeIn(withDuration: 0.5))
            addChild(switchLabel)
            switchLabel.run(SKAction.fadeOut(withDuration: 0.5))
            let levelThree = LevelThree(size: self.view!.bounds.size)
            self.view!.presentScene(levelThree)
        }
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 61/255, green: 66/255, blue: 71/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircleLevel2")
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
        currentColorIndex2 = Int(arc4random_uniform(UInt32(5)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors2.colors[currentColorIndex2!], size: CGSize(width: 20.0, height: 20.0))
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
    
    func turnWheel() {
        colorSwitch.run(SKAction.rotate(byAngle: 1.25664, duration: 0.25))
        if let newState = SwitchState2(rawValue: switchState2.rawValue + 1){
            switchState2 = newState
        } else {
            switchState2 = .red
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
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = ball.position
        self.addChild(explosion)
        ball.removeFromParent()
        self.run(SKAction.wait(forDuration: 1)){
            let postGameScene = PostGameScene(size: self.view!.bounds.size)
            self.view!.presentScene(postGameScene)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
}
extension LevelTwo: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ?
                contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as?
                SKSpriteNode {
                if currentColorIndex2 == switchState2.rawValue {
                    score += 1
                    updateScoreLabel()
                    ball.removeFromParent()
                    collision(ball: ball)
                    self.spawnBall()
                    //ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                    //  })
                } else {
                    gameOver()
                    explosion(ball: ball)
                }
            }
        }
        
    }
}
