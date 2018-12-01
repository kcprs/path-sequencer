//
//  Track.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class Track: Equatable {
    var soundModule: SoundModule!
    var sequencerPath: SequencerPath!
    var icon: TrackIconNode?
    var isSelected = false {
        willSet {
            if newValue == true {
                TrackManager.selectedTrack = self
            } else {
                if soundModule.controlPanel != nil {
                    soundModule.controlPanel!.close()
                }
            }
        }
        
        didSet {
            if icon != nil {
                icon!.updateSelection()
            }
            sequencerPath.updateSelection()
            SceneManager.scene!.setCamYPosition(sequencerPath.convert(sequencerPath.centre, to: SceneManager.scene!).y, duration: 0.5)
        }
    }
    
    init() {
        sequencerPath = SequencerPath(for: self)
        soundModule = WavetableSynthSoundModule(for: self)
    }
    
    deinit {
        print("Track deinit start")
        soundModule.delete()
        AudioManager.removeSoundModule(soundModule)
        sequencerPath.delete()
        print("Track deinit end")
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs === rhs
    }
}
