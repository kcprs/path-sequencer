//
//  PitchGrid.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/13/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PitchGrid {
    private let parent : SKScene!
    private var pitchLabels : Array<SKLabelNode>!
    private var topNote = 108  // MIDI pitch
    private var bottomNote = 21  // MIDI pitch
    private var yGap : Int = 40
    
    init(parent: SKScene) {
        self.parent = parent
        
        setUpPitchLabels()
    }
    
    private func setUpPitchLabels() {
        pitchLabels = Array<SKLabelNode>()
        
        let xPos =  -parent.size.width / 2 + 10
        
        for note in bottomNote...topNote {
            let labelNode = SKLabelNode(text: MidiUtil.noteToName(midiPitch: note))
            pitchLabels.append(labelNode)
            
            let yPos = (note - bottomNote) * yGap
            
            labelNode.position = CGPoint(x: xPos, y: CGFloat(yPos))
            labelNode.horizontalAlignmentMode = .left
            parent.addChild(labelNode)
        }
    }
    
    func getCentreY() -> Int {
        return yGap * (topNote - bottomNote) / 2
    }
    
    func getFreqAt(yPos: CGFloat) -> Double {
        let proportion = Float(yPos)/Float(yGap * (topNote - bottomNote))
        let note = proportion * Float(topNote - bottomNote) + Float(bottomNote)
        return MidiUtil.noteToFreq(midiPitch: note)
    }
    
    
}
