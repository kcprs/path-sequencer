//
//  SwitchNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SwitchNode: TouchableNode {
    unowned private let parameter: DiscreteParameter<Bool>
    
    // Graphics
    private let outerCircle: SKShapeNode!
    private let innerCircle: SKShapeNode!
    private let label: SKLabelNode!
    private let diameter: CGFloat = 25
    private let labelSpacer: CGFloat = 1.5
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parameter: DiscreteParameter<Bool>) {
        if parameter.valueCount != 2 {
            fatalError("Switch can only have two states")
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
        
        updateSelfFromParameterValue()
    }
    
    deinit {
        print("SwitchNode deinit done")
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
    
    override func touchUp(at pos: CGPoint) {
        updateParameterValue()
    }

}
