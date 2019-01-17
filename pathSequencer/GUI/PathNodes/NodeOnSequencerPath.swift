//
//  NodeOnSequencerPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

// Provides shared functionality for all nodes
// that reside on a SequencerPath
class NodeOnSequencerPath: TouchableNode {
    unowned let parentPath: SequencerPath
    
    var visibleNode: SKShapeNode!
    
    init(parentPath: SequencerPath) {
        self.parentPath = parentPath
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelection() {
        if parentPath.track.isSelected && !children.contains(visibleNode) {
            self.addChild(visibleNode)
            self.run(SKAction.fadeIn(withDuration: 0.4))
        } else if children.contains(visibleNode) {
            self.run(SKAction.fadeOut(withDuration: 0.4), completion: visibleNode.removeFromParent)
        }
    }
}
