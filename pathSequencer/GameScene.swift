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
    private var creature : AudioCreature!
    private var path : CreaturePath!
    private var touchedNode : SKNode?
    
    override func didMove(to view: SKView) {
        audioManager = AudioManager()
        path = CreaturePath(nodeCount: 3, parentNode: self)
        creature = AudioCreature(audioManager: audioManager, parentNode: self, path: path)
        
        path.scatterRandomly(xBound: self.size.width, yBound: self.size.height)
        
        audioManager.start()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if self.nodes(at: pos).count > 0 {
            for node in self.nodes(at: pos) {
                if path.contains(node) {
                    touchedNode = node
                    creature.saveProgress()
                }
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if touchedNode != nil && path.contains(touchedNode!) {
            touchedNode?.run(SKAction.move(to: pos, duration: 0))
            path.update()
            creature.updatePosition()
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {

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

// Adapted from https://stackoverflow.com/questions/29627613/skaction-completion-handlers-usage-in-swift
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
