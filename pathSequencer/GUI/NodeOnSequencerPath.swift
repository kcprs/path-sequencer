//
//  NodeOnSequencerPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class NodeOnSequencerPath: TouchableNode {
    var visibleNode: SKShapeNode!
    var parentPath: SequencerPath!
    
    func updateSelection() {
        if parentPath.track.isSelected && !children.contains(visibleNode) {
            self.addChild(visibleNode)
            self.run(SKAction.fadeIn(withDuration: 0.4))
        } else if children.contains(visibleNode) {
            self.run(SKAction.fadeOut(withDuration: 0.4), completion: visibleNode.removeFromParent)
        }
    }
}
