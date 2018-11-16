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
    private var value : Float!
    private var maxValue : Float!
    private var minValue : Float!
    private var label : SKLabelNode!
    private let labelSpacer : CGFloat = 10
    private var labelText : String!
    private let sensitivity : CGFloat = 50
    private var callback : ((Float) -> Void)!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(labelText: String, minValue: Float, maxValue: Float, updateValueCallback: @escaping (Float) -> Void) {
        super.init()
        
        self.minValue = minValue
        self.maxValue = maxValue
        self.labelText = labelText
        self.callback = updateValueCallback
        
        value = (minValue + maxValue) / 2
        
        circle = SKShapeNode(circleOfRadius: diameter/2)
        self.addChild(circle)
        
        notchRoot = SKNode()
        self.addChild(notchRoot)
        
        notch = SKShapeNode(rectOf: CGSize(width: 1, height: diameter / 2))
        notch.position = CGPoint(x: 0, y: diameter / 4)
        notch.fillColor = .white
        notchRoot.addChild(notch)
        
        label = SKLabelNode()
        label.position = CGPoint(x: 0, y: diameter / 2 + labelSpacer)
        updateLabel()
        self.addChild(label)
        
        self.isUserInteractionEnabled = true
    }
    
    private func updateLabel() {
        label.text = String(format: labelText + ": %.2f", value)
    }
    
    private func touchDown(atPoint pos : CGPoint) {
        lastTouchPos = pos
    }
    
    private func touchMoved(toPoint pos : CGPoint) {
        var angle = lastAngle + (lastTouchPos!.y - pos.y) / sensitivity
        angle = min(angle, rotationLimit)
        angle = max(angle, -rotationLimit)
        
        notchRoot.run(SKAction.rotate(toAngle: angle, duration: 0))
        let proportion = Float((rotationLimit - notchRoot.zRotation) / (2 * rotationLimit))
        let newValue = minValue + proportion * (maxValue - minValue)
        if value != newValue {
            value = newValue
            updateLabel()
            callback(value)
        }
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
