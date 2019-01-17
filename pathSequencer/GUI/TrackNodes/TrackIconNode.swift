//
//  TrackIconNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/16/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

// The track icon visible at the bottom of the screen
// Provides touch interaction
class TrackIconNode: TouchableNode {
    unowned private let track: Track
    weak private var controlPanel: SoundModuleControlsPanelNode?
    weak private var iconGroup: TrackIconGroupNode?

    // Visible nodes
    var label: SKLabelNode!  // Number in the middle
    private var shape: SKSpriteNode!  // Frame
    
    // Required by the super class, not used
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        self.track = track
        super.init()
        
        // Set the track's icon to this
        track.icon = self
        
        // Setup
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
    
    // Changes node's colour if selected/deselected
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
    
    // Response to a single tap within the bounds of this node
    override func singleTap(at pos: CGPoint) {
        if track.isSelected {
            // If selected show synth panel
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
    override func doubleTap(at pos: CGPoint) {
        SequencingManager.deleteTrack(track)
        iconGroup!.removeIcon(self)
    }
}
