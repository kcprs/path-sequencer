//
//  MidiUtil.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/13/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

class MidiUtil {
    static func noteToFreq(midiPitch: Int) -> Double {
        return noteToFreq(midiPitch: Float(midiPitch))
    }
    
    static func noteToFreq(midiPitch: Float) -> Double {
        // Have to calculate with respect to A0 and not A4
        // because pow(a, b) in swift doesn't support negative exponents
        return Double((pow(2, (midiPitch - 21)/12) * 27.5).description)!
    }
    
    static func noteToName(midiPitch: Int) -> String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        
        var name = names[midiPitch % 12]
        let octave = Int(midiPitch/12) - 1
        name.append(String(octave))
        
        return name
    }
}
