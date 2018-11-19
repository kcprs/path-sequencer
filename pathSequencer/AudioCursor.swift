//
//  AudioCursor.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class AudioCursor: SKNode {
    private var visibleNode: SKShapeNode!
    private var cursorSpeed: CGFloat = 100
    private var moveProgress: CGFloat = 0
    private var synthModule: SynthModule! // TODO: move synthModule to CursorPath
    private var parentPath: CursorPath!
    private var fromNode: PathPointNode!
    private var toNode: PathPointNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(onPath parentPath: CursorPath) {
        super.init()
        self.parentPath = parentPath
        parentPath.addCursor(self)
        fromNode = parentPath.getStartNode()
        toNode = parentPath.getNextTarget(fromNode: fromNode)
        synthModule = SynthModule()
        
        visibleNode = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
        self.addChild(visibleNode)
        
        updatePosition()
    }
    
    func startAudio() {
        synthModule.start()
    }
    
    func saveProgress() {
        // Calculate progress between fromNode and toNode. To avoid square root operations, use proportion of difference between x or y coordinates (whichever is greater - for better accuracy)
        
        // TODO: Make sure progress uses X for both or Y for both and not a mix of the two
        let targetDifferenceX = toNode.position.x - fromNode.position.x
        let targetDifferenceY = toNode.position.y - fromNode.position.y
        let currentDifferenceX = self.position.x - fromNode.position.x
        let currentDifferenceY = self.position.y - fromNode.position.y
        moveProgress = max(abs(currentDifferenceX), abs(currentDifferenceY))/max(abs(targetDifferenceX), abs(targetDifferenceY))
    }
    
    func updatePosition() {
        self.removeAction(forKey: "move")

        let targetDifferenceX = toNode.position.x - fromNode.position.x
        let targetDifferenceY = toNode.position.y - fromNode.position.y

        let newPosition = CGPoint(x: fromNode.position.x + moveProgress * targetDifferenceX, y: fromNode.position.y + moveProgress * targetDifferenceY)
        
        self.position = newPosition
    }
    
    func resumeMovement() {
        let path = CGMutablePath()
        path.move(to: self.position)
        path.addLine(to: toNode.position)
        
        self.run(SKAction.follow(path, asOffset: false, orientToPath: true, speed: cursorSpeed), withKey: "move", optionalCompletion: targetReached)
    }
    
    private func targetReached() {
        triggerSound(atNode: toNode)
        
        fromNode = toNode
        toNode = parentPath.getNextTarget(fromNode: fromNode)
        
        let path = CGMutablePath()
        path.move(to: fromNode.position)
        path.addLine(to: toNode.position)
        
        self.run(SKAction.follow(path, asOffset: false, orientToPath: true, speed: cursorSpeed), withKey: "move", optionalCompletion: targetReached)
    }
    
    private func triggerSound(atNode node: PathPointNode) {
        let frequency = parentPath.getFreqAtNode(node: node)
        synthModule.trigger(freq: frequency)
    }
    
    func connectAudio(to inputNode: AKInput) {
        synthModule.connect(to: inputNode)
    }
    
    func isNextTo(node: PathPointNode) -> Bool {
        if node == fromNode || node == toNode {
            return true
        }
        
        return false
    }
    
    func getSynthModule() -> SynthModule {
        return synthModule
    }
}
