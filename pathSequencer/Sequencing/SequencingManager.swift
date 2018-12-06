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
    static var sequencer: AKSequencer!
    static var tempo: DiscreteParameter<Double>!
    static var isPlaying: Bool { return sequencer.isPlaying }
    
    init() {
        if SequencingManager.staticSelf != nil {
            fatalError("There can only be one SequencingManager")
        }
        SequencingManager.staticSelf = self
        SequencingManager.tracks = Array<Track>()
        SequencingManager.sequencer = AKSequencer()
        SequencingManager.tempo = DiscreteParameter<Double>(label: "Tempo",
                                                         setClosure: {(newTempo: Double) in SequencingManager.sequencer.setTempo(newTempo)},
                                                         getClosure: {() -> Double in return SequencingManager.sequencer.tempo})
        for i in 6...24 {
            SequencingManager.tempo.addValue(value: i * 10, valueLabel: "\(i * 10)")
        }
    }
    
    static func addNewTrack(select: Bool = true) -> Track {
        // Adding tracks to a playing sequencer causes issues
        // Stop, add track and resume if necessary
        let wasPlaying = sequencer.isPlaying
        sequencer.stop()
        
        let seqTrack = sequencer.newTrack()
        let track = Track(seqTrack!)
        SequencingManager.tracks.append(track)
        if select {
            track.isSelected = true
        }
        
        track.updateSequence()
        
        if wasPlaying {
            sequencer.play()
        }
        
        return track
    }
    
    static func deleteTrack(_ track: Track) {
        if track.isSelected {
            track.isSelected = false
            selectedTrack = nil
        }
        
        var index = sequencer.tracks.indexByReference(track.sequencerTrack)
        sequencer.deleteTrack(trackIndex: index!)
        
        index = tracks.index(of: track)
        tracks.remove(at: index!)
        
        track.delete()
    }
    
    static func startPlayback() {
        if tracks.count == 0 {
            return
        }
        
        for track in tracks {
            track.updateSequence()
        }
        sequencer.play()
    }
    
    static func stopPlayback() {
        sequencer.stop()
    }
}
