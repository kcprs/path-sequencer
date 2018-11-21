//
//  AudioManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class AudioManager {
    private static var staticSelf: AudioManager? = nil
    private var mainMixer: AKMixer!
    private var soundModules: Array<SoundModule>!
    
    init() {
        if AudioManager.staticSelf != nil {
            fatalError("There can only be one AudioManager")
        }
        
        mainMixer = AKMixer()
        soundModules = Array<SoundModule>()
    }
    
    func start() {
        AudioKit.output = mainMixer
        try!AudioKit.start()

        mainMixer.start()
        for node in soundModules {
            node.start()
        }
    }
    
    func addSoundModule(_ module: SoundModule) {
        soundModules.append(module)
        module.connect(to: mainMixer)
    }
}
