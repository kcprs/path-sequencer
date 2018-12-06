//
//  ModAssignModeButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/6/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class ModAssignModeButtonNode: TouchableNode {
    private let visibleNode: SKShapeNode!
    unowned private let controlPanel: SoundModuleControlsPanelNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for controlPanel: SoundModuleControlsPanelNode) {
        visibleNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        self.controlPanel = controlPanel
        
        super.init()
        
        self.addChild(visibleNode)
    }
    
    override func touchUp(at pos: CGPoint) {
        controlPanel.setModAssignMode(isActive: !controlPanel.isInModAssignMode)
    }
}
