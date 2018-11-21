//
//  SceneManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SceneManager {
    private static var staticSelf: SceneManager? = nil
    static var scene: SKScene? = nil
    static var pitchGrid: PitchGrid? = nil
    static var audioManager: AudioManager? = nil
    let trackManager: TrackManager!
    
    init(for scene: SKScene) {
        if SceneManager.staticSelf != nil {
            fatalError("There can only be one SceneManager")
        }
        
        SceneManager.scene = scene
        SceneManager.pitchGrid = PitchGrid()
        SceneManager.audioManager = AudioManager()
        trackManager = TrackManager()
    }
    
    func run() {
        SceneManager.audioManager!.start()
    }
}
