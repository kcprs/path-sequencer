//
//  TrackIconGroupNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

// Holds all TrackIcons at the bottom of the screen
// Provides a button for adding new tracks
class TrackIconGroupNode: TouchableNode {
    private var icons: Array<TrackIconNode>!
    private var width: CGFloat = 0
    private var addNewTrackButton: AddNewTrackButton!
    
    // Required by the super class, not used
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
    
    // Adds TrackIcon to this object
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
    
    // Removes TrackIcon from this object
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
    
    // Re-positions all icons after addition/deletion
    private func updatePosition() {
        let selfAction = SKAction.move(to: CGPoint(x: -width / 2, y: self.position.y), duration: 0.5)
        selfAction.timingMode = .easeOut
        self.run(selfAction)
        
        let buttonAction = SKAction.move(to: CGPoint(x: width, y: 0), duration: 0.5)
        buttonAction.timingMode = .easeOut
        addNewTrackButton.run(buttonAction)
    }
    
    // Provide functionality for the button - respond to touch
    override func touchUp(at pos: CGPoint) {
        if self.scene!.nodes(at: pos).contains(addNewTrackButton) {
            if SequencingManager.getNumTracks() > 9 {
                return
            }
            
            let track = SequencingManager.addNewTrack()
            addIcon(TrackIconNode(for: track))
        }
    }
}

// Button for adding new tracks
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
