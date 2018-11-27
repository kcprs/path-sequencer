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
    weak private var controlPanel: SoundModuleControlPanelNode?
    private var label: SKLabelNode!
    var iconGroup: TrackIconGroupNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        self.track = track
        
        super.init()
        
        track.icon = self
        
        label = SKLabelNode(text: "TrackIcon")
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .left
        self.addChild(label)
        
        self.updateSelection()
    }
    
    func getWidth() -> CGFloat {
        return label.frame.width
    }
    
    func updateSelection() {
        if track.isSelected {
            label.fontColor = .orange
        } else {
            label.fontColor = .white
        }
    }
    
    override func singleTap(at pos: CGPoint) {
        if track.isSelected {
            if controlPanel == nil {
                controlPanel = SoundModuleControlPanelNode(for: track.soundModule)
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
        TrackManager.delete(track)
        iconGroup!.removeIcon(self)
    }
}
