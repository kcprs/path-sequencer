//
//  NodeOnSequencerPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class NodeOnSequencerPath: SKNode {
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
    
    func touchDown(atPoint pos: CGPoint) {}
    
    func touchMoved(toPoint pos: CGPoint) {}
    
    func touchUp(atPoint pos: CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
}
