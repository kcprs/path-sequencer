//
//  CameraMoveNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/4/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

// This class is a hack to prevent unwanted nodes
// from blocking touch input to the scene background
// (which previously was resposible for moving the camera on touch drag)
// This Node fills the whole screen, only allowing touches
// to nodes with higher zPosition.
class CameraMoveNode: TouchableNode {
    private let _scene: GameScene!
    private var touchedPoint: CGPoint?
    
    // Required by the super class, not used
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(for scene: GameScene) {
        self._scene = scene
        super.init()
        
        // Fill the whole screen with a translucent rectangle
        // This will force camera bounds to span the whole screen
        let fullScreenRect = SKShapeNode(rectOf: scene.size)
        fullScreenRect.alpha = 0.000000001  // Hack to make the rectangle respond to touch while remaining practically invisible
        self.addChild(fullScreenRect)
        self.zPosition = 1
    }
    
    override func touchDown(at pos: CGPoint) {
        touchedPoint = pos
    }
    
    // Move camera when dragged
    override func touchMoved(to pos: CGPoint) {
        if touchedPoint != nil {
            _scene.moveCamYPosition(by: touchedPoint!.y - pos.y)
        }
    }
    
    override func touchUp(at pos: CGPoint) {
        touchedPoint = nil
    }
}
