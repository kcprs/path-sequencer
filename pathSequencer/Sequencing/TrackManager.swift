//
//  TrackManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//
import SpriteKit

class TrackManager {
    static var staticSelf: TrackManager? = nil
    private static var tracks: [Track] = []
    static var selectedTrack: Track? {
        willSet {
            for track in tracks {
                track.isSelected = false
            }
        }
    }
    
    init() {
        if TrackManager.staticSelf != nil {
            fatalError("There can only be one TrackManager")
        }
        TrackManager.staticSelf = self
    }
    
    static func addNewTrack() -> Track {
        let track = Track()
        TrackManager.tracks.append(track)
        return track
    }
}
