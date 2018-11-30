//
//  TouchableNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/22/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

// Having a hard time overriding touch methods AND using a protocol, so writing this as a class
// TODO: Make this into a protocol?
class TouchableNode: SKNode {
    let multiTapWaitTime: TimeInterval = 0.2
    let holdWaitTime: TimeInterval = 0.7
    var numConsecutiveTouches: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        self.isUserInteractionEnabled = true
    }
    
    func touchDown(at pos: CGPoint) {}

    func touchMoved(to pos: CGPoint) {}

    func touchUp(at pos: CGPoint) {}
    
    func singleTap(at pos: CGPoint) {}

    func doubleTap(at pos: CGPoint) {}

    // TODO: Call from below
    func heldTap(at pos: CGPoint) {}

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(at: t.location(in: SceneManager.scene!))
            numConsecutiveTouches += 1
            
            switch numConsecutiveTouches {
            case 1:
                DispatchQueue.main.asyncAfter(deadline: .now() + multiTapWaitTime, execute:
                    {
                        if self.numConsecutiveTouches == 1 {
                            self.singleTap(at: t.location(in: SceneManager.scene!))
                        }
                        self.numConsecutiveTouches = 0
                })
            default:
                self.doubleTap(at: t.location(in: SceneManager.scene!))
                numConsecutiveTouches = 0
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(to: t.location(in: SceneManager.scene!)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(at: t.location(in: SceneManager.scene!)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(at: t.location(in: SceneManager.scene!)) }
    }
}
