//
//  Settings.swift
//  Switch
//
//  Created by Eric Friedman on 7/12/18.
//  Copyright © 2018 EF Enterprises. All rights reserved.
//

import SpriteKit

enum PhysicsCategories {
    
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1           // 1
    static let switchCategory: UInt32 = 0x1 << 1    //10
}

enum ZPositions {
    
    //GameScene
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
    
    //MenuScene
    static let outterLogo: CGFloat = 0
    static let backgroundBall: CGFloat = 1
    static let playLabel: CGFloat = 2
    static let highScoreLabel: CGFloat = 3
    static let innerLogo:  CGFloat = 4
    
}



