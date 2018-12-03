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
    var notesPlaying: Array<MIDINoteNumber>! { get set }
    var lastPlayedNote: MIDINoteNumber { get set }
    var quantisePitch: Bool { get set }
    var controlPanel: SoundModuleControlPanel? { get set }
    
    init(for track: Track)
    
    func createControlPanel() -> SoundModuleControlPanel

    func delete()
    
    func start()
    
    func stop()
    
    func connect(to inputNode: AKInput)
    
    func disconnect()
    
    func trigger(freq: Double)
    
    func getMIDIInput() -> MIDIEndpointRef
    
    func anyObjectSelf() -> AnyObject
}

extension SoundModule where Self: AnyObject {
    func anyObjectSelf() -> AnyObject {
        return self as AnyObject
    }
}
