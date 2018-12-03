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
    private var touchedPoint: CGPoint?
    private var trackIconGroupNode: TrackIconGroupNode!
    private var sequencingManagerNode: SequencingManagerNode!
    
    override func didMove(to view: SKView) {
        // Set up the scene
        sceneManager = SceneManager(for: self)

        cam = SKCameraNode()
        self.camera = cam
        cam.position = CGPoint(x: 0, y: PitchManager.getCentreY())
        cam.zPosition = 100 // Keep camera above other nodes
        self.addChild(cam)
        
        trackIconGroupNode = TrackIconGroupNode(SequencingManager.staticSelf!)
        trackIconGroupNode.position = CGPoint(x: 0, y: -self.size.height / 2 + 20)
        cam.addChild(trackIconGroupNode)
        
        sequencingManagerNode = SequencingManagerNode()
        sequencingManagerNode.position = CGPoint(x: self.size.width / 2 - 35, y: self.size.height / 2 - 35)
        cam.addChild(sequencingManagerNode)

        SceneManager.run()
    }
    
    func setCamYPosition(_ newYPosition: CGFloat, duration: TimeInterval = 0) {
        let limitedY = max(self.size.height / 2, min(PitchManager.getHeight() - self.size.height, newYPosition))
        
        let limitedPos = CGPoint(x: 0, y: limitedY)
        
        if duration > 0 {
            let moveAction = SKAction.move(to: limitedPos, duration: duration)
            moveAction.timingMode = .easeOut
            cam.run(moveAction)
        } else {
            cam.position = limitedPos
        }
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        if self.nodes(at: pos).count == 0 {
            touchedPoint = pos
        }
    }
    
    private func touchMoved(toPoint pos: CGPoint) {
        if touchedPoint != nil {
            setCamYPosition(cam.position.y + touchedPoint!.y - pos.y)
        }
    }
    
    private func touchUp(atPoint pos: CGPoint) {
        touchedPoint = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        UpdateManager.updateAll()
    }
}
