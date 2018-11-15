//
//  CursorPath.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class CursorPath {
    var pathNodes : Array<SKSpriteNode> = []
    private let parentNode : SKNode!
    private var pathNode : SKShapeNode!  // TODO: Make this into separate class
    private let pitchGrid : PitchGrid!
    
    init(nodeCount: Int, parentNode: SKNode, pitchGrid: PitchGrid) {
        self.parentNode = parentNode
        self.pitchGrid = pitchGrid
        
        for _ in 1...nodeCount {
            let node = SKSpriteNode(imageNamed: "circle.png")
            node.setScale(0.05)
            parentNode.addChild(node)
            pathNodes.append(node)
        }
        
        pathNode = SKShapeNode()
        pathNode.lineWidth = 1
        pathNode.strokeColor = .white
        parentNode.addChild(pathNode)
    }
    
    func update() {
        var pathPoints = Array<CGPoint>()
        for point in pathNodes {
            pathPoints.append(point.position)
        }
        
        let path = CGMutablePath()
        path.addLines(between: pathPoints)
        path.addLine(to: pathNodes[0].position)
        
        pathNode.path = path
    }
    
    func scatterRandomly(xMin: CGFloat, yMin: CGFloat, xMax: CGFloat, yMax: CGFloat) {
        for node in pathNodes {
            let x = xMin + CGFloat(drand48()) * (xMax - xMin)
            let y = yMin + CGFloat(drand48()) * (yMax - yMin)
            
            node.position = CGPoint(x: x, y: y)
        }
        
        update()
    }
    
    func scatterRandomly(centre: CGPoint, range: CGSize) {
        scatterRandomly(xMin: centre.x - range.width / 2, yMin: centre.y - range.height / 2, xMax: centre.x + range.width / 2, yMax: centre.y + range.height / 2)
    }
    
    func contains(_ node: SKNode) -> Bool {
        if node is SKSpriteNode && pathNodes.contains(node as! SKSpriteNode) {
            return true
        }
        return false
    }
    
    func getFreqAtNode(node: SKNode) -> Double {
        return pitchGrid.getFreqAt(yPos: node.position.y)
    }
}
