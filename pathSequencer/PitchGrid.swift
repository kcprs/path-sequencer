//
//  PitchGrid.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/13/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class PitchGrid {
    private let parentScene : SKScene!
    private var pitchLabels : Array<SKLabelNode>!
    private var topNote = 108  // MIDI pitch
    private var bottomNote = 21  // MIDI pitch
    private var yGap : Int = 40
    
    init(inScene parent: SKScene) {
        self.parentScene = parent
        
        setUpPitchLabels()
    }
    
    private func setUpPitchLabels() {
        pitchLabels = Array<SKLabelNode>()
        
        let xPos =  -parentScene.size.width / 2 + 10
        
        for note in bottomNote...topNote {
            let labelNode = SKLabelNode(text: MidiUtil.noteToName(midiPitch: MIDINoteNumber(note)))
            pitchLabels.append(labelNode)
            
            let yPos = (note - bottomNote) * yGap
            
            labelNode.position = CGPoint(x: xPos, y: CGFloat(yPos))
            labelNode.horizontalAlignmentMode = .left
            parentScene.addChild(labelNode)
        }
    }
    
    func getCentreY() -> Int {
        return yGap * (topNote - bottomNote) / 2
    }
    
    func getFreqAt(node: SKNode) -> Double {
        let position = parentScene.convert(node.position, from: node.parent!)
        let proportion = Float(position.y)/Float(yGap * (topNote - bottomNote))
        let note = proportion * Float(topNote - bottomNote) + Float(bottomNote)
        return MidiUtil.noteToFreq(midiPitch: note)
    }
    
    
}
