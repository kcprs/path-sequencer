//
//  CursorNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class CursorNode: SKNode, ModulationSource, Updatable {
    unowned private let parentPath: SequencerPath
    unowned private var fromNode: PathPointNode
    unowned private var toNode: PathPointNode
    
    private var cursorSpeed: CGFloat = 100
    private var moveProgress: CGFloat = 0
    private var isInTempoMode = true
    var isActive: Bool = false
    
    // Graphics
    private var visibleNode: SKShapeNode!
    
    
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

    func updatePosition() {
        let targetDifferenceX = toNode.position.x - fromNode.position.x
        let targetDifferenceY = toNode.position.y - fromNode.position.y

        let newPosition = CGPoint(x: fromNode.position.x + moveProgress * targetDifferenceX, y: fromNode.position.y + moveProgress * targetDifferenceY)

        self.position = newPosition
    }

    func updateFromToNodes(basedOn node: PathAddPointNode) {
        if fromNode == node.beforePoint {
            if moveProgress < 0.5 {
                toNode = parentPath.getNextTarget(fromNode: fromNode)
            } else {
                fromNode = parentPath.getPreviousTarget(toNode: toNode)
            }
            
            update()
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
            update()
        }
    }

    func getModulationValue() -> Double {
        return PitchManager.getModAt(node: self)
    }

    func isNextTo(node: PathPointNode) -> Bool {
        if node == fromNode || node == toNode {
            return true
        }
        return false
    }
    
    func update() {       
        let loopProgress = parentPath.track.getLoopProgress()
        
        fromNode = parentPath.pathPointNodes[loopProgress.0]
        toNode = parentPath.getNextTarget(fromNode: fromNode)
        moveProgress = CGFloat(loopProgress.1)
        
        updatePosition()
    }
}
