//
//  LoadViewCell.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import UIKit

class LoadViewCell: UICollectionViewCell {
    
    var sceneURL: URL?
    
    @IBOutlet var loadSceneButton: UIButton!
    @IBAction func sceneButtonPressed(_ sender: Any) {
        SelectionStorage.selectedURL = sceneURL
        SelectionStorage.loadSelectedScene()
    }
}
