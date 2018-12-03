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
    private static var mainMixer: AKMixer!
    private static var soundModules: Array<AnyObject>!
    
    init() {
        if AudioManager.staticSelf != nil {
            fatalError("There can only be one AudioManager")
        }
        AudioManager.staticSelf = self
        
        AudioManager.mainMixer = AKMixer()
        AudioManager.soundModules = Array<SoundModule>()
    }
    
    static func start() {
        AudioKit.output = mainMixer
        try!AudioKit.start()

        mainMixer.start()
        for module in soundModules {
            (module as! SoundModule).start()
        }
    }
    
    static func addSoundModule(_ module: SoundModule) {
        soundModules.append(module)
        module.connect(to: mainMixer)
    }
    
    static func removeSoundModule(_ module: SoundModule) {
        let index = soundModules.indexByReference(module.anyObjectSelf())
        soundModules.remove(at: index!)
        
        module.disconnect()
        module.stop()
    }
}
