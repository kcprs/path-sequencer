//
//  MenuButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/17/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class MenuButtonNode: TouchableNode {
    let visibleNode: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        visibleNode = SKSpriteNode(imageNamed: "menu.png")
        super.init()
        self.addChild(visibleNode)
        self.zPosition = 10
    }
    
    override func touchUp(at pos: CGPoint) {
        SceneManager.scene!.showMenu()
    }
}
