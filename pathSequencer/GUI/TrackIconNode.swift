//
//  TrackIconNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class TrackIconNode: SKNode {
    private var track: Track!
    private var controlPanel: SoundControlPanelNode?
    private var label: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        super.init()
        
        self.track = track
        self.isUserInteractionEnabled = true
        
        label = SKLabelNode(text: "TrackIcon")
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .left
        self.addChild(label)
    }
    
    func getWidth() -> CGFloat {
        return label.frame.width
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        
    }
    
    private func touchMoved(toPoint pos: CGPoint) {

    }
    
    private func touchUp(atPoint pos: CGPoint) {
        if controlPanel == nil {
            controlPanel = SoundControlPanelNode(for: track.soundModule)
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
