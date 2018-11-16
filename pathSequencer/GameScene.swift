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
    private var audioManager : AudioManager!
    private var pitchGrid : PitchGrid!
    private var cursor : AudioCursor!
    private var path : CursorPath!
    private var cam: SKCameraNode!
    private var touchedPoint : CGPoint?
    private var pathIcon : SKNode!
    
    override func didMove(to view: SKView) {
        // Set up the scene
        audioManager = AudioManager()
        pitchGrid = PitchGrid(inScene: self)

        cam = SKCameraNode()
        self.camera = cam
        cam.position = CGPoint(x: 0, y: pitchGrid.getCentreY())

        path = CursorPath(nodeCount: 3)
        self.addChild(path)
        path.assignPitchGrid(pitchGrid)
        path.scatterRandomly(centre: cam.position, range: self.size)

        cursor = AudioCursor(onPath: path)
        audioManager.addAudioCursor(cursor)

        pathIcon = SKLabelNode(text: "PathIcon")
        pathIcon.position = CGPoint(x: 0, y: -self.size.height / 2 + 20)
        cam.addChild(pathIcon)
        
        // Add camera last to keep all nodes assigned to it in the foreground
        self.addChild(cam)

        audioManager.start()
    }
    
    private func openSynthControls() {
        _ = SynthControlPanelNode(parentScene: self)
    }
    
    private func touchDown(atPoint pos : CGPoint) {
        if self.nodes(at: pos).count == 0 {
            touchedPoint = pos
        }
    }
    
    private func touchMoved(toPoint pos : CGPoint) {
        if touchedPoint != nil {
            cam.position.y += touchedPoint!.y - pos.y
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if self.nodes(at: pos).count > 0 {
            for node in self.nodes(at: pos) {
                if node == pathIcon {
                    openSynthControls()
                }
            }
        }
        
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
        // Called before each frame is rendered
    }
}

// Adapted from example by Alessandro Ornano
// https://stackoverflow.com/questions/29627613/skaction-completion-handlers-usage-in-swift
extension SKNode
{
    func run(_ action: SKAction!, withKey: String!, optionalCompletion: Optional<() -> Void>)
    {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([action, completionAction])
            run(compositeAction, withKey: withKey)
        }
        else
        {
            run(action, withKey: withKey)
        }
    }
}
