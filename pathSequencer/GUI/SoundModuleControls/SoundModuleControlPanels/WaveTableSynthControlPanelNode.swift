//
//  WavetableSynthControlPanelNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class WavetableSynthControlPanelNode: SKNode, SoundModuleControlPanel {
    var backgroundNode: SKShapeNode?
    internal var frameMargin: CGFloat = 100
    var soundModule: SoundModule { return _soundModule as SoundModule }
    unowned var _soundModule: WavetableSynthSoundModule
    internal var updatables: Array<Updatable>
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(for soundModule: WavetableSynthSoundModule) {
        self._soundModule = soundModule
        self.backgroundNode = nil
        self.updatables = Array<Updatable>()
        
        super.init()
        
        let scene = SceneManager.scene!
        scene.camera!.addChild(self)
        self.backgroundNode = SKShapeNode(rectOf: CGSize(width: scene.size.width - frameMargin, height: scene.size.height - frameMargin))
        self.backgroundNode!.strokeColor = .white
        self.backgroundNode!.fillColor = .darkGray
        
        soundModule.controlPanel = self
        self.alpha = 0
        self.run(SKAction.fadeAlpha(to: 0.9, duration: 0.3))
        self.addChild(backgroundNode!)
        
        setupGUI()
        
        for updatable in updatables {
            updatable.setActive(true)
        }
    }
    
    deinit {
        print("WavetableSynthControlPanelNode deinit start")
        for updatable in updatables {
            updatable.setActive(false)
        }
        print("WavetableSynthControlPanelNode deinit end")
    }
    
    internal func setupGUI() {
        // TODO: Find a good way to approach GUI layout
        var knob = KnobNode(parameter: _soundModule.attack)
        knob.position = CGPoint(x: -400, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.hold)
        knob.position = CGPoint(x: -200, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.decay)
        knob.position = CGPoint(x: 0, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.wavetableIndex)
        knob.position = CGPoint(x: 200, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.filterCutoff, isLogarithmic: true)
        knob.position = CGPoint(x: 400, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        let radio = RadioButtonNode(parameter: _soundModule.pitchQuantisation)
        radio.position = CGPoint(x: 0, y: 200)
        self.addChild(radio)
    }
    
    internal func removeFromSoundModule() {
        _soundModule.controlPanel = nil
    }
}

