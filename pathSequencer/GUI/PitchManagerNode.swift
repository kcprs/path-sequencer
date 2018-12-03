//
//  PitchManagerNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/3/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class PitchManagerNode: SKNode {
    private let pitchLabels: Array<SKLabelNode>!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        self.pitchLabels = Array<SKLabelNode>()
        
        super.init()
        
        let xPos =  -SceneManager.scene!.size.width / 2 + 10
        for note in PitchManager.bottomNote...PitchManager.topNote {
            let labelNode = SKLabelNode(text: MidiUtil.noteToName(midiPitch: MIDINoteNumber(note)))
            pitchLabels.append(labelNode)
            
            let yPos = (note - PitchManager.bottomNote) * PitchManager.yGap
            
            labelNode.position = CGPoint(x: xPos, y: CGFloat(yPos))
            labelNode.horizontalAlignmentMode = .left
            SceneManager.scene!.addChild(labelNode)
        }
    }
    
    func getHeight() -> CGFloat {
        return CGFloat(PitchManager.yGap * pitchLabels.count)
    }
}
