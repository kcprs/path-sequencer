//
//  CursorNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class CursorNode: SKNode, ModulationSource {
    private var visibleNode: SKShapeNode!
    private var cursorSpeed: CGFloat = 100
    private var moveProgress: CGFloat = 0
    private var isInTempoMode = true
    unowned private let parentPath: SequencerPath
    unowned private var fromNode: PathPointNode
    unowned private var toNode: PathPointNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(onPath parentPath: SequencerPath) {
        self.parentPath = parentPath
        self.fromNode = parentPath.getStartNode()
        self.toNode = parentPath.getNextTarget(fromNode: fromNode)
        
        super.init()
        
        parentPath.addCursor(self)
        
        visibleNode = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
        self.addChild(visibleNode)
        
        updatePosition()
    }
    
    deinit {
        print("CursorNode deinit done")
    }
    
    func stop() {
        self.removeAllActions()
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
        if !PlaybackManager.isPlaying {
            return
        }
        
        let path = CGMutablePath()
        path.move(to: self.position)
        path.addLine(to: toNode.position)
        
        saveProgress()
        
        if isInTempoMode {
            let noteDuration = CGFloat(PlaybackManager.getNoteTime(parentPath.noteDuration))
            let duration = TimeInterval((1 - moveProgress) * noteDuration)
            self.run(SKAction.follow(path, asOffset: false, orientToPath: true, duration: duration), withKey: "move", optionalCompletion: targetReached)
        } else {
            self.run(SKAction.follow(path, asOffset: false, orientToPath: true, speed: cursorSpeed), withKey: "move", optionalCompletion: targetReached)
        }
    }
    
    func updateFromToNodes(basedOn node: PathAddPointNode) {
        if fromNode == node.beforePoint {
            saveProgress()
            
            if moveProgress < 0.5 {
                toNode = parentPath.getNextTarget(fromNode: fromNode)
            } else {
                fromNode = parentPath.getPreviousTarget(toNode: toNode)
            }
            
            saveProgress()
            updatePosition()
            resumeMovement()
        }
    }
    
    func updateFromToNodes(basedOn node: PathPointNode) {
        var changesMade = false
        if node == fromNode {
            fromNode = parentPath.getPreviousTarget(toNode: toNode)
            changesMade = true
        }
        
        if node == toNode {
            toNode = parentPath.getNextTarget(fromNode: fromNode)
            changesMade = true
        }
        
        if changesMade {
            saveProgress()
            updatePosition()
            resumeMovement()
        }
    }
    
    func getModulationValue() -> Double {
        return SceneManager.pitchGrid!.getModAt(node: self)
    }
    
    private func targetReached() {
        let frequency = SceneManager.pitchGrid!.getFreqAt(node: self)
        parentPath.track.soundModule.trigger(freq: frequency)
        
        fromNode = toNode
        toNode = parentPath.getNextTarget(fromNode: fromNode)
        
        resumeMovement()
    }
    
    func isNextTo(node: PathPointNode) -> Bool {
        if node == fromNode || node == toNode {
            return true
        }
        return false
    }
}

// Adapted from example by Alessandro Ornano
// https://stackoverflow.com/questions/29627613/skaction-completion-handlers-usage-in-swift
extension SKNode
{
    func run(_ action: SKAction!, withKey: String!, optionalCompletion: Optional<() -> Void>)
    {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([action, completionAction])
            run(compositeAction, withKey: withKey)
        }
        else
        {
            run(action, withKey: withKey)
        }
    }
}
