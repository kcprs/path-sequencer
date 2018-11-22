//
//  Track.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class Track {
    var soundModule: SoundModule!
    private var sequencerPath: SequencerPath!
    var icon: TrackIconNode?
    var isSelected = false {
        willSet {
            if newValue == true {
                TrackManager.selectedTrack = self
            } else {
                if soundModule.controlPanel != nil {
                    soundModule.controlPanel?.close()
                }
            }
        }
        
        didSet {
            if icon != nil {
                icon!.update()
            }
            sequencerPath.updateSelection()
            SceneManager.scene!.camera!.run(SKAction.move(to: CGPoint(x: 0, y: sequencerPath.convert(sequencerPath.centre, to: SceneManager.scene!).y), duration: 0.2))
        }
    }
    
    init() {
        soundModule = SoundModule()
        sequencerPath = SequencerPath(for: self)
    }
}
