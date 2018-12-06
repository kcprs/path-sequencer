//
//  SoundModuleControlsPanelNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

protocol SoundModuleControlsPanelNode: AnyObject {
    var soundModule: SoundModule { get }
    
    var backgroundNode: SKShapeNode? { get set }
    var frameMargin: CGFloat { get set }
    var updatables: Array<Updatable> { get set }
    var isInModAssignMode: Bool { get set }
    
    func setupGUI()
    
    func close()
    
    func setModAssignMode(isActive: Bool)
}

extension SoundModuleControlsPanelNode where Self: SKNode {
    func close() {
        for updatable in updatables {
            UpdateManager.remove(updatable)
        }
        
        self.run(SKAction.fadeOut(withDuration: 0.3), completion: {
            self.removeFromParent()
            self.soundModule.controlPanel = nil
        })
    }
    
    func setModAssignMode(isActive: Bool) {
        self.isInModAssignMode = isActive
        for node in self.children {
            if node is KnobNode { // TODO: Add protocol ModAssignable?
                let knob = node as! KnobNode
                
                knob.isInModAssignMode = isActive
            }
        }
    }
}
