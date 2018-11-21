//
//  TrackManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//
import SpriteKit

class TrackManager {
    private var tracks: Array<Track>!
    var selectedTrack: Track?
    
    init() {
        tracks = Array<Track>()
    }
    
    func addNewTrack() -> Track {
        let track = Track()
        tracks.append(track)
        return track
    }
}
