//
//  LoadHeaderView.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/17/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import UIKit

class LoadHeaderView: UICollectionReusableView {
    
    @IBAction func goBackToMainMenu(_ sender: Any) {
        GlobalStorage.loadView!.performSegue(withIdentifier: "goBackToMainMenu", sender: GlobalStorage.loadView!)
    }
}
