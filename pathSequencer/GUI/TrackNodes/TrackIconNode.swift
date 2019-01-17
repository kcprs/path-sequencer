//
//  TrackIconNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class TrackIconNode: TouchableNode {
    unowned private let track: Track
    weak private var controlPanel: SoundModuleControlsPanelNode?
    weak private var iconGroup: TrackIconGroupNode?

    var label: SKLabelNode!
    private var shape: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        self.track = track
        
        super.init()
        
        track.icon = self
        
        shape = SKSpriteNode(imageNamed: "cursor")
        let num = SequencingManager.getNumTracks()
        label = SKLabelNode(text: "\(num)")
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        self.addChild(label)
        self.addChild(shape)
        self.zPosition = 10
        
        self.updateSelection()
    }
    
    deinit {
        print("TrackIconNode deinit done")
    }
    
    func getWidth() -> CGFloat {
        return 60
    }
    
    func updateSelection() {
        if track.isSelected {
            shape.removeFromParent()
            shape = SKSpriteNode(imageNamed: "cursorOrange.png")
            self.addChild(shape)
            label.fontColor = .orange
        } else {
            shape.removeFromParent()
            shape = SKSpriteNode(imageNamed: "cursor.jpg")
            self.addChild(shape)
            label.fontColor = .white
        }
    }
    
    func addToGroup(group: TrackIconGroupNode) {
        iconGroup = group
    }
    
    override func singleTap(at pos: CGPoint) {
        if track.isSelected {
            if controlPanel == nil {
                controlPanel = track.soundModule.createControlPanel()
            } else {
                controlPanel!.close()
                controlPanel = nil
            }
        } else {
            track.isSelected = true
        }
    }
    
    // TODO: Find other way of deleting.
    // Double tap causes reaction to single tap feel slow
    override func doubleTap(at pos: CGPoint) {
        SequencingManager.deleteTrack(track)
        iconGroup!.removeIcon(self)
    }
}
