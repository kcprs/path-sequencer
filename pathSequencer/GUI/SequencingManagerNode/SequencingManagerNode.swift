//
//  SequencingManagerNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/3/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SequencingManagerNode: TouchableNode {
    // Graphics
    private let playButton: PlayButtonNode!
    private let tempoSelectorNode: ScrollSelectorNode<Double>!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        playButton = PlayButtonNode()
        tempoSelectorNode = ScrollSelectorNode<Double>(parameter: SequencingManager.tempo)
        super.init()
        self.addChild(playButton)
        tempoSelectorNode.position = CGPoint(x: -100, y: -10)
        self.addChild(tempoSelectorNode)
        self.zPosition = 10
    }
}
