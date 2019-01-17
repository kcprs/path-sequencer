//
//  ModAssignModeButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/6/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class ModAssignModeButtonNode: TouchableNode {
    private let rect: SKShapeNode!
    private let label: SKLabelNode!
    unowned private let controlPanel: SoundModuleControlsPanelNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for controlPanel: SoundModuleControlsPanelNode) {
        rect = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        rect.fillColor = .clear
        self.controlPanel = controlPanel
        label = SKLabelNode(text: "mod")
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontSize = 25
        
        super.init()
        
        self.addChild(rect)
        self.addChild(label)
    }
    
    override func touchUp(at pos: CGPoint) {
        controlPanel.setModAssignMode(isActive: !controlPanel.isInModAssignMode)
        
        if controlPanel.isInModAssignMode {
            rect.fillColor = .orange
        } else {
            rect.fillColor = .clear
        }
    }
}
