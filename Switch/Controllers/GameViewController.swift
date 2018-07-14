//
//  GameViewController.swift
//  Switch
//
//  Created by Eric Friedman on 7/11/18.
//  Copyright © 2018 EF Enterprises. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            
            let scene = MenuScene(size: view.bounds.size)
            
            // set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
}
