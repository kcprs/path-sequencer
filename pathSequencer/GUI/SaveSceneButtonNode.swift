//
//  SaveSceneButtonNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/16/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SaveSceneButtonNode: TouchableNode {
    let visibleNode: SKShapeNode!
    var labelNode: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        visibleNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        visibleNode.fillColor = .white
        labelNode = SKLabelNode()
        labelNode.position = CGPoint(x: 40, y: 0)
        labelNode.verticalAlignmentMode = .center
        super.init()
        self.addChild(visibleNode)
        self.zPosition = 10
    }
    
    override func touchUp(at pos: CGPoint) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let sceneName = "Saved_Scene_\(date)_\(String(format: "%2.0f", hour.value())):" + String(format: "%2.0f", minutes.value())
        SequencingManager.saveToJSON(fileName: sceneName)
        labelNode.text = "Scene saved as \(sceneName)"
        self.addChild(labelNode)
        labelNode.alpha = 0
        labelNode.run(SKAction.fadeAlpha(to: 0.9, duration: 1), completion: hideLabel)
    }
    
    private func hideLabel() {
        self.labelNode.run(SKAction.fadeOut(withDuration: 1), completion: {
            self.labelNode.removeFromParent()
        })
    }
}
