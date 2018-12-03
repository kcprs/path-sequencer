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
        
        // tmp midi instrument
        let tmp = AKMIDISampler()
        tmp.enableMIDI()
        AudioManager.addNode(node: tmp)
        seqTrack.setMIDIOutput(tmp.midiIn)
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
        sequencerTrack.setLoopInfo(sequencerTrack.getLength(), numberOfLoops: 0)
    }
    
    func startPlayback() {
        sequencerPath.cursor.resumeMovement()
    }
    
    func stopPlayback() {
        sequencerPath.cursor.stop()
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs === rhs
    }
}

extension AKMusicTrack {
    func getLength() -> AKDuration {
        var length: AKDuration = AKDuration(seconds: 0)
        
        for event in self.getMIDINoteData() {
            if event.position + event.duration > length {
                length = event.position + event.duration
            }
        }
        
        return length
    }
}
