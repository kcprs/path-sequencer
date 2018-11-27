//
//  UpdateManager.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/27/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class UpdateManager {
    private static var staticSelf: UpdateManager? = nil
    
    // Storing Updatables as AnyObject to avoid issues with protocols
    private static var updatables: Array<AnyObject>? = nil
    
    init() {
        if UpdateManager.staticSelf != nil {
            fatalError("There can only be one GUIUpdateManager")
        }
        UpdateManager.staticSelf = self
        
        UpdateManager.updatables = Array<AnyObject>()
    }
    
    static func updateAll() {
        for target in updatables! {
            (target as! Updatable).update()
        }
    }
    
    static func add(_ updatable: Updatable) {
        updatables?.append(updatable)
    }
    
    static func remove(_ updatable: Updatable) {
        let index = updatables?.indexByReference(updatable as AnyObject)
        if index != nil {
            updatables?.remove(at: index!)
        }
    }
}

extension Array where Element: AnyObject {
    func indexByReference(_ object: AnyObject) -> Int? {
        for i in 0..<self.count {
            if self[i] === object {
                return i
            }
        }
        
        return nil
    }
}
