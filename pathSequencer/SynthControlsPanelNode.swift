//
//  SynthControlsPanelNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SynthControlPanelNode: SKNode {
    
    private var backgroundNode: SKShapeNode!
    private var parentScene: SKScene!
    private let frameMargin: CGFloat = 100
    private var synthModule: SynthModule!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parentScene: SKScene, synthModule: SynthModule) {
        super.init()
        
        self.parentScene = parentScene
        self.synthModule = synthModule
        self.alpha = 0.9
        parentScene.camera!.addChild(self)
        backgroundNode = SKShapeNode(rectOf: CGSize(width: parentScene.size.width - frameMargin, height: parentScene.size.height - frameMargin))
        backgroundNode.strokeColor = .white
        backgroundNode.fillColor = .darkGray
        self.addChild(backgroundNode)
        
        setupGUI()
    }
    
    private func setupGUI() {
        // TODO: Find a good way to approach GUI layout
        var knob = KnobNode(labelText: "Attack", parameter: synthModule.attack)
        knob.displayedUnit = "s"
        knob.position = CGPoint(x: -400, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(labelText: "Hold", parameter: synthModule.hold)
        knob.displayedUnit = "s"
        knob.position = CGPoint(x: -200, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(labelText: "Decay", parameter: synthModule.decay)
        knob.displayedUnit = "s"
        knob.position = CGPoint(x: 0, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(labelText: "Wavetable Index", parameter: synthModule.wavetableIndex)
        knob.displayedUnit = ""
        knob.position = CGPoint(x: 200, y: 0)
        self.addChild(knob)
    }
    
    func close() {
        self.removeFromParent()
    }
}
