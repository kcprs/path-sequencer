//
//  PathPointNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/15/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PathPointNode: NodeOnSequencerPath {
    var infoLabel: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(parentPath: SequencerPath) {
        infoLabel = SKLabelNode()
        infoLabel.verticalAlignmentMode = .center
        super.init(parentPath: parentPath)
        visibleNode = SKShapeNode(circleOfRadius: 30)
        
        self.zPosition = 3
    }
    
    deinit {
        print("PathPointNode deinit done")
    }
    
    override func touchMoved(to pos: CGPoint) {
        self.position = pos
        parentPath.updateAfterNodeMoved(node: self)
        
        let note = MidiUtil.noteToName(midiPitch: PitchManager.getMIDINoteAt(node: self))
        let mod = PitchManager.getModAt(node: self)
        let modString = String(format: "%.3f", mod)
        let info = note + " mod: " + modString
        infoLabel.text = info
        
        if self.position.x < 0 {
            infoLabel.horizontalAlignmentMode = .left
            infoLabel.position.x = 40
        } else {
            infoLabel.horizontalAlignmentMode = .right
            infoLabel.position.x = -40
        }
        
        let camPos = SceneManager.scene!.cam!.convert(self.position, from: self.parent!)
        if camPos.y < 0 {
            infoLabel.position.y = 20
        } else {
            infoLabel.position.y = -20
        }
    }
    
    override func doubleTap(at pos: CGPoint) {
        parentPath.removePoint(self)
    }
    
    override func touchDown(at pos: CGPoint) {
        if infoLabel.parent == nil {
            self.addChild(infoLabel)
        }
    }
    
    override func touchUp(at pos: CGPoint) {
        infoLabel.removeFromParent()
    }
}
