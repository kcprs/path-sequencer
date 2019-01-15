//
//  EffectsModule.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class EffectsModule {
    unowned var track: Track
    var delay: AKVariableDelay
    var delayMixer: AKDryWetMixer
    var reverb: AKCostelloReverb
    var reverbMixer: AKDryWetMixer
    var input: AKMixer
    
    var delayMix: ContinuousParameter!
    var delayTime: ContinuousParameter!
    var delayFeedback: ContinuousParameter!
    var reverbMix: ContinuousParameter!
    var reverbFeedback: ContinuousParameter!
    
    init(for track: Track) {
        self.track = track
        self.input = AKMixer()
        self.delay = AKVariableDelay(input, time: 0.5, feedback: 0.3, maximumDelayTime: 2)
        self.delayMixer = AKDryWetMixer(input, delay)
        self.reverb = AKCostelloReverb(delayMixer)
        self.reverbMixer = AKDryWetMixer(delayMixer, reverb)
        
        reverb.rampDuration = 0.05
        delay.rampDuration = 0.05
        
        delayMix = ContinuousParameter(label: "Delay Mix", minValue: 0, maxValue: 100,
                                       setClosure: {(newValue: Double) in self.delayMixer.balance = newValue / 100},
                                       getClosure: {() -> Double in return self.delayMixer.balance * 100},
                                       displayUnit: "%%",
                                       modSource: track.sequencerPath.cursor)
        delayMix.setUpdatesActive(true)
        delayMix.defaultValue = 0
        
        delayTime = ContinuousParameter(label: "Delay Time", minValue: 10, maxValue: 2000,
                                        setClosure: {(newValue: Double) in self.delay.time = newValue / 1000},
                                        getClosure: {() -> Double in return self.delay.time * 1000},
                                        displayUnit: "ms",
                                        modSource: track.sequencerPath.cursor)
        delayTime.setUpdatesActive(true)
        
        delayFeedback = ContinuousParameter(label: "Delay Feedback", minValue: 0, maxValue: 100,
                                            setClosure: {(newValue: Double) in self.delay.feedback = newValue / 100},
                                            getClosure: {() -> Double in return self.delay.feedback * 100},
                                            displayUnit: "%%",
                                            modSource: track.sequencerPath.cursor)
        delayFeedback.setUpdatesActive(true)
        
        reverbMix = ContinuousParameter(label: "Reverb Mix", minValue: 0, maxValue: 100,
                                        setClosure: {(newValue: Double) in self.reverbMixer.balance = newValue / 100},
                                        getClosure: {() -> Double in return self.reverbMixer.balance * 100},
                                        displayUnit: "%%",
                                        modSource: track.sequencerPath.cursor)
        reverbMix.setUpdatesActive(true)
        reverbMix.defaultValue = 0
        
        reverbFeedback = ContinuousParameter(label: "Reverb Feedback", minValue: 0, maxValue: 100,
                                          setClosure: {(newValue: Double) in self.reverb.feedback = newValue / 100},
                                          getClosure: {() -> Double in return self.reverb.feedback * 100},
                                          displayUnit: "%%",
                                          modSource: track.sequencerPath.cursor)
        reverbFeedback.setUpdatesActive(true)
    }
    
    func delete() {
        delayMix.setUpdatesActive(false)
        delayMix = nil
        delayTime.setUpdatesActive(false)
        delayTime = nil
        delayFeedback.setUpdatesActive(false)
        delayFeedback = nil
        reverbMix.setUpdatesActive(false)
        reverbMix = nil
        reverbFeedback.setUpdatesActive(false)
        reverbFeedback = nil
    }
    
    func connect(to inputNode: AKInput) {
        reverbMixer.connect(to: inputNode)
    }
    
    func start() {
        reverb.start()
        delay.start()
    }
    
    func stop() {
        reverb.stop()
        delay.stop()
    }
    
    func disconnect() {
        reverb.detach()
        delay.detach()
    }
}
