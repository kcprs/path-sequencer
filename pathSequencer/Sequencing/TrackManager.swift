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
    private static var tracks = Array<Track>()
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
        TrackManager.tracks = Array<Track>()
    }
    
    static func addNewTrack(select: Bool = true) -> Track {
        let track = Track()
        TrackManager.tracks.append(track)
        if select {
            track.isSelected = true
        }
        return track
    }
    
    static func delete(_ track: Track) {
        if track.isSelected {
            track.isSelected = false
        }
        
        let index = tracks.index(of: track)
        tracks.remove(at: index!)
        
        track.delete()
    }
}
