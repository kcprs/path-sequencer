//
//  KnobNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/15/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class KnobNode: SKNode {
    private var parameter: GUIContinuousParameter!
    private let circle: SKShapeNode!
    private let notch: SKShapeNode!
    private let knobRoot: SKNode!
    private let rotationLimit: CGFloat = 2.5
    private let diameter: CGFloat = 50
    private var lastTouchPos: CGPoint?
    private var label: SKLabelNode!
    private let labelSpacer: CGFloat = 20
    private let labelText: String!
    private let sensitivity: Double = 200 // Movement by how many pixels maps to full range of assigned parameter?
    private var isLogarithmic = false
    private var proportion: Double {
        set {
            let newProp = max(0, min(1, newValue))
            let angle = rotationLimit - CGFloat(newProp) * 2 * rotationLimit
            knobRoot.run(SKAction.rotate(toAngle: angle, duration: 0))
            updateLabel()
        }
        
        get {
            return Double((rotationLimit - knobRoot.zRotation) / (2 * rotationLimit))
        }
    }
    var fontSize: CGFloat {
        get {
            return label.fontSize
        }
        
        set {
            label.fontSize = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(labelText: String, parameter: GUIContinuousParameter, isLogarithmic: Bool) {
        self.parameter = parameter
        self.labelText = labelText
        self.isLogarithmic = isLogarithmic
        self.knobRoot = SKNode()
        self.circle = SKShapeNode(circleOfRadius: diameter/2)
        self.notch = SKShapeNode(rectOf: CGSize(width: 1, height: diameter / 2))
        self.label = SKLabelNode()
        
        super.init()
        
        self.addChild(knobRoot)

        knobRoot.addChild(circle)
        
        notch.position = CGPoint(x: 0, y: diameter / 4)
        notch.fillColor = .white
        knobRoot.addChild(notch)
        
        label.position = CGPoint(x: 0, y: -(diameter / 2 + labelSpacer))
        label.fontSize = 20
        updateLabel()
        self.addChild(label)
        
        self.isUserInteractionEnabled = true
        
        updateSelfFromParameterValue()
    }
    
    convenience init(labelText: String, parameter: GUIContinuousParameter) {
        self.init(labelText: labelText, parameter: parameter, isLogarithmic: false)
    }
    
    private func updateLabel() {
        // Avoid redundant space if no unit specified
        var unit = ""
        if parameter.getDisplayUnit() != "" {
            unit = " " + parameter.getDisplayUnit()
        }
        
        label.text = String(format: labelText + ": %.2f" + unit, parameter.getValue())
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        lastTouchPos = pos
    }
    
    private func touchMoved(toPoint pos: CGPoint) {
        if lastTouchPos != nil {
            let increment = Double(pos.y - lastTouchPos!.y) / sensitivity
            proportion += increment
            updateParameterValue()
            lastTouchPos = pos
        }
    }
    
    private func updateParameterValue() {
        if isLogarithmic {
            parameter.setLogProportion(proportion)
        } else {
            parameter.setProportion(proportion)
        }
    }
    
    private func updateSelfFromParameterValue() {
        if isLogarithmic {
            proportion = parameter.getLogProportion()
        } else {
            proportion = parameter.getProportion()
        }
    }
    
    private func touchUp(atPoint pos: CGPoint) {
        lastTouchPos = nil
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
