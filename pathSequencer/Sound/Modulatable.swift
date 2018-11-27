//
//  Modulatable.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/27/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

protocol Modulatable: Updatable {
    var modAmount: Double! { get set }
    var modSource: ModulationSource { get }
}
