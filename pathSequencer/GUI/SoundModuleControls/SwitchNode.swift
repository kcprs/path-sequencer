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
    private let nameLabel: SKLabelNode!
    private let valueLabel: SKLabelNode!
    private let diameter: CGFloat = 25
    private let labelSpacer: CGFloat = 20
    
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
        self.nameLabel = SKLabelNode()
        self.valueLabel = SKLabelNode()
        
        super.init()
        
        self.addChild(outerCircle)
        
        innerCircle.fillColor = .white
        
        nameLabel.position.y = labelSpacer
        valueLabel.position.y = -labelSpacer
        nameLabel.fontSize = 20
        valueLabel.fontSize = 20
        valueLabel.verticalAlignmentMode = .top
        self.addChild(nameLabel)
        self.addChild(valueLabel)
        
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
        
        updateLabels()
    }
    
    private func updateLabels() {
        let widthLimit = 6 * diameter
        
        nameLabel.text = parameter.label
        if nameLabel.frame.width > widthLimit {
            nameLabel.xScale = widthLimit / nameLabel.frame.width
        }
        
        valueLabel.text = parameter.getCurrentValueLabel()
        if valueLabel.frame.width > widthLimit {
            valueLabel.xScale = widthLimit / nameLabel.frame.width
        }
    }
    
    override func touchUp(at pos: CGPoint) {
        updateParameterValue()
    }

}
