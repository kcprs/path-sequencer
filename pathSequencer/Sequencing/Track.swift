//
//  Track.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class Track: Equatable {
    var soundModule: SoundModule!
    var sequencerPath: SequencerPath!
    var sequencerTrack: AKMusicTrack!
    
    var noteDuration: AKDuration = AKDuration(beats: 1)
    var holdProportion: Double = 0.5 {
        didSet {
            updateSequence()
        }
    }
    
    // Graphics
    var icon: TrackIconNode?
    var isSelected = false {
        willSet {
            if newValue == true {
                SequencingManager.selectedTrack = self
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
    
    init(_ seqTrack: AKMusicTrack) {
        sequencerTrack = seqTrack
        sequencerPath = SequencerPath(for: self)
        soundModule = WavetableSynthSoundModule(for: self)

        sequencerTrack.setMIDIOutput(soundModule.getMIDIInput())
    }
    
    deinit {
        print("Track deinit start")
        soundModule.delete()
        AudioManager.removeSoundModule(soundModule)
        sequencerPath.delete()        
        
        print("Track deinit end")
    }
    
    func updateSequence() {
        sequencerTrack.clear()
        for midiEvent in sequencerPath.getSequencingData() {
            sequencerTrack.add(midiNoteData: midiEvent)
        }
        
        let length = AKDuration(beats: noteDuration.beats * sequencerPath.pointCount)
        
        sequencerTrack.setLoopInfo(length, numberOfLoops: 0)
    }
    
    func getLoopProgress() -> (Int, Double) {
        let sequenceProgress = SequencingManager.sequencer.currentPosition
        let loopProgress = sequenceProgress.beats.truncatingRemainder(dividingBy: noteDuration.beats * sequencerPath.pointCount)
        let currentNoteIndex = Int(loopProgress)
        let currentNoteProgress = loopProgress - Double(currentNoteIndex)
        
        return (currentNoteIndex, currentNoteProgress)
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs === rhs
    }
}
