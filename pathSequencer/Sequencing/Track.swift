//
//  Track.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

class Track {
    var soundModule: SoundModule!
    private var sequencerPath: SequencerPath!
    
    init() {
        soundModule = SoundModule()
        sequencerPath = SequencerPath(for: self)
    }
}
