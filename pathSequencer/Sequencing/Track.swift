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
    
    private var _noteDuration: AKDuration = AKDuration(beats: 1) {
        didSet {
            print("New Duration: \(_noteDuration.description)")
        }
    }
    var noteDuration: DiscreteParameter<AKDuration>!
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
        
        noteDuration = DiscreteParameter<AKDuration>(label: "Note Division",
                                                     setClosure: {(newValue: AKDuration) in
                                                        self._noteDuration = newValue
                                                        self.updateSequence()},
                                                     getClosure: {() -> AKDuration in return self._noteDuration})
        
        noteDuration.addValue(value: AKDuration(beats: 4), valueLabel: "1/1")
        noteDuration.addValue(value: AKDuration(beats: 3), valueLabel: "1/2D")
        noteDuration.addValue(value: AKDuration(beats: 8/3), valueLabel: "1/1T")
        noteDuration.addValue(value: AKDuration(beats: 2), valueLabel: "1/2")
        noteDuration.addValue(value: AKDuration(beats: 3/2), valueLabel: "1/4D")
        noteDuration.addValue(value: AKDuration(beats: 4/3), valueLabel: "1/2T")
        noteDuration.addValue(value: AKDuration(beats: 1), valueLabel: "1/4")
        noteDuration.addValue(value: AKDuration(beats: 3/4), valueLabel: "1/8D")
        noteDuration.addValue(value: AKDuration(beats: 2/3), valueLabel: "1/4T")
        noteDuration.addValue(value: AKDuration(beats: 1/2), valueLabel: "1/8")
        noteDuration.addValue(value: AKDuration(beats: 3/8), valueLabel: "1/16D")
        noteDuration.addValue(value: AKDuration(beats: 1/3), valueLabel: "1/8T")
        noteDuration.addValue(value: AKDuration(beats: 1/4), valueLabel: "1/16")
        noteDuration.addValue(value: AKDuration(beats: 3/16), valueLabel: "1/32D")
        noteDuration.addValue(value: AKDuration(beats: 1/6), valueLabel: "1/16T")
        noteDuration.addValue(value: AKDuration(beats: 1/8), valueLabel: "1/32")
        
        sequencerTrack.setMIDIOutput(soundModule.getMIDIInput())
    }
    
    deinit {
        print("Track deinit start")
        soundModule.delete()
        AudioManager.removeSoundModule(soundModule)
        sequencerPath.delete()        
        
        print("Track deinit end")
    }
    
    func delete() {
        noteDuration = nil
    }
    
    func updateSequence() {
        sequencerTrack.clear()
        for midiEvent in sequencerPath.getSequencingData() {
            sequencerTrack.add(midiNoteData: midiEvent)
        }
        
        let length = AKDuration(beats: _noteDuration.beats * sequencerPath.pointCount)
        sequencerTrack.setLoopInfo(length, numberOfLoops: 0)
    }
    
    func getLoopProgress() -> (Int, Double) {
        let sequenceProgress = SequencingManager.sequencer.currentPosition
        let loopProgress = sequenceProgress.beats.truncatingRemainder(dividingBy: _noteDuration.beats * sequencerPath.pointCount) / _noteDuration.beats
        let currentNoteIndex = Int(loopProgress)
        let currentNoteProgress = loopProgress - Double(currentNoteIndex)
        
        return (currentNoteIndex, currentNoteProgress)
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs === rhs
    }
    
    func getSaveData() -> TrackData {
        var data = TrackData()
        data.noteDuration = noteDuration.getValue().beats
        data.soundModuleData = soundModule.getSaveData()
        
        if soundModule is WavetableSynthSoundModule {
            data.soundModuleType = "WavetableSynthModule"
        }

        for node in sequencerPath.pathPointNodes {
            data.pathPoints.append(PathPointNodeData(node))
        }
        
        return data
    }
    
    func loadData(_ data: TrackData) {
        noteDuration.setValue(newValue: AKDuration(beats: data.noteDuration))
        
        while sequencerPath.pathPointNodes.count < data.pathPoints.count {
            _ = sequencerPath.addNewPoint(from: sequencerPath.pathAddPointNodes[0])
        }
        
        for i in 0..<sequencerPath.pathAddPointNodes.count {
            sequencerPath.pathAddPointNodes[i].position = CGPoint(x: data.pathPoints[i].x, y: data.pathPoints[i].y)
        }
        
        soundModule.loadData(data.soundModuleData)
    }
}

extension AKDuration: Hashable {
    public var hashValue: Int {
        return self.beats.hashValue ^ self.sampleRate.hashValue ^ self.tempo.hashValue
    }
}
