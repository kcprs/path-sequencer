//
//  WavetableSynthControlPanelNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class WavetableSynthControlPanelNode: SKNode, SoundModuleControlsPanelNode {
    var soundModule: SoundModule { return _soundModule as SoundModule }
    unowned var _soundModule: WavetableSynthSoundModule
    var isInModAssignMode: Bool = false
    
    var backgroundNode: SKShapeNode?
    var frameMargin: CGFloat = 100
    var updatables: Array<Updatable>
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(for soundModule: WavetableSynthSoundModule) {
        self._soundModule = soundModule
        self.backgroundNode = nil
        self.updatables = Array<Updatable>()
        
        super.init()
        self.zPosition = 20
        
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
            updatable.setUpdatesActive(true)
        }
    }
    
    deinit {
        print("WavetableSynthControlPanelNode deinit start")
        for updatable in updatables {
            updatable.setUpdatesActive(false)
        }
        print("WavetableSynthControlPanelNode deinit end")
    }
    
    func setupGUI() {
        let xGrid: CGFloat = 180
        let synthLabel = SKLabelNode(text: "Synth")
        let fxLabel = SKLabelNode(text: "FX")
        let trackLabel = SKLabelNode(text: "Track")
        
        synthLabel.position = CGPoint(x: -440, y: 270)
        fxLabel.position = CGPoint(x: -440, y: 70)
        trackLabel.position = CGPoint(x: -440, y: -130)
        
        synthLabel.horizontalAlignmentMode = .left
        fxLabel.horizontalAlignmentMode = .left
        trackLabel.horizontalAlignmentMode = .left
        
        self.addChild(synthLabel)
        self.addChild(fxLabel)
        self.addChild(trackLabel)
        
        let scene = SceneManager.scene!
        let modCut: CGFloat = 160
        let synthRect = SKShapeNode(rectOf: CGSize(width: scene.size.width - 1.5 * frameMargin, height: 140))
        let fxRect = SKShapeNode(rectOf: CGSize(width: scene.size.width - 1.5 * frameMargin, height: 140))
        let trackRect = SKShapeNode(rectOf: CGSize(width: scene.size.width - 1.5 * frameMargin - modCut, height: 140))
        
        synthRect.strokeColor = .gray
        fxRect.strokeColor = .gray
        trackRect.strokeColor = .gray
        
        synthRect.position.y = 200
        trackRect.position.y = -200
        trackRect.position.x = -modCut / 2
        
        self.addChild(synthRect)
        self.addChild(fxRect)
        self.addChild(trackRect)
        
        var knob: KnobNode
        
        knob = KnobNode(parameter: _soundModule.attack)
        knob.position = CGPoint(x: -2 * xGrid, y: 200)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.hold)
        knob.position = CGPoint(x: -xGrid, y: 200)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.decay)
        knob.position = CGPoint(x: 0, y: 200)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.wavetableIndex)
        knob.position = CGPoint(x: xGrid, y: 200)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.filterCutoff)
        knob.position = CGPoint(x: 2 * xGrid, y: 200)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.effectsModule.delayMix)
        knob.position = CGPoint(x: -2 * xGrid, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.effectsModule.delayTime)
        knob.position = CGPoint(x: -xGrid, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.effectsModule.delayFeedback)
        knob.position = CGPoint(x: 0, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.effectsModule.reverbMix)
        knob.position = CGPoint(x: xGrid, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.effectsModule.reverbFeedback)
        knob.position = CGPoint(x: 2 * xGrid, y: 0)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.volume)
        knob.position = CGPoint(x: -2 * xGrid, y: -200)
        self.addChild(knob)
        updatables.append(knob)
        
        knob = KnobNode(parameter: _soundModule.pan)
        knob.position = CGPoint(x: -xGrid, y: -200)
        self.addChild(knob)
        updatables.append(knob)
        
        let speedSelector = ScrollSelectorNode<AKDuration>(parameter: soundModule.track.noteDuration)
        speedSelector.position = CGPoint(x: 0, y: -200)
        self.addChild(speedSelector)
        
        let switchNode = SwitchNode(parameter: _soundModule.pitchQuantisation)
        switchNode.position = CGPoint(x: xGrid, y: -200)
        self.addChild(switchNode)
        
        let modButton = ModAssignModeButtonNode(for: self)
        modButton.position = CGPoint(x: 2 * xGrid, y: -200)
        self.addChild(modButton)
    }
    
    func removeFromSoundModule() {
        _soundModule.controlPanel = nil
    }
}

