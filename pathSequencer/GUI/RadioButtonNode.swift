//
//  RadioButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class RadioButtonNode: SKNode {
    private let parameter: DiscreteParameter<Bool>!
    private let outerCircle: SKShapeNode!
    private let innerCircle: SKShapeNode!
    private let diameter: CGFloat = 25
    private let label: SKLabelNode!
    private let labelSpacer: CGFloat = 1.5
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parameter: DiscreteParameter<Bool>) {
        if parameter.valueCount != 2 {
            fatalError("RadioButton can only have two states")
        }
        
        self.parameter = parameter
        self.outerCircle = SKShapeNode(circleOfRadius: diameter / 2)
        self.innerCircle = SKShapeNode(circleOfRadius: 0.7 * diameter / 2)
        self.label = SKLabelNode()
        
        super.init()
        
        self.addChild(outerCircle)
        
        innerCircle.fillColor = .white
        
        label.position.y = (labelSpacer * diameter / 2)
        label.fontSize = 20
        self.addChild(label)
        
        self.isUserInteractionEnabled = true
        
        updateSelfFromParameterValue()
    }
    
    private func updateParameterValue() {
        parameter.goToNextState()
        updateSelfFromParameterValue()
    }
    
    private func updateSelfFromParameterValue() {
        if parameter.getValue() == true && !self.children.contains(innerCircle) {
            self.addChild(innerCircle)
        } else if self.children.contains(innerCircle) {
            innerCircle.removeFromParent()
        }
        
        updateLabel()
    }
    
    private func updateLabel() {
        // Avoid redundant space if label is empty
        var valueLabel = ""
        if parameter.getCurrentValueLabel() != "" {
            valueLabel = ": " + parameter.getCurrentValueLabel()
        }
        
        label.text = parameter.label + valueLabel
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        
    }
    
    private func touchMoved(toPoint pos: CGPoint) {

    }
    
    private func touchUp(atPoint pos: CGPoint) {
        updateParameterValue()
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
