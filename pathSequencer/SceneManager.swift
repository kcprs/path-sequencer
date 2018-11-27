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
    weak static var scene: GameScene? = nil
    static var pitchGrid: PitchGrid? = nil
    
    init(for scene: GameScene) {
        if SceneManager.staticSelf != nil {
            fatalError("There can only be one SceneManager")
        }
        SceneManager.staticSelf = self
        
        SceneManager.scene = scene
        SceneManager.pitchGrid = PitchGrid()
        let _ = AudioManager()
        let _ = TrackManager()
    }
    
    static func run() {
        AudioManager.start()
    }
}
