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
    private var circle: SKShapeNode!
    private var notch: SKShapeNode!
    private var knobRoot: SKNode!
    private let rotationLimit: CGFloat = 2.5
    private var diameter: CGFloat = 50
    private var lastTouchPos: CGPoint?
    private var label: SKLabelNode!
    private let labelSpacer: CGFloat = 20
    private var labelText: String!
    private let sensitivity: Double = 100 // Movement by how many pixels maps to range (min -> max)?
    var displayedUnit = ""
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
    
    init(labelText: String, parameter: GUIContinuousParameter) {
        super.init()

        self.parameter = parameter
        self.labelText = labelText
        
        knobRoot = SKNode()
        self.addChild(knobRoot)
        
        circle = SKShapeNode(circleOfRadius: diameter/2)
        knobRoot.addChild(circle)
        
        notch = SKShapeNode(rectOf: CGSize(width: 1, height: diameter / 2))
        notch.position = CGPoint(x: 0, y: diameter / 4)
        notch.fillColor = .white
        knobRoot.addChild(notch)
        
        label = SKLabelNode()
        label.position = CGPoint(x: 0, y: -(diameter / 2 + labelSpacer))
        label.fontSize = 20
        updateLabel()
        self.addChild(label)
        
        self.isUserInteractionEnabled = true
        
        setToProportion(proportion: parameter.getProportion())
    }
    
    private func setToProportion(proportion: Double) {
        let angle = rotationLimit - CGFloat(proportion) * 2 * rotationLimit
        knobRoot.run(SKAction.rotate(toAngle: angle, duration: 0))
        updateLabel()
    }
    
    private func updateLabel() {
        // Avoid redundant space if no unit specified
        var unit = ""
        if displayedUnit != "" {
            unit = " " + displayedUnit
        }
        
        label.text = String(format: labelText + ": %.2f" + unit, parameter.getValue())
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        lastTouchPos = pos
    }
    
    private func touchMoved(toPoint pos: CGPoint) {
        if lastTouchPos != nil {
            let increment = Double(pos.y - lastTouchPos!.y) / sensitivity
            parameter.incrementByProportion(increment)
            setToProportion(proportion: parameter.getProportion())
            lastTouchPos = pos
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
