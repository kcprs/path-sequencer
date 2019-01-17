//
//  TrackIconGroupNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class TrackIconGroupNode: TouchableNode {
    private var icons: Array<TrackIconNode>!
    private var width: CGFloat = 0
    private var addNewTrackButton: AddNewTrackButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        icons = Array<TrackIconNode>()
        addNewTrackButton = AddNewTrackButton()
        width = 60
        
        super.init()
        
        addNewTrackButton.zPosition = 10
        self.addChild(addNewTrackButton)
    }
    
    func addIcon(_ icon: TrackIconNode) {
        icons.append(icon)
        icon.position.x = width
        self.addChild(icon)
        icon.addToGroup(group: self)
        icon.alpha = 0
        icon.run(SKAction.fadeIn(withDuration: 0.3))
        width += icon.getWidth()
        
        updatePosition()
    }
    
    func removeIcon(_ icon: TrackIconNode) {
        let index = icons.index(of: icon)
        
        if index == nil {
            return
        }
        
        icons.remove(at: index!)
        width -= icon.getWidth()
        icon.run(SKAction.fadeOut(withDuration: 0.3), completion: icon.removeFromParent)
        
        if index! < icons.count {
            for i in index!..<icons.count {
                let action = SKAction.move(by: CGVector(dx: -icons[i].getWidth(), dy: 0), duration: 0.5)
                action.timingMode = .easeOut
                icons[i].run(action)
            }
        }
        
        updatePosition()
    }
    
    private func updatePosition() {
        let selfAction = SKAction.move(to: CGPoint(x: -width / 2, y: self.position.y), duration: 0.5)
        selfAction.timingMode = .easeOut
        self.run(selfAction)
        
        let buttonAction = SKAction.move(to: CGPoint(x: width, y: 0), duration: 0.5)
        buttonAction.timingMode = .easeOut
        addNewTrackButton.run(buttonAction)
    }
    
    override func touchUp(at pos: CGPoint) {
        if self.scene!.nodes(at: pos).contains(addNewTrackButton) {
            let track = SequencingManager.addNewTrack()
            addIcon(TrackIconNode(for: track))
        }
    }
}

class AddNewTrackButton: SKNode {
    let shape: SKSpriteNode!
    let plus: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        shape = SKSpriteNode(imageNamed: "cursorGrey.png")
        plus = SKLabelNode(text: "+")
        plus.fontColor = .gray
        super.init()
        plus.verticalAlignmentMode = .center
        plus.horizontalAlignmentMode = .center
        self.addChild(shape)
        self.addChild(plus)
    }
}
