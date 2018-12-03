//
//  SequencingManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//
import AudioKit

class SequencingManager {
    static var staticSelf: SequencingManager? = nil
    private static var tracks = Array<Track>()
    static var selectedTrack: Track? {
        willSet {
            for track in tracks {
                track.isSelected = false
            }
        }
    }
    private static var sequencer: AKSequencer!
    static var tempo: Double = 120
    static var isPlaying: Bool { return sequencer.isPlaying }
    
    init() {
        if SequencingManager.staticSelf != nil {
            fatalError("There can only be one SequencingManager")
        }
        SequencingManager.staticSelf = self
        SequencingManager.tracks = Array<Track>()
        
        SequencingManager.sequencer = AKSequencer()
    }
    
    static func addNewTrack(select: Bool = true) -> Track {
        let seqTrack = sequencer.newTrack()
        let track = Track(seqTrack!)
        SequencingManager.tracks.append(track)
        if select {
            track.isSelected = true
        }
        
        return track
    }
    
    static func delete(_ track: Track) {
        if track.isSelected {
            track.isSelected = false
            selectedTrack = nil
        }
        
        let index = tracks.index(of: track)
        tracks.remove(at: index!)
    }
    
    static func startPlayback() {
        for track in tracks {
//            track.startPlayback()
            track.updateSequence()
        }
        sequencer.play()
    }
    
    static func stopPlayback() {
//        for track in tracks {
//            track.stopPlayback()
//        }
        sequencer.stop()
    }
    
    static func getNoteTime(_ note: AKDuration) -> Double {
        var newNote = note
        newNote.tempo = tempo
        return newNote.seconds
    }
}
