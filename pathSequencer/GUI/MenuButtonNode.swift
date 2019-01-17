//
//  MenuButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/17/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class MenuButtonNode: TouchableNode {
    let visibleNode: SKShapeNode!
    var labelNode: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        visibleNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        visibleNode.fillColor = .white
        labelNode = SKLabelNode()
        labelNode.position = CGPoint(x: 40, y: 0)
        labelNode.verticalAlignmentMode = .center
        super.init()
        self.addChild(visibleNode)
        self.zPosition = 10
    }
    
    override func touchUp(at pos: CGPoint) {
        SceneManager.scene!.cam.addChild(MenuNode())
    }
}
