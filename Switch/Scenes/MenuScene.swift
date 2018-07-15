//
//  MenuScene.swift
//  Switch
//
//  Created by Eric Friedman on 7/12/18.
//  Copyright © 2018 EF Enterprises. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    var currentColorIndex: Int?
    
    var possibleBalls = ["menuBall", "menuBall2", "menuBall3", "menuBall4"]
    let ballCategory:UInt32 = 0x1 << 1
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 61/255, green: 66/255, blue: 71/255, alpha: 1.0)
        addLogo()
        addLabels()
        backgroundBalls()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(backgroundBalls), userInfo: nil, repeats: true)
    }
    
    func addLogo(){
        
        // Add color wheel image
        let outterLogo = SKSpriteNode(imageNamed: "colorWheel800x800")
        outterLogo.alpha = 0.8
        outterLogo.size = CGSize(width: frame.size.width/2, height: frame.size.width/2)
        outterLogo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        outterLogo.zPosition = ZPositions.outterLogo
        addChild(outterLogo)
        
        // Add "Switch" logo image
       /* let innerLogo = SKLabelNode(text: "SWITCH")
        innerLogo.fontName = "AvenirNext-Bold"
        innerLogo.fontSize = 75
        innerLogo.fontColor = UIColor.white
        innerLogo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4 - innerLogo.fontSize/2)
        innerLogo.zPosition = ZPositions.innerLogo
        addChild(innerLogo)*/
        
        let switchLogo = SKSpriteNode(imageNamed: "switchLogoLabel")
        switchLogo.size = CGSize(width: frame.size.width/1.2, height: frame.size.height/6)
        switchLogo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        switchLogo.zPosition = ZPositions.innerLogo
        addChild(switchLogo)
        //animate color wheel
        let rotate = SKAction.rotate(byAngle: .pi*2, duration: 1.5)
        let sequence = SKAction.sequence([rotate])
        outterLogo.run(SKAction.repeatForever(sequence))
        
    }
    func addLabels(){
        
        let highScoreLabelSprite = SKSpriteNode(imageNamed: "highScoreCrown")
        highScoreLabelSprite.size = CGSize(width: frame.size.width/10, height: frame.size.width/10)
        highScoreLabelSprite.position = CGPoint(x: frame.midX, y: frame.midY + 35.0)
        highScoreLabelSprite.zPosition = ZPositions.highScoreLabel
        let highScoreLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        //let highScoreLabel = SKLabelNode(text: "High Score: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 40.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 20.0)
        highScoreLabel.zPosition = ZPositions.highScoreLabel
        addChild(highScoreLabelSprite)
        addChild(highScoreLabel)
        
        let playLabel = SKLabelNode(text: "TAP TO START")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 30.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height*6)
        playLabel.zPosition = ZPositions.playLabel
        addChild(playLabel)
        animatePlayButton(label: playLabel)
        
        /* let recentScoreLabel = SKLabelNode(text: "Recent Score: " + "\(UserDefaults.standard.integer(forKey: "Recent Score"))")
         recentScoreLabel.fontName = "AvenirNext-Bold"
         recentScoreLabel.fontSize = 40.0
         recentScoreLabel.fontColor = UIColor.white
         recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
         addChild(recentScoreLabel) */
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
    
    func animatePlayButton(label: SKLabelNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
        }
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
}
