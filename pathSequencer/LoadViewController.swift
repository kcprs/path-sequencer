//
//  LoadViewController.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SceneCell"

private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
private let itemHeight: CGFloat  = 100
private let itemsPerRow: CGFloat = 1
private var savedSceneFiles: Array<URL>?

class LoadViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectionStorage.loadView = self
        
        do {
            let fileManager = FileManager.default
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            savedSceneFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
        } catch {
            print("Error while loading saved sequencer files.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if savedSceneFiles != nil && savedSceneFiles!.count != 0 {
            return savedSceneFiles!.count
        } else {
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LoadViewCell
        
        if savedSceneFiles == nil {
            cell.loadSceneButton.setTitle("No saved sessions found", for: .application)
            cell.loadSceneButton.setTitle("No saved sessions found", for: .disabled)
            cell.loadSceneButton.setTitle("No saved sessions found", for: .focused)
            cell.loadSceneButton.setTitle("No saved sessions found", for: .highlighted)
            cell.loadSceneButton.setTitle("No saved sessions found", for: .normal)
            cell.loadSceneButton.setTitle("No saved sessions found", for: .reserved)
            cell.loadSceneButton.setTitle("No saved sessions found", for: .selected)
        } else {
            let url = savedSceneFiles![indexPath.row]
            cell.sceneURL = url
            let filenameWithExt = (url.absoluteString as NSString).lastPathComponent
            let filename = filenameWithExt.components(separatedBy: ".")[0]
            cell.loadSceneButton.setTitle(filename, for: .application)
            cell.loadSceneButton.setTitle(filename, for: .disabled)
            cell.loadSceneButton.setTitle(filename, for: .focused)
            cell.loadSceneButton.setTitle(filename, for: .highlighted)
            cell.loadSceneButton.setTitle(filename, for: .normal)
            cell.loadSceneButton.setTitle(filename, for: .reserved)
            cell.loadSceneButton.setTitle(filename, for: .selected)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// Extension based on Richard Turton & Brody Eller's tutorial:
// https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started
extension LoadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
