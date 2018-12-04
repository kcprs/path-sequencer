//
//  GameScene.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Should only contain graphical elements and the SceneManager
    private var sceneManager: SceneManager!
    private var cam: SKCameraNode!
    private var trackIconGroupNode: TrackIconGroupNode!
    private var sequencingManagerNode: SequencingManagerNode!
    private var pitchManagerNode: PitchManagerNode!
    
    override func didMove(to view: SKView) {
        // Set up the scene
        sceneManager = SceneManager(for: self)

        cam = SKCameraNode()
        self.camera = cam
        cam.position = CGPoint(x: 0, y: PitchManager.getCentreY())
        self.addChild(cam)
        
        cam.addChild(CameraMoveNode(for: self))
        
        trackIconGroupNode = TrackIconGroupNode()
        trackIconGroupNode.position = CGPoint(x: 0, y: -self.size.height / 2 + 20)
        cam.addChild(trackIconGroupNode)
        
        sequencingManagerNode = SequencingManagerNode()
        sequencingManagerNode.position = CGPoint(x: self.size.width / 2 - 35, y: self.size.height / 2 - 35)
        cam.addChild(sequencingManagerNode)
        
        pitchManagerNode = PitchManagerNode()
        self.addChild(pitchManagerNode)

        SceneManager.run()
    }
    
    func setCamYPosition(_ newYPosition: CGFloat, duration: TimeInterval = 0) {
        let limitedY = max(self.size.height / 2, min(pitchManagerNode.getHeight() - self.size.height, newYPosition))
        
        let limitedPos = CGPoint(x: 0, y: limitedY)
        
        if duration > 0 {
            let moveAction = SKAction.move(to: limitedPos, duration: duration)
            moveAction.timingMode = .easeOut
            cam.run(moveAction)
        } else {
            cam.position = limitedPos
        }
    }
    
    func moveCamYPosition(by: CGFloat) {
        setCamYPosition(cam.position.y + by)
    }
    
    override func update(_ currentTime: TimeInterval) {
        UpdateManager.updateAll()
    }
}
