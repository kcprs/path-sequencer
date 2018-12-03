//
//  PitchManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/13/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class PitchManager {
    private static var staticSelf: PitchManager? = nil
    static var pitchManagerNode: PitchManagerNode!
    
    static var topNote = 108  // MIDI pitch
    static var bottomNote = 21  // MIDI pitch
    static let yGap: Int = 40
    
    init() {
        if PitchManager.staticSelf != nil {
            fatalError("There can only be one PitchManager")
        }
        PitchManager.staticSelf = self
    }
    
    static func getUnquantisedMIDINoteAt(node: SKNode) -> Double {
        let position = SceneManager.scene!.convert(node.position, from: node.parent!)
        let proportion = Double(position.y)/Float(yGap * (topNote - bottomNote))
        let note = proportion * Double(topNote - bottomNote) + Float(bottomNote)
        return note
    }
    
    static func getMIDINoteAt(node: SKNode) -> MIDINoteNumber {
        let note = getUnquantisedMIDINoteAt(node: node)
        return MIDINoteNumber(note)
    }
    
    static func getFreqAt(node: SKNode) -> Double {
        let note = getUnquantisedMIDINoteAt(node: node)
        return MidiUtil.noteToFreq(midiPitch: note)
    }
    
    static func getModAt(node: SKNode) -> Double {
        let position = SceneManager.scene!.convert(node.position, from: node.parent!)
        let width = Double(SceneManager.scene!.size.width)
        
        return (Double(position.x) + 0.5 * width) / width
    }
    
    static func getCentreY() -> CGFloat {
        return CGFloat(yGap * (topNote - bottomNote) / 2)
    }
}
