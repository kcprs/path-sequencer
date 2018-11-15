//
//  KnobNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/15/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class KnobNode : SKNode {
    private var circle : SKShapeNode!
    private var notch : SKShapeNode!
    private var notchRoot : SKNode!
    private let rotationLimit : CGFloat = 2.5
    private var diameter : CGFloat = 100
    private var lastTouchPos : CGPoint?
    private var lastAngle : CGFloat = 0
    private var value = 0.5
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        circle = SKShapeNode(circleOfRadius: diameter/2)
        self.addChild(circle)
        
        notchRoot = SKNode()
        self.addChild(notchRoot)
        
        notch = SKShapeNode(rectOf: CGSize(width: 1, height: diameter / 2))
        notch.position = CGPoint(x: 0, y: diameter / 4)
        notch.fillColor = .white
        notchRoot.addChild(notch)
        
        self.isUserInteractionEnabled = true
    }
    
    private func touchDown(atPoint pos : CGPoint) {
        lastTouchPos = pos
    }
    
    private func touchMoved(toPoint pos : CGPoint) {
        var angle = lastAngle + (lastTouchPos!.y - pos.y) / 100
        angle = min(angle, rotationLimit)
        angle = max(angle, -rotationLimit)
        
        notchRoot.run(SKAction.rotate(toAngle: angle, duration: 0))
        value = Double((rotationLimit - notchRoot.zRotation) / (2 * rotationLimit))
        print("Value = \(value)")
    }
    
    private func touchUp(atPoint pos : CGPoint) {
        lastAngle = notchRoot.zRotation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
}
