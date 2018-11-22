//
//  SoundModule.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/14/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class SoundModule: Equatable {
    var controlPanel: SoundModuleControlPanelNode?
    private var oscBank: AKMorphingOscillatorBank!
    private var filter: AKLowPassFilter!
    private var waveforms: Array<AKTable>!
    private var notesPlaying: Array<MIDINoteNumber>!
    private var lastPlayedNote: MIDINoteNumber = 0
    private var holdTime = 0.5
    private var quantisePitch = true
    
    // GUI-controlled parameters
    var attack: ContinuousParameter!
    var hold: ContinuousParameter!
    var decay: ContinuousParameter!
    var wavetableIndex: ContinuousParameter!
    var filterCutoff: ContinuousParameter!
    var pitchQuantisation: DiscreteParameter<Bool>!
    
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
        
        oscBank.connect(to: filter)
        
        AudioManager.addSoundModule(self)
        
        attack = ContinuousParameter(label: "Attack Time", minValue: 0.01, maxValue: 1,
                                        setClosure: {(newValue: Double) in self.oscBank.attackDuration = newValue},
                                        getClosure: {() -> Double in return self.oscBank.attackDuration},
                                        displayUnit: "s")
        hold = ContinuousParameter(label: "Hold Time", minValue: 0.01, maxValue: 1,
                                      setClosure: {(newValue: Double) in self.holdTime = newValue},
                                      getClosure: {() -> Double in return self.holdTime},
                                      displayUnit: "s")
        decay = ContinuousParameter(label: "Decay Time", minValue: 0.01, maxValue: 1,
                                       setClosure: {(newValue: Double) in
                                        self.oscBank.decayDuration = newValue
                                        self.oscBank.releaseDuration = newValue},
                                       getClosure: {() -> Double in return self.oscBank.decayDuration},
                                       displayUnit: "s")
        wavetableIndex = ContinuousParameter(label: "Wavetable Index", minValue: 0, maxValue: 1,
                                                setClosure: {(newValue: Double) in self.oscBank.index = newValue * (self.waveforms.count - 1)},
                                                getClosure: {() -> Double in return self.oscBank.index / (self.waveforms.count - 1)})
        filterCutoff = ContinuousParameter(label: "Filter Cutoff", minValue: 20, maxValue: 20000,
                                              setClosure: {(newValue: Double) in self.filter.cutoffFrequency = newValue},
                                              getClosure: { () -> Double in return self.filter.cutoffFrequency},
                                              displayUnit: "Hz")
        pitchQuantisation = DiscreteParameter(label: "Pitch Quantisation",
                                                 setClosure: {(newValue: Bool) in self.quantisePitch = newValue},
                                                 getClosure: {() -> Bool in return self.quantisePitch})
        pitchQuantisation.addValue(value: true, valueLabel: "On")
        pitchQuantisation.addValue(value: false, valueLabel: "Off")
    }
    
    func start() {
        filter.start()
    }
    
    func stop() {
        filter.stop()
    }
    
    func connect(to inputNode: AKInput) {
        filter.connect(to: inputNode)
    }
    
    func detach() {
        filter.detach()
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
        let stopLag = max(oscBank.attackDuration + holdTime, 0.02)  // Avoid sending stop message too soon after the start message - causes extremely short notes not to play at all
        DispatchQueue.main.asyncAfter(deadline: .now() + stopLag, execute: {self.oscBank.stop(noteNumber: savedNote)})
        
        // Keep using different MIDI note numbers to avoid notes cutting each other off
        lastPlayedNote += 1
        lastPlayedNote %= 128
    }
    
    func setDecay(_ decay: Double) {
        oscBank.decayDuration = decay
        oscBank.releaseDuration = decay
    }
    
    static func == (lhs: SoundModule, rhs: SoundModule) -> Bool {
        return lhs === rhs
    }
}
