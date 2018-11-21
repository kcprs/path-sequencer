//
//  TrackIconGroupNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class TrackIconGroupNode: SKNode {
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
        self.addChild(addNewTrackButton)
        
        self.isUserInteractionEnabled = true
    }
    
    private func addIcon(_ icon: TrackIconNode) {
        icons.append(icon)
        icon.position = CGPoint(x: width - 50, y: 0)
        self.addChild(icon)
        width += icon.getWidth()
        
        updatePosition()
    }
    
    private func updatePosition() {
        self.run(SKAction.move(to: CGPoint(x: -width / 2, y: self.position.y), duration: 0.5))
        addNewTrackButton.run(SKAction.move(to: CGPoint(x: width - 25, y: 0), duration: 0.25))
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        
    }
    
    private func touchMoved(toPoint pos: CGPoint) {

    }
    
    private func touchUp(atPoint pos: CGPoint) {
        if self.scene!.nodes(at: pos).contains(addNewTrackButton) {
            let track = TrackManager.addNewTrack()
            addIcon(TrackIconNode(for: track))  // TODO
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
}
