//
//  MenuViewController.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = GlobalStorage.init()
        
        print("Loading json")
        do {
            let url = Bundle.main.url(forResource: "demoScene", withExtension: ".json")
            let jsonData = try Data(contentsOf: url!)
            let data = try JSONDecoder().decode(SequencingManagerData.self, from: jsonData)
            
            let fileManager = FileManager.default
            let folderURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = folderURL.appendingPathComponent("demoScene.json")
            print("Saving sequencer data to \(fileURL.absoluteString)")
            let jsonDataWrite = try JSONEncoder().encode(data)
            try jsonDataWrite.write(to: fileURL)
        } catch {
            print("Error while saving sequencer to JSON")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openNewScene(_ sender: Any) {
        GlobalStorage.selectedURL = nil
        performSegue(withIdentifier: "openNewScene", sender: self)
    }
    
    @IBAction func goToLoadView(_ sender: Any) {
        GlobalStorage.selectedURL = nil
        performSegue(withIdentifier: "goToLoadView", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class GlobalStorage {
    static var selectedURL: URL?
    static var loadView: LoadViewController?
    static var gameView: GameViewController?
    
    static func loadSelectedScene() {
        if loadView != nil {
            loadView!.performSegue(withIdentifier: "loadSelectedScene", sender: loadView)
            loadView = nil
        }
    }
}
