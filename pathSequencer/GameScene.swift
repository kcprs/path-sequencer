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
        
        cam.constraints = [SKConstraint.positionY(SKRange(lowerLimit: self.size.height / 2, upperLimit: pitchManagerNode.getHeight() - self.size.height))]

        SceneManager.run()
    }
    
    func setCamYPosition(_ newYPosition: CGFloat, duration: TimeInterval = 0) {
        let newPos = CGPoint(x: 0, y: newYPosition)
        
        if duration > 0 {
            let moveAction = SKAction.move(to: newPos, duration: duration)
            moveAction.timingMode = .easeOut
            cam.run(moveAction)
        } else {
            cam.position = newPos
        }
    }
    
    func moveCamYPosition(by: CGFloat) {
        setCamYPosition(cam.position.y + by)
    }
    
    override func update(_ currentTime: TimeInterval) {
        UpdateManager.updateAll()
    }
}
