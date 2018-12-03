//
//  SoundModule.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/14/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

protocol SoundModule: AnyObject {
    var track: Track { get set }
    var quantisePitch: Bool { get set }
    var controlPanel: SoundModuleControlPanel? { get set }
    var callbackInstrument: AKCallbackInstrument! { get set }
    
    init(for track: Track)
    
    func createControlPanel() -> SoundModuleControlPanel

    func delete()
    
    func start()
    
    func stop()
    
    func connect(to inputNode: AKInput)
    
    func disconnect()
    
    func sequencerCallback(_ status: AKMIDIStatus, _ noteNumber: MIDINoteNumber, _ velocity: MIDIVelocity)
    
    func getMIDIInput() -> MIDIEndpointRef
    
    func anyObjectSelf() -> AnyObject
}

extension SoundModule where Self: AnyObject {
    func anyObjectSelf() -> AnyObject {
        return self as AnyObject
    }
    
    func setupCallbackInstrument() {
        self.callbackInstrument = AKCallbackInstrument()
        self.callbackInstrument.callback = sequencerCallback(_:_:_:)
    }
}
