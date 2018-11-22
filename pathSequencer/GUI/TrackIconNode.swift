//
//  TrackIconNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class TrackIconNode: TouchableNode {
    private var track: Track!
    private var controlPanel: SoundModuleControlPanelNode?
    private var label: SKLabelNode!
    var iconGroup: TrackIconGroupNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        super.init()
        
        self.track = track
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
    
    override func doubleTap(at pos: CGPoint) {
        TrackManager.delete(track)
        iconGroup!.removeIcon(self)
    }
}
