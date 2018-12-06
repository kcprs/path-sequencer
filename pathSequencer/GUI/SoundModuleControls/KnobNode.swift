//
//  KnobNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/15/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class KnobNode: TouchableNode, Updatable {
    unowned private let parameter: ContinuousParameter
    
    var isActive = false
    private let sensitivity: Double = 200 // Movement by how many pixels maps to full range of assigned parameter?
    private var lastTouchPos: CGPoint?
    
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
    var isInModAssignMode = false {
        didSet {
            if self.isInModAssignMode {
                circle.fillColor = .orange
                notch.fillColor = .orange
                redrawModAmountPreview()
                knobRoot.addChild(modAmountPreview)
            } else {
                circle.fillColor = .clear
                notch.fillColor = .clear
                modAmountPreview.removeFromParent()
            }
        }
    }
    
    // Graphics
    private let circle: SKShapeNode!
    private let notch: SKShapeNode!
    private let knobRoot: SKNode!
    private let modPreview: SKShapeNode!
    private let modPreviewRoot: SKNode!
    private var modAmountPreview: SKShapeNode!
    private let rotationLimit: CGFloat = 2.5
    private let diameter: CGFloat = 50
    private let labelSpacer: CGFloat = 1.4
    private var label: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parameter: ContinuousParameter, isLogarithmic: Bool = false) {
        self.parameter = parameter
        self.isLogarithmic = isLogarithmic
        self.knobRoot = SKNode()
        self.circle = SKShapeNode(circleOfRadius: diameter / 2)
        self.notch = SKShapeNode(rectOf: CGSize(width: 1, height: diameter / 2))
        self.label = SKLabelNode()
        self.modPreview = SKShapeNode(circleOfRadius: diameter / 10)
        self.modPreviewRoot = SKNode()
        self.modAmountPreview = SKShapeNode()
        
        super.init()
        
        self.addChild(knobRoot)

        knobRoot.addChild(circle)
        
        notch.position = CGPoint(x: 0, y: diameter / 4)
        notch.fillColor = .white
        knobRoot.addChild(notch)
        
        label.position = CGPoint(x: 0, y: labelSpacer * diameter / 2)
        label.fontSize = 20
        updateLabel()
        self.addChild(label)
        
        self.addChild(modPreviewRoot)
        modPreview.position = CGPoint(x: 0, y: diameter / 2)
        modPreview.fillColor = .gray
        modPreviewRoot.addChild(modPreview)
        
        updateSelfFromParameterValue()
    }
    
    deinit {
        print("KnobNode deinit done")
    }
    
    private func updateLabel() {
        // Avoid redundant space if no unit specified
        var unit = ""
        if parameter.displayUnit != "" {
            unit = " " + parameter.displayUnit
        }
        
        label.text = String(format: parameter.label + ": %.2f" + unit, parameter.getUserValue())
    }
    
    private func updateParameterValue() {
        if isLogarithmic {
            parameter.setUserLogProportion(proportion)
        } else {
            parameter.setUserProportion(proportion)
        }
    }
    
    private func updateSelfFromParameterValue() {
        if isLogarithmic {
            proportion = parameter.getUserLogProportion()
        } else {
            proportion = parameter.getUserProportion()
        }
    }
    
    override func touchDown(at pos: CGPoint) {
        lastTouchPos = pos
    }
    
    override func touchMoved(to pos: CGPoint) {
        if lastTouchPos != nil {
            let increment = Double(pos.y - lastTouchPos!.y) / sensitivity
            
            if !isInModAssignMode {
                proportion += increment
                updateParameterValue()
            } else {
                parameter.incrementModAmount(by: increment)
                redrawModAmountPreview()
            }
            
            lastTouchPos = pos
        }
    }
    
    override func touchUp(at pos: CGPoint) {
        lastTouchPos = nil
    }
    
    override func doubleTap(at pos: CGPoint) {
        if !isInModAssignMode {
            parameter.resetToDefaultValue()
            updateSelfFromParameterValue()
        } else {
            parameter.modAmount = 0
            redrawModAmountPreview()
        }
    }
    
    private func redrawModAmountPreview() {
        if parameter.modAmount == 0 {
            modAmountPreview.path = nil
            return
        }
        
        let path = CGMutablePath()
        let angle = CGFloat.pi / 2 - 2 * rotationLimit * CGFloat(parameter.getModAmount())
        let clockwise = (parameter.getModAmount() > 0 ? true : false)
        path.addArc(center: CGPoint(x: 0, y: 0), radius: self.diameter / 2, startAngle: CGFloat.pi / 2, endAngle: angle, clockwise: clockwise)
        
        modAmountPreview.path = path
        modAmountPreview.strokeColor = .green
        modAmountPreview.glowWidth = 2
    }
    
    func update() {
        if parameter.modAmount == 0 {
            modPreview.isHidden = true
        } else {
            modPreview.isHidden = false
            let newProp = parameter.getCurrentProportion()
            let angle = rotationLimit - CGFloat(newProp) * 2 * rotationLimit
            modPreviewRoot.run(SKAction.rotate(toAngle: angle, duration: 0))
        }
    }
}
