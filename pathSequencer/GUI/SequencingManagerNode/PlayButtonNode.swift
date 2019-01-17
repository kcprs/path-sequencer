//
//  PlayButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/4/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PlayButtonNode: TouchableNode {
    var visibleNode: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        visibleNode = SKSpriteNode(imageNamed: "play.png")
        super.init()
        self.addChild(visibleNode)
        update()
    }
    
    private func update() {
        if SequencingManager.isPlaying {
            visibleNode.removeFromParent()
            visibleNode = SKSpriteNode(imageNamed: "stop.png")
            self.addChild(visibleNode)
        } else {
            visibleNode.removeFromParent()
            visibleNode = SKSpriteNode(imageNamed: "play.png")
            self.addChild(visibleNode)
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
