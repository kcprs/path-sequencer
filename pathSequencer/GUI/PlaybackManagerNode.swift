//
//  SequencingManagerNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/3/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SequencingManagerNode: TouchableNode {
    private var playButton: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        playButton = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        self.addChild(playButton)
        updatePlayButton()
    }
    
    override func touchUp(at pos: CGPoint) {
        if SequencingManager.isPlaying {
            SequencingManager.stopPlayback()
        } else {
            SequencingManager.startPlayback()
        }
        updatePlayButton()
    }
    
    private func updatePlayButton() {
        if SequencingManager.isPlaying {
            playButton.fillColor = .red
        } else {
            playButton.fillColor = .green
        }
    }
}
