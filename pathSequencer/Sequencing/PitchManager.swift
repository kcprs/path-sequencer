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
    private static var pitchLabels: Array<SKLabelNode>!
    private static var topNote = 108  // MIDI pitch
    private static var bottomNote = 21  // MIDI pitch
    private static let yGap: Int = 40
    
    init() {
        if PitchManager.staticSelf != nil {
            fatalError("There can only be one PitchManager")
        }
        PitchManager.staticSelf = self
        
        // TODO: Move to a GUI class
        PitchManager.pitchLabels = Array<SKLabelNode>()
        
        let xPos =  -SceneManager.scene!.size.width / 2 + 10
        
        for note in PitchManager.bottomNote...PitchManager.topNote {
            let labelNode = SKLabelNode(text: MidiUtil.noteToName(midiPitch: MIDINoteNumber(note)))
            PitchManager.pitchLabels.append(labelNode)
            
            let yPos = (note - PitchManager.bottomNote) * PitchManager.yGap
            
            labelNode.position = CGPoint(x: xPos, y: CGFloat(yPos))
            labelNode.horizontalAlignmentMode = .left
            SceneManager.scene!.addChild(labelNode)
        }
    }
    
    static func getCentreY() -> CGFloat {
        return CGFloat(yGap * (topNote - bottomNote) / 2)
    }
    
    static func getHeight() -> CGFloat {
        return CGFloat(yGap * pitchLabels.count)
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
}
