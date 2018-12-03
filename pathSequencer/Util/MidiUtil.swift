//
//  MidiUtil.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/13/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class MidiUtil {
    static func noteToFreq(midiPitch: MIDINoteNumber) -> Double {
        return noteToFreq(midiPitch: Double(midiPitch))
    }
    
    static func noteToFreq(midiPitch: Double) -> Double {
        // Have to calculate with respect to A0 and not A4
        // because pow(a, b) in Swift doesn't support negative exponents
        return Double((pow(2, (midiPitch - 21)/12) * 27.5).description)!
    }
    
    static func freqToNote(_ freq: Double) -> Double {
        return 69 + 12 * log2(freq/440)
    }
    
    static func freqToClosestNoteFreq(_ freq: Double) -> Double {
        return noteToFreq(midiPitch: MIDINoteNumber(freqToNote(freq)))
    }
    
    static func noteToName(midiPitch: MIDINoteNumber) -> String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        
        var name = names[Int(midiPitch) % 12]
        let octave = Int(midiPitch/12) - 1
        name.append(String(octave))
        
        return name
    }
}
