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
    private static var staticSelf: PitchGrid? = nil
    private var pitchLabels: Array<SKLabelNode>!
    private var topNote = 108  // MIDI pitch
    private var bottomNote = 21  // MIDI pitch
    private let yGap: Int = 40
    
    init() {
        if PitchGrid.staticSelf != nil {
            fatalError("There can only be one PitchGrid")
        }
        
        pitchLabels = Array<SKLabelNode>()
        
        let xPos =  -SceneManager.scene!.size.width / 2 + 10
        
        for note in bottomNote...topNote {
            let labelNode = SKLabelNode(text: MidiUtil.noteToName(midiPitch: MIDINoteNumber(note)))
            pitchLabels.append(labelNode)
            
            let yPos = (note - bottomNote) * yGap
            
            labelNode.position = CGPoint(x: xPos, y: CGFloat(yPos))
            labelNode.horizontalAlignmentMode = .left
            SceneManager.scene!.addChild(labelNode)
        }
    }
    
    func getCentreY() -> CGFloat {
        return CGFloat(yGap * (topNote - bottomNote) / 2)
    }
    
    func getHeight() -> CGFloat {
        return CGFloat(yGap * pitchLabels.count)
    }
    
    func getFreqAt(node: SKNode) -> Double {
        let position = SceneManager.scene!.convert(node.position, from: node.parent!)
        let proportion = Float(position.y)/Float(yGap * (topNote - bottomNote))
        let note = proportion * Float(topNote - bottomNote) + Float(bottomNote)
        return MidiUtil.noteToFreq(midiPitch: note)
    }
}
