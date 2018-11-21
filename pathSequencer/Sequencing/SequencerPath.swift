//
//  SequencerPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class SequencerPath: SKNode {
    let track: Track!
    private var pathNode: SKShapeNode!
    private var cursor: CursorNode!  // TODO: Have an array of these?
    private var pathPointNodes: Array<PathPointNode>!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for track: Track) {
        self.track = track
        super.init()
        pathPointNodes = Array<PathPointNode>()
        
        pathNode = SKShapeNode()
        pathNode.lineWidth = 1
        pathNode.strokeColor = .white
        self.addChild(pathNode)
        
        for _ in 1...3 {
            let pointNode = PathPointNode()
            addPoint(pointNode)
        }
        
        let scene = SceneManager.scene!
        scene.addChild(self)
        scatterRandomly(centre: scene.camera!.position, range: scene.size)
        
        let cursor = CursorNode(onPath: self)
        cursor.resumeMovement()
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
    
    func update(node: PathPointNode) {
        updatePathNode()

        if cursor.isNextTo(node: node) {
            cursor.updatePosition()
        }
    }
    
    func scatterRandomly(xMin: CGFloat, yMin: CGFloat, xMax: CGFloat, yMax: CGFloat) {
        for pointNode in pathPointNodes {
            let x = xMin + CGFloat(drand48()) * (xMax - xMin)
            let y = yMin + CGFloat(drand48()) * (yMax - yMin)

            let newPosition = pointNode.scene?.convert(CGPoint(x: x, y: y), to: pointNode.parent!)
            
            pointNode.position = newPosition!
        }
        
        updatePathNode()
    }
    
    func scatterRandomly(centre: CGPoint, range: CGSize) {
        scatterRandomly(xMin: centre.x - range.width / 2, yMin: centre.y - range.height / 2, xMax: centre.x + range.width / 2, yMax: centre.y + range.height / 2)
    }
    
    func addCursor(_ cursor: CursorNode) {
        self.cursor = cursor
        self.addChild(cursor)
    }
    
    func addPoint(_ point: PathPointNode) {
        self.addChild(point)
        point.zPosition = 1  // Make sure the point is above other elements for touch accessibility
        pathPointNodes.append(point)
        point.setParentPath(self)
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
    
    func getStartNode() -> PathPointNode {
        return pathPointNodes[0]
    }
}
