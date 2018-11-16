//
//  AudioManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import AudioKit

class AudioManager {
    
    private var mainMixer: AKMixer!
    private var cursors: Array<AudioCursor>!
    
    init() {
        mainMixer = AKMixer()
        cursors = Array<AudioCursor>()
    }
    
    func start() {
        AudioKit.output = mainMixer
        try!AudioKit.start()

        mainMixer.start()
        for cursor in cursors {
            cursor.startAudio()
        }
    }
    
    func addAudioCursor(_ cursor: AudioCursor) {
        cursors.append(cursor)
        cursor.connectAudio(to: mainMixer)
    }
}
