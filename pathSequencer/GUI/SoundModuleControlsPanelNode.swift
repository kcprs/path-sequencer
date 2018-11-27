//
//  SoundModuleControlPanelNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SoundModuleControlPanelNode: SKNode {
    private var backgroundNode: SKShapeNode!
    private let frameMargin: CGFloat = 100
    unowned private var soundModule: SoundModule
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for soundModule: SoundModule) {
        self.soundModule = soundModule
        
        super.init()
        
        soundModule.controlPanel = self
        let scene = SceneManager.scene!
        scene.camera!.addChild(self)
        backgroundNode = SKShapeNode(rectOf: CGSize(width: scene.size.width - frameMargin, height: scene.size.height - frameMargin))
        backgroundNode.strokeColor = .white
        backgroundNode.fillColor = .darkGray
        self.alpha = 0
        self.run(SKAction.fadeAlpha(to: 0.9, duration: 0.3))
        self.addChild(backgroundNode)
        
        setupGUI()
    }
    
    private func setupGUI() {
        // TODO: Find a good way to approach GUI layout
        var knob = KnobNode(parameter: soundModule.attack)
        knob.position = CGPoint(x: -400, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(parameter: soundModule.hold)
        knob.position = CGPoint(x: -200, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(parameter: soundModule.decay)
        knob.position = CGPoint(x: 0, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(parameter: soundModule.wavetableIndex)
        knob.position = CGPoint(x: 200, y: 0)
        self.addChild(knob)
        
        knob = KnobNode(parameter: soundModule.filterCutoff, isLogarithmic: true)
        knob.position = CGPoint(x: 400, y: 0)
        self.addChild(knob)
        
        let radio = RadioButtonNode(parameter: soundModule.pitchQuantisation)
        radio.position = CGPoint(x: 0, y: 200)
        self.addChild(radio)
    }
    
    func close() {
        self.run(SKAction.fadeOut(withDuration: 0.3), completion: self.removeFromParent)
    }
}
