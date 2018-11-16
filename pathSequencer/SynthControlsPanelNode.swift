//
//  SynthControlsPanelNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SynthControlPanelNode : SKNode {
    
    private var backgroundNode : SKShapeNode!
    private var parentScene : SKScene!
    private let frameMargin : CGFloat = 100
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parentScene: SKScene) {
        super.init()
        
        self.parentScene = parentScene
        parentScene.camera!.addChild(self)
        backgroundNode = SKShapeNode(rectOf: CGSize(width: parentScene.size.width - frameMargin, height: parentScene.size.height - frameMargin))
        backgroundNode.strokeColor = .white
        backgroundNode.fillColor = .darkGray
        self.addChild(backgroundNode)
        
        let knob = KnobNode(labelText: "Test", minValue: 0, maxValue: 1, updateValueCallback: updateValue)
        self.addChild(knob)
    }
    
    private func updateValue(value: Float) {
        print(value)
    }
}
