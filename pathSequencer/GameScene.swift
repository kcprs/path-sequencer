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
    var cam: SKCameraNode!
    var trackIconGroupNode: TrackIconGroupNode!
    private var sequencingManagerNode: SequencingManagerNode!
    private var pitchManagerNode: PitchManagerNode!
    private var menuButtonNode: MenuButtonNode!
    private var menuNode: MenuNode?
    
    override func didMove(to view: SKView) {
        view.ignoresSiblingOrder = true
        
        // Set up the scene
        sceneManager = SceneManager(for: self)

        cam = SKCameraNode()
        self.camera = cam
        cam.position = CGPoint(x: 0, y: PitchManager.getCentreY())
        self.addChild(cam)
        
        cam.addChild(CameraMoveNode(for: self))
        
        trackIconGroupNode = TrackIconGroupNode()
        trackIconGroupNode.position = CGPoint(x: 0, y: -self.size.height / 2 + 35)
        cam.addChild(trackIconGroupNode)
        
        sequencingManagerNode = SequencingManagerNode()
        sequencingManagerNode.position = CGPoint(x: self.size.width / 2 - 35, y: self.size.height / 2 - 35)
        cam.addChild(sequencingManagerNode)
        
        menuButtonNode = MenuButtonNode()
        menuButtonNode.position = CGPoint(x: self.size.width / 2 - 35, y: -self.size.height / 2 + 35)
        cam.addChild(menuButtonNode)
        
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
    
    func showMenu() {
        hideMenu()
        menuNode = MenuNode()
        cam.addChild(menuNode!)
    }
    
    func hideMenu() {
        if menuNode != nil {
            menuNode!.removeFromParent()
        }
        menuNode = nil
    }
    
    func moveCamYPosition(by: CGFloat) {
        setCamYPosition(cam.position.y + by)
    }
    
    override func update(_ currentTime: TimeInterval) {
        UpdateManager.updateAll()
    }
}
