//
//  SynthModule.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/14/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class SynthModule {
    
    private var oscBank: AKMorphingOscillatorBank!
    private var filter: AKLowPassFilter!
    private var waveforms: Array<AKTable>!
    private var notesPlaying: Array<MIDINoteNumber>!
    private var lastPlayedNote: MIDINoteNumber = 0
    private var quantisePitch = true
    private var holdTime = 0.5 // TODO: Write a separate class for an AHD envelope
    
    init() {
        notesPlaying = Array<MIDINoteNumber>()
        waveforms = Array<AKTable>()
        print(waveforms)
        waveforms.append(AKTable(.sine))
        waveforms.append(AKTable(.triangle))
        waveforms.append(AKTable(.sawtooth))
        waveforms.append(AKTable(.square))
        
        oscBank = AKMorphingOscillatorBank(waveformArray: waveforms)
        oscBank.rampDuration = 0
        oscBank.index = 1
        filter = AKLowPassFilter()
        filter.cutoffFrequency = 20000
        
        oscBank.connect(to: filter)
        
        // TODO: Make initial displayed values match the synth parameters
    }
    
    func start() {
        filter.start()
    }
    
    func connect(to inputNode: AKInput) {
        filter.connect(to: inputNode)
    }
    
    func trigger(freq: Double) {
        var processedFreq: Double!
        if quantisePitch {
            processedFreq = MidiUtil.freqToClosestNoteFreq(freq)
        } else {
            processedFreq = freq
        }
        
        
        // Disregard MIDI pitch, only use frequency
        oscBank.play(noteNumber: lastPlayedNote, velocity: 127, frequency: processedFreq)
        
        let savedNote = lastPlayedNote  // Avoid using lastPlayedNote after increment
        DispatchQueue.main.asyncAfter(deadline: .now() + oscBank.attackDuration + holdTime, execute: {self.oscBank.stop(noteNumber: savedNote)})
        
        // Keep using different MIDI note numbers to avoid notes cutting each other off
        lastPlayedNote += 1  // Should wrap 127 -> 0 since MIDINoteNumber is UInt8
    }
    
    func setWavetableIndex(_ index: Double) {
        oscBank.index = index * (waveforms.count - 1)
    }
    
    func setAttack(_ attack: Double) {
        oscBank.attackDuration = attack
    }
    
    func setHold(_ hold: Double) {
        self.holdTime = hold
    }
    
    func setRelease(_ release: Double) {
        oscBank.releaseDuration = release
    }
}
