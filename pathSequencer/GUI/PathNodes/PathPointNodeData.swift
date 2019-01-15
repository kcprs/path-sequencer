//
//  PathPointNodeData.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import Foundation

struct PathPointNodeData: Codable {
    var x: Double!
    var y: Double!
    
    init(_ node: PathPointNode) {
        self.x = Double(node.position.x)
        self.y = Double(node.position.y)
    }
}
