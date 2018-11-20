//
//  PathIconNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PathIconNode: SKNode {
    private var path: CursorPath!
    private var controlPanel : SynthControlPanelNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(path: CursorPath) {
        super.init()
        
        self.path = path
        self.isUserInteractionEnabled = true
        
        self.addChild(SKLabelNode(text: "PathIcon"))
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        
    }
    
    private func touchMoved(toPoint pos: CGPoint) {

    }
    
    private func touchUp(atPoint pos: CGPoint) {
        if controlPanel == nil {
            controlPanel = SynthControlPanelNode(parentScene: self.scene!, synthModule: path.getSynthModule())
        } else {
            controlPanel!.close()
            controlPanel = nil
        }
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
