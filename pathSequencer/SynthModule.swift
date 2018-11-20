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
    private var holdTime = 0.5
    
    // GUI - controlled parameters
    var attack: GUIContinuousParameter!
    var hold: GUIContinuousParameter!
    var decay: GUIContinuousParameter!
    var wavetableIndex: GUIContinuousParameter!
    
    
    init() {
        notesPlaying = Array<MIDINoteNumber>()
        waveforms = Array<AKTable>()
        waveforms.append(AKTable(.sine))
        waveforms.append(AKTable(.triangle))
        waveforms.append(AKTable(.sawtooth))
        waveforms.append(AKTable(.square))
        
        oscBank = AKMorphingOscillatorBank(waveformArray: waveforms)
        oscBank.rampDuration = 0
        oscBank.sustainLevel = 1
        filter = AKLowPassFilter()
        filter.cutoffFrequency = 20000
        
        oscBank.connect(to: filter)
        
        attack = GUIContinuousParameter(minValue: 0.001, maxValue: 1,
                                        setClosure: {(newValue: Double) in self.oscBank.attackDuration = newValue},
                                        getClosure: {() -> Double in return self.oscBank.attackDuration})
        hold = GUIContinuousParameter(minValue: 0.001, maxValue: 1,
                                      setClosure: {(newValue: Double) in self.holdTime = newValue},
                                      getClosure: {() -> Double in return self.holdTime})
        decay = GUIContinuousParameter(minValue: 0.001, maxValue: 1,
                                       setClosure: {(newValue: Double) in
                                        self.oscBank.decayDuration = newValue
                                        self.oscBank.releaseDuration = newValue},
                                       getClosure: {() -> Double in return self.oscBank.decayDuration})
        wavetableIndex = GUIContinuousParameter(minValue: 0, maxValue: 1,
                                                setClosure: {(newValue: Double) in self.oscBank.index = newValue * (self.waveforms.count - 1)},
                                                getClosure: {() -> Double in return self.oscBank.index / (self.waveforms.count - 1)})
        
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
        let stopLag = max(oscBank.attackDuration + holdTime, 0.02)  // Avoid sending stop message at the same time as start message
        DispatchQueue.main.asyncAfter(deadline: .now() + stopLag, execute: {self.oscBank.stop(noteNumber: savedNote)})
        
        // Keep using different MIDI note numbers to avoid notes cutting each other off
        lastPlayedNote += 1
        lastPlayedNote %= 128
    }
    
    func setDecay(_ decay: Double) {
        oscBank.decayDuration = decay
        oscBank.releaseDuration = decay
    }
}
