//
//  PlaybackManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/3/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

class PlaybackManager {
    private static var staticSelf: PlaybackManager? = nil
    static var tempo: Double = 120
    static var isPlaying = false
    
    init() {
        if PlaybackManager.staticSelf != nil {
            fatalError("There can only be one PlaybackManager")
        }
        PlaybackManager.staticSelf = self
    }
    
    static func start() {
        isPlaying = true
        TrackManager.startPlayback()
    }
    
    static func stop() {
        isPlaying = false
        TrackManager.stopPlayback()
    }
    
    static func getNoteTime(_ note: NoteDuration) -> Double {
        return note.rawValue * 240 / tempo
    }
}
