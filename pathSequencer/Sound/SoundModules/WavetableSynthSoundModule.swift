//
//  WavetableSynthSoundModule.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class WavetableSynthSoundModule: SoundModule {
    unowned var track: Track
    
    var callbackInstrument: AKCallbackInstrument!
    var controlPanel: SoundModuleControlsPanelNode?
    var quantisePitch = true
    
    // AudioKit stuff
    private var oscBank: AKMorphingOscillatorBank!
    private var filter: AKLowPassFilter!
    private var waveforms: Array<AKTable>!
    private var gainStage: AKBooster!
    
    // GUI-controlled parameters
    var volume: ContinuousParameter!
    var attack: ContinuousParameter!
    var hold: ContinuousParameter!
    var decay: ContinuousParameter!
    var wavetableIndex: ContinuousParameter!
    var filterCutoff: ContinuousParameter!
    var pitchQuantisation: DiscreteParameter<Bool>!
    
    required init(for track: Track) {
        self.track = track
        setupCallbackInstrument()
        waveforms = Array<AKTable>()
        waveforms.append(AKTable(.sine))
        waveforms.append(AKTable(.triangle))
        waveforms.append(AKTable(.sawtooth))
        waveforms.append(AKTable(.square))
        
        oscBank = AKMorphingOscillatorBank(waveformArray: waveforms)
        oscBank.rampDuration = 0
        oscBank.sustainLevel = 1
        filter = AKLowPassFilter()
        gainStage = AKBooster()
        gainStage.rampDuration = 0.05
        
        oscBank.connect(to: filter)
        filter.connect(to: gainStage)
        
        AudioManager.addSoundModule(self)
        
        volume = ContinuousParameter(label: "Volume", minValue: 0, maxValue: 1,
                                     setClosure: {(newValue: Double) in self.gainStage.gain = newValue * newValue},
                                     getClosure: {() -> Double in return sqrt(self.gainStage.gain)},
                                     modSource: track.sequencerPath.cursor)
        volume.modAmount = 0
        volume.setActive(true)
        volume.defaultValue = 1
        attack = ContinuousParameter(label: "Attack Time", minValue: 0.01, maxValue: 1,
                                     setClosure: {(newValue: Double) in self.oscBank.attackDuration = newValue},
                                     getClosure: {() -> Double in return self.oscBank.attackDuration},
                                     displayUnit: "s",
                                     modSource: track.sequencerPath.cursor)
        hold = ContinuousParameter(label: "Hold Time", minValue: 1, maxValue: 100,
                                   setClosure: {(newValue: Double) in self.track.holdProportion = newValue / 100},
                                   getClosure: {() -> Double in return self.track.holdProportion * 100},
                                   displayUnit: "%%",
                                   modSource: track.sequencerPath.cursor)
        decay = ContinuousParameter(label: "Decay Time", minValue: 0.01, maxValue: 1,
                                    setClosure: {(newValue: Double) in
                                        self.oscBank.decayDuration = newValue
                                        self.oscBank.releaseDuration = newValue},
                                    getClosure: {() -> Double in return self.oscBank.decayDuration},
                                    displayUnit: "s",
                                    modSource: track.sequencerPath.cursor)
        wavetableIndex = ContinuousParameter(label: "Wavetable Index", minValue: 0, maxValue: 1,
                                             setClosure: {(newValue: Double) in self.oscBank.index = newValue * (self.waveforms.count - 1)},
                                             getClosure: {() -> Double in return self.oscBank.index / (self.waveforms.count - 1)},
                                             modSource: track.sequencerPath.cursor)
        filterCutoff = ContinuousParameter(label: "Filter Cutoff", minValue: 20, maxValue: 20000,
                                           setClosure: {(newValue: Double) in self.filter.cutoffFrequency = newValue},
                                           getClosure: { () -> Double in return self.filter.cutoffFrequency},
                                           displayUnit: "Hz",
                                           modSource: track.sequencerPath.cursor)
        pitchQuantisation = DiscreteParameter(label: "Pitch Quantisation",
                                              setClosure: {(newValue: Bool) in self.quantisePitch = newValue},
                                              getClosure: {() -> Bool in return self.quantisePitch})
        pitchQuantisation.addValue(value: true, valueLabel: "On")
        pitchQuantisation.addValue(value: false, valueLabel: "Off")
    }
    
    deinit {
        print("WavetableSynthSoundModule deinit done")
    }
    
    func createControlPanel() -> SoundModuleControlsPanelNode {
        return WavetableSynthControlPanelNode(for: self)
    }
    
    // TODO: Clean this up
    // Temp ugly hack
    func delete() {
        controlPanel?.close()
        volume.setActive(false)
        volume = nil
        attack.setActive(false)
        attack = nil
        hold.setActive(false)
        hold = nil
        decay.setActive(false)
        decay = nil
        wavetableIndex.setActive(false)
        wavetableIndex = nil
        filterCutoff.setActive(false)
        filterCutoff = nil
        pitchQuantisation = nil
    }
    
    func start() {
        filter.start()
        gainStage.start()
    }
    
    func stop() {
        filter.stop()
        gainStage.stop()
    }
    
    func connect(to inputNode: AKInput) {
        gainStage.connect(to: inputNode)
    }
    
    func disconnect() {
        gainStage.detach()
        oscBank.detach()
        filter.detach()
    }
    
    func setDecay(_ decay: Double) {
        oscBank.decayDuration = decay
        oscBank.releaseDuration = decay
    }
    
    func sequencerCallback(_ status: AKMIDIStatus, _ noteNumber: MIDINoteNumber, _ velocity: MIDIVelocity) {
        if status == .noteOn {
            oscBank.play(noteNumber: noteNumber, velocity: velocity)
        } else if status == .noteOff {
            oscBank.stop(noteNumber: noteNumber)
        }
    }
    
    func getMIDIInput() -> MIDIEndpointRef {
        return callbackInstrument.midiIn
    }
}

