//
//  CreaturePath.swift
//  iOsAssignment
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class CreaturePath {
    var pathNodes : Array<SKSpriteNode> = []
    private let parentNode : SKNode!
    private var pathNode : SKShapeNode!
    
    init(nodeCount: Int, parentNode: SKNode) {
        self.parentNode = parentNode
        
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
    
    func scatterRandomly(xBound: CGFloat, yBound: CGFloat) {
        for node in pathNodes {
            let x = CGFloat(drand48() - 0.5) * xBound
            let y = CGFloat(drand48() - 0.5) * yBound
            
            node.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0))
        }
    }
    
    func contains(_ node: SKNode) -> Bool {
        if node is SKSpriteNode && pathNodes.contains(node as! SKSpriteNode) {
            return true
        }
        return false
    }
}
