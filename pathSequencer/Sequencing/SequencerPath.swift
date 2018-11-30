//
//  SequencerPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SequencerPath: SKNode {
    unowned let track: Track
    private var pathNode: SKShapeNode!
    var cursor: CursorNode!
    private var pathPointNodes: Array<PathPointNode>!
    private var pathAddPointNodes: Array<PathAddPointNode>!
    var centre: CGPoint {
        let x = self.pathNode.frame.midX
        let y = self.pathNode.frame.midY
        return CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        self.track = track
        super.init()
        pathPointNodes = Array<PathPointNode>()
        pathAddPointNodes = Array<PathAddPointNode>()
        
        pathNode = SKShapeNode()
        self.addChild(pathNode)
        
        for _ in 1...3 {
            let point = PathPointNode(parentPath: self)
            addPointNode(point)
        }
        
        recomputeAddPointNodes()
        
        let scene = SceneManager.scene!
        scene.addChild(self)
        scatterRandomly(centre: scene.camera!.position, range: scene.size)
        
        let cursor = CursorNode(onPath: self)
        cursor.resumeMovement()
        
        self.alpha = 0
        self.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    deinit {
        print("Sequencer path deinit done")
    }
    
    private func addPointNode(_ node: NodeOnSequencerPath, index: Int = -1) {
        self.addChild(node)
        
        if node is PathPointNode {
            if index < 0 {
                pathPointNodes.append(node as! PathPointNode)
            } else {
                pathPointNodes.insert(node as! PathPointNode, at: index)
            }
        } else if node is PathAddPointNode {
            if index < 0 {
                pathAddPointNodes.append(node as! PathAddPointNode)
            } else {
                pathAddPointNodes.insert(node as! PathAddPointNode, at: index)
            }
            (node as! PathAddPointNode).updatePosition()
        }
        
        node.updateSelection()
    }
    
    func addNewPoint(from node: PathAddPointNode) -> PathPointNode {
        let point = PathPointNode(parentPath: self)
        point.position = node.position
        let index = pathPointNodes.index(of: node.afterPoint)
        
        self.addPointNode(point, index: index!)
        
        updatePathNode()
        recomputeAddPointNodes()
        cursor.updateFromToNodes(basedOn: node)
        
        return point
    }
    
    func removePoint(_ node: PathPointNode) {
        if pathPointNodes.count > 3 {
            let index = pathPointNodes.index(of: node)
            pathPointNodes.remove(at: index!)
            node.removeFromParent()
            
            updatePathNode()
            recomputeAddPointNodes()
            cursor.updateFromToNodes(basedOn: node)
        }
    }
    
    private func recomputeAddPointNodes() {
        for node in pathAddPointNodes {
            node.removeFromParent()
        }
        
        pathAddPointNodes = Array<PathAddPointNode>()
        
        let count = pathPointNodes.count
        for i in 0..<count {
            let before = pathPointNodes[i]
            let after = pathPointNodes[(i + 1) % count]
            let addPoint = PathAddPointNode(beforePoint: before, afterPoint: after)
            
            addPointNode(addPoint)
        }
    }
    
    private func updatePathNode() {
        var pathPoints = Array<CGPoint>()
        for pointNode in pathPointNodes {
            pathPoints.append(pointNode.position)
        }
        
        let path = CGMutablePath()
        path.addLines(between: pathPoints)
        path.addLine(to: pathPointNodes[0].position)
        
        pathNode.path = path
    }
    
    func updateAfterNodeMoved(node: PathPointNode) {
        updatePathNode()

        if cursor.isNextTo(node: node) {
            cursor.updatePosition()
        }
        
        for addPointNode in pathAddPointNodes {
            if node == addPointNode.beforePoint || node == addPointNode.afterPoint {
                addPointNode.updatePosition()
            }
        }
    }
    
    func updateSelection() {
        if track.isSelected {
            self.pathNode.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        } else {
            self.pathNode.run(SKAction.fadeAlpha(to: 0.2, duration: 0.5))
        }
        
        for pointNode in pathPointNodes {
            pointNode.updateSelection()
        }
        
        for addPointNode in pathAddPointNodes {
            addPointNode.updateSelection()
        }
    }
    
    func scatterRandomly(xMin: CGFloat, yMin: CGFloat, xMax: CGFloat, yMax: CGFloat) {
        for pointNode in pathPointNodes {
            let x = xMin + CGFloat(drand48()) * (xMax - xMin)
            let y = yMin + CGFloat(drand48()) * (yMax - yMin)

            let newPosition = SceneManager.scene!.convert(CGPoint(x: x, y: y), to: pointNode.parent!)
            
            pointNode.position = newPosition
        }
        
        updatePathNode()
        recomputeAddPointNodes()
    }
    
    func scatterRandomly(centre: CGPoint, range: CGSize) {
        scatterRandomly(xMin: centre.x - range.width / 2, yMin: centre.y - range.height / 2, xMax: centre.x + range.width / 2, yMax: centre.y + range.height / 2)
    }
    
    func addCursor(_ cursor: CursorNode) {
        self.cursor = cursor
        self.addChild(cursor)
    }
    
    func saveProgress(node: PathPointNode) {
        if cursor.isNextTo(node: node) {
            cursor.saveProgress()
        }
    }
    
    func resumeMovement() {
        cursor.resumeMovement()
    }
    
    func getNextTarget(fromNode: PathPointNode) -> PathPointNode {
        let index = (pathPointNodes.index(of: fromNode)! + 1) % pathPointNodes.count
        return pathPointNodes[index]
    }
    
    func getPreviousTarget(toNode: PathPointNode) -> PathPointNode {
        var index = (pathPointNodes.index(of: toNode)! - 1) % pathPointNodes.count
        
        // Account for the fact that in swift mod of negative numbers is negative
        if index < 0 {
            index += pathPointNodes.count
        }
        
        return pathPointNodes[index]
    }
    
    func getStartNode() -> PathPointNode {
        return pathPointNodes[0]
    }
    
    func delete() {
        self.removeFromParent()
//        self.run(SKAction.fadeOut(withDuration: 0.5), completion: self.removeFromParent)
    }
}
