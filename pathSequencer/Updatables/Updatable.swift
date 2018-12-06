//
//  Updatable.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/27/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

protocol Updatable: AnyObject {
    var isActive: Bool { get set }
    func update()
    func setUpdatesActive(_ active: Bool)
}

extension Updatable {
    func setUpdatesActive(_ active: Bool) {
        if active && !self.isActive {
            UpdateManager.add(self)
        } else {
            UpdateManager.remove(self)
        }
    }
}
