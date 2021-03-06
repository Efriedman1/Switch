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
        playButton.size = CGSize(width: frame.size.width/2.2, height: frame.size.height/10)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        playButton.zPosition = ZPositions.playLabel
        playButton.alpha = 1.0
        self.addChild(playButton)
        
        //add menu button
        menuButton = SKSpriteNode(imageNamed: "menuButton")
        menuButton.size = CGSize(width: frame.size.width/2.2, height: frame.size.height/10)
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY - 275)
        menuButton.zPosition = ZPositions.outterLogo
        menuButton.alpha = 0.8
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
        
        //Switch Logo
        // Add "Color Switch" logo image
        let innerLogo = SKSpriteNode(imageNamed: "switchLogoLabel")
        //innerLogo.size = CGSize(width: frame.size.width/1.8, height: frame.size.height/8)
        innerLogo.size = CGSize(width: frame.size.width/1.2, height: frame.size.height/6)
        innerLogo.position = CGPoint(x: frame.midX, y: frame.midY + 225)
        innerLogo.zPosition = ZPositions.innerLogo
        addChild(innerLogo)
        
        // Add color wheel image
        let outterLogo = SKSpriteNode(imageNamed: "colorWheel800x800")
        outterLogo.alpha = 0.8
        //outterLogo.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        outterLogo.size = CGSize(width: frame.size.width/2, height: frame.size.width/2)
        outterLogo.position = CGPoint(x: frame.midX, y: frame.midY + 225)
        outterLogo.zPosition = ZPositions.outterLogo
        addChild(outterLogo)
        
        //animate color wheel
        let rotate = SKAction.rotate(byAngle: .pi*2, duration: 1.5)
        let sequence = SKAction.sequence([rotate])
        outterLogo.run(SKAction.repeatForever(sequence))
        
        //Game over label
        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.fontSize = 40
        gameOverLabel.alpha = 0.8
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 80.0)
        gameOverLabel.zPosition = ZPositions.playLabel
        addChild(gameOverLabel)
        
        let highScoreLabel = SKLabelNode(text: "High Score: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 30.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 20.0)
        highScoreLabel.zPosition = ZPositions.highScoreLabel
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: " + "\(UserDefaults.standard.integer(forKey: "Recent Score"))")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 30.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height*2 - 10.0)
        recentScoreLabel.zPosition = ZPositions.highScoreLabel
        addChild(recentScoreLabel)
        
       /* //left star
        let leftStar = SKSpriteNode(imageNamed: "star")
        leftStar.size = CGSize(width: frame.size.width/8, height: frame.size.width/8)
        leftStar.position = CGPoint(x: frame.midX - 100.0, y: frame.midY - 28.0 )
        leftStar.zPosition = ZPositions.playLabel
       // addChild(leftStar)
        
        //right star
        let rightStar = SKSpriteNode(imageNamed: "star")
        rightStar.size = CGSize(width: frame.size.width/8, height: frame.size.width/8)
        rightStar.position = CGPoint(x: frame.midX + 100.0, y: frame.midY - 28.0)
        rightStar.zPosition = ZPositions.playLabel
       // addChild(rightStar)
        
        //animate stars
        let rotate2 = SKAction.rotate(byAngle: .pi*2, duration: 1.5)
        let sequence2 = SKAction.sequence([rotate2])
        leftStar.run(SKAction.repeatForever(sequence2))
        rightStar.run(SKAction.repeatForever(sequence2))
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
        //let fadeSeq = SKAction.sequence([fadeOut, fadeIn]) */
        
        
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
