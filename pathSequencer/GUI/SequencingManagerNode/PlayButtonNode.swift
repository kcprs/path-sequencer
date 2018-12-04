//
//  PlayButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/4/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PlayButtonNode: TouchableNode {
    let visibleNode: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        visibleNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        super.init()
        self.addChild(visibleNode)
        update()
    }
    
    private func update() {
        if SequencingManager.isPlaying {
            visibleNode.fillColor = .red
        } else {
            visibleNode.fillColor = .green
        }
    }
    
    override func touchUp(at pos: CGPoint) {
        if SequencingManager.isPlaying {
            SequencingManager.stopPlayback()
        } else {
            SequencingManager.startPlayback()
        }
        
        update()
    }
}
