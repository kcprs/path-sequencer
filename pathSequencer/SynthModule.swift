//
//  SynthModule.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/14/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class SynthModule {
    
    private var oscBank : AKMorphingOscillatorBank!
    private var filter : AKLowPassFilter!
    private var waveforms : Array<AKTable>!
    private var notesPlaying : Array<MIDINoteNumber>!
    private var lastPlayedNote : MIDINoteNumber = 0
    private var quantisePitch = true
    
    init() {
        notesPlaying = Array<MIDINoteNumber>()
        waveforms = Array<AKTable>()
        let saw = AKTable(.sawtooth)
        waveforms.append(saw)
        let square = AKTable(.square)
        waveforms.append(square)
        oscBank = AKMorphingOscillatorBank()//waveformArray: waveforms)
        oscBank.rampDuration = 0
        oscBank.index = 1
        filter = AKLowPassFilter()
        filter.cutoffFrequency = 20000
        
        oscBank.connect(to: filter)
    }
    
    func start() {
        filter.start()
    }
    
    func connect(to inputNode: AKInput) {
        filter.connect(to: inputNode)
    }
    
    func trigger(freq: Double) {
        var processedFreq : Double!
        if quantisePitch {
            processedFreq = MidiUtil.freqToClosestNoteFreq(freq)
        } else {
            processedFreq = freq
        }
        
        
        // Disregard MIDI pitch, only use frequency
        oscBank.play(noteNumber: lastPlayedNote, velocity: 127, frequency: processedFreq)
        
        let savedNote = lastPlayedNote  // Avoid using lastPlayedNote after increment
        DispatchQueue.main.asyncAfter(deadline: .now() + oscBank.attackDuration, execute: {self.oscBank.stop(noteNumber: savedNote)})
        
        // Keep using different MIDI note numbers to avoid notes cutting each other off
        lastPlayedNote += 1  // Should wrap 127 -> 0 since MIDINoteNumber is UInt8
    }
}
