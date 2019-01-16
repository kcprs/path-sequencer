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
    
    init(for scene: GameScene) {
        if SceneManager.staticSelf != nil {
            fatalError("There can only be one SceneManager")
        }
        SceneManager.staticSelf = self
        
        SceneManager.scene = scene
        let _ = PitchManager()
        let _ = AudioManager()
        let _ = SequencingManager()
        let _ = UpdateManager()
    }
    
    static func run() {
        AudioManager.start()
        
        if SelectionStorage.selectedURL != nil {
            let url = SelectionStorage.selectedURL!
            SequencingManager.loadFromJSON(path: url)
        }
    }
}
