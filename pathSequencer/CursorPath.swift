//
//  CursorPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class CursorPath: SKNode {
    private var pathNode: SKShapeNode!
    private var pitchGrid: PitchGrid!
    private var audioCursor: AudioCursor!  // TODO: Have an array of these?
    private var pathPointNodes: Array<PathPointNode>!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nodeCount: Int) {
        super.init()
        pathPointNodes = Array<PathPointNode>()
        
        pathNode = SKShapeNode()
        pathNode.lineWidth = 1
        pathNode.strokeColor = .white
        self.addChild(pathNode)
        
        for _ in 1...nodeCount {
            let pointNode = PathPointNode()
            addPoint(pointNode)
        }
    }
    
    func assignPitchGrid(_ pitchGrid: PitchGrid) {
        self.pitchGrid = pitchGrid
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

        if audioCursor.isNextTo(node: node) {
            audioCursor.updatePosition()
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
    
    func getFreqAtNode(node: SKNode) -> Double {
        return pitchGrid.getFreqAt(node: node)
    }
    
    func addCursor(_ cursor: AudioCursor) {
        audioCursor = cursor
        self.addChild(cursor)
    }
    
    func addPoint(_ point: PathPointNode) {
        self.addChild(point)
        pathPointNodes.append(point)
        point.setParentPath(self)
    }
    
    func saveProgress(node: PathPointNode) {
        if audioCursor.isNextTo(node: node) {
            audioCursor.saveProgress()
        }
    }
    
    func resumeMovement() {
        audioCursor.resumeMovement()
    }
    
    func getNextTarget(fromNode: PathPointNode) -> PathPointNode {
        let index = (pathPointNodes.index(of: fromNode)! + 1) % pathPointNodes.count
        return pathPointNodes[index]
    }
    
    func getStartNode() -> PathPointNode {
        return pathPointNodes[0]
    }
    
    func getSynthModule() -> SynthModule {
        return audioCursor.getSynthModule()
    }
}
