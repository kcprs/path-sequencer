//
//  TrackIconGroupNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class TrackIconGroupNode: TouchableNode {
    private let trackManager: TrackManager!
    private var icons: Array<TrackIconNode>!
    private var width: CGFloat = 0
    private var addNewTrackButton: SKShapeNode! // TODO: Make into a SpriteNode, add custom graphic
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ manager: TrackManager) {
        self.trackManager = manager
        icons = Array<TrackIconNode>()
        addNewTrackButton = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        width = 50 // TODO: get from addNewTrackButton when it's changed into a SpriteNode
        
        super.init()
        
        addNewTrackButton.fillColor = .gray
        addNewTrackButton.zPosition = 1
        self.addChild(addNewTrackButton)

    }
    
    private func addIcon(_ icon: TrackIconNode) {
        icons.append(icon)
        icon.position = CGPoint(x: width - 50, y: 0)
        self.addChild(icon)
        icon.iconGroup = self
        icon.alpha = 0
        icon.run(SKAction.fadeIn(withDuration: 0.3))
        width += icon.getWidth()
        
        updatePosition()
    }
    
    func removeIcon(_ icon: TrackIconNode) {
        let index = icons.index(of: icon)
        icons.remove(at: index!)
        width -= icon.getWidth()
        icon.run(SKAction.fadeOut(withDuration: 0.3), completion: icon.removeFromParent)
        
        updatePosition()
    }
    
    private func updatePosition() {
        let selfAction = SKAction.move(to: CGPoint(x: -width / 2, y: self.position.y), duration: 0.5)
        selfAction.timingMode = .easeOut
        self.run(selfAction)
        
        let buttonAction = SKAction.move(to: CGPoint(x: width - 25, y: 0), duration: 0.3)
        buttonAction.timingMode = .easeOut
        addNewTrackButton.run(buttonAction)
    }
    
    override func touchUp(at pos: CGPoint) {
        if self.scene!.nodes(at: pos).contains(addNewTrackButton) {
            let track = TrackManager.addNewTrack()
            addIcon(TrackIconNode(for: track))
        }
    }
}
