//
//  GameViewController.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/1/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene: SKScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalStorage.gameView = self
        
        runScene()
    }
    
    func runScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene")
            if scene != nil  {
                // Set the scale mode to scale to fit the window
                scene!.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene!)
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
