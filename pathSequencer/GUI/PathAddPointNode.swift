//
//  PathAddPointNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/21/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PathAddPointNode: NodeOnSequencerPath {
    let beforePoint: PathPointNode!
    let afterPoint: PathPointNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(beforePoint: PathPointNode, afterPoint: PathPointNode) {
        self.beforePoint = beforePoint
        self.afterPoint = afterPoint
        
        super.init(parentPath: beforePoint.parentPath)
        visibleNode = SKShapeNode(circleOfRadius: 10)
        visibleNode.strokeColor = .gray
        
        self.zPosition = 1
    }
    
    override func touchDown(at pos: CGPoint) {
        if self.contains(pos) {
            let newPoint = parentPath.addNewPoint(from: self)
            newPoint.touchDown(at: pos)
        }
    }
    
    func updatePosition() {
        let x = (beforePoint.position.x + afterPoint.position.x) / 2
        let y = (beforePoint.position.y + afterPoint.position.y) / 2
        self.position = CGPoint(x: x, y: y)
    }
}
