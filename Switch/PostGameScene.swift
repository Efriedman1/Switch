//
//  PostGameScene.swift
//  Switch
//
//  Created by Eric Friedman on 7/12/18.
//  Copyright © 2018 EF Enterprises. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PostGameScene: SKScene {

    var playButton: SKSpriteNode! = nil
    var menuButton: SKSpriteNode! = nil
    
    var possibleBalls = ["menuBall", "menuBall2", "menuBall3", "menuBall4"]
    let ballCategory:UInt32 = 0x1 << 1
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 61/255, green: 66/255, blue: 71/255, alpha: 1.0)
        addLabels()
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(backgroundBalls), userInfo: nil, repeats: true)
        
        //add play button
        playButton = SKSpriteNode(imageNamed: "playAgainButton")
        playButton.size = CGSize(width: frame.size.width/1.5, height: frame.size.height/10)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - 150)
        self.addChild(playButton)
        
        //add menu button
        menuButton = SKSpriteNode(imageNamed: "menuButton")
        menuButton.size = CGSize(width: frame.size.width/1.5, height: frame.size.height/10)
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY - 250)
        self.addChild(menuButton)
    }
    @objc func backgroundBalls(){
        
        possibleBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleBalls) as! [String]
        let backgroundBall = SKSpriteNode(imageNamed: possibleBalls[0])
        backgroundBall.removeFromParent()
        backgroundBall.alpha = 0.8
        let randomBallPosition = GKRandomDistribution(lowestValue: 0, highestValue: 350)
        let position = CGFloat(randomBallPosition.nextInt())
        backgroundBall.position = CGPoint(x: position, y: self.frame.size.height + backgroundBall.size.height)
        backgroundBall.zPosition = ZPositions.backgroundBall
        backgroundBall.size = CGSize(width: frame.size.width/12, height: frame.size.width/12)
        backgroundBall.physicsBody = SKPhysicsBody(rectangleOf: backgroundBall.size)
        backgroundBall.physicsBody?.isDynamic = true
        backgroundBall.physicsBody?.categoryBitMask = ballCategory
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        
        self.addChild(backgroundBall)
    }
    func addLabels(){
        
        //Game over label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.fontSize = 60.0
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 200.0)
        addChild(gameOverLabel)
        
        //recent score label
        let recentScoreLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: "Recent Score"))")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 60.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(recentScoreLabel)
        
        //left star
        let leftStar = SKSpriteNode(imageNamed: "star")
        leftStar.size = CGSize(width: frame.size.width/6, height: frame.size.width/6)
        leftStar.position = CGPoint(x: frame.midX - 100.0, y: frame.midY + 25.0)
        addChild(leftStar)
        
        //right star
        let rightStar = SKSpriteNode(imageNamed: "star")
        rightStar.size = CGSize(width: frame.size.width/6, height: frame.size.width/6)
        rightStar.position = CGPoint(x: frame.midX + 100.0, y: frame.midY + 25.0)
        addChild(rightStar)
        
        //animate stars
        let rotate = SKAction.rotate(byAngle: .pi*2, duration: 1.5)
        let sequence = SKAction.sequence([rotate])
        leftStar.run(SKAction.repeatForever(sequence))
        rightStar.run(SKAction.repeatForever(sequence))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if playButton.contains(location) {
                let gameScene = GameScene(size:view!.bounds.size)
                view!.presentScene(gameScene)
            } else if menuButton.contains(location) {
                let menuScene = MenuScene(size: view!.bounds.size)
                view!.presentScene(menuScene)
            }
        }
    }
    
}
