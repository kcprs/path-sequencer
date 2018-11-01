//
//  AudioManager.swift
//  iOsAssignment
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class AudioManager {
    
    private var mainMixer : AKMixer!
    
    init() {
        mainMixer = AKMixer()
    }
    
    func start() {
        AudioKit.output = mainMixer
        
        try!AudioKit.start()
        mainMixer.start()
    }
    
    func addAudioCreature(_ creature: AudioCreature) {
        mainMixer.connect(input: creature.output)
    }
}
