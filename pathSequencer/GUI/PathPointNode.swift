//
//  PathPointNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/15/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PathPointNode: SKNode {
    
    private var visibleNode: SKShapeNode!
    private var parentPath: SequencerPath!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        visibleNode = SKShapeNode(circleOfRadius: 30)
        self.addChild(visibleNode)
        
        self.isUserInteractionEnabled = true
    }
    
    func setParentPath(_ parentPath: SequencerPath) {
        self.parentPath = parentPath
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        parentPath.saveProgress(node: self)
    }
    
    private func touchMoved(toPoint pos: CGPoint) {
        self.position = pos
        parentPath.update(node: self)
    }
    
    private func touchUp(atPoint pos: CGPoint) {
        parentPath.resumeMovement()
    }
    
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
