//
//  SequencingManagerData.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import Foundation

struct SequencingManagerData: Codable {
    var tempo: Double!
    var tracks: Array<TrackData>!
    
    init() {
        tracks = Array<TrackData>()
    }
}
