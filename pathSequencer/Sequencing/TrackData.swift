//
//  TrackData.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import Foundation
struct TrackData: Codable {
    var noteDuration: Double!
    var soundModuleType: String!
    var soundModuleData: [String: Double]!
    var effectsModuleData: EffectsModuleData!
    var pathPoints: Array<PathPointNodeData>!
    
    init() {
        pathPoints = Array<PathPointNodeData>()
    }
}
