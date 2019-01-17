//
//  MenuNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/17/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class MenuNode: SKNode {
    let bgNode: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        bgNode = SKShapeNode(rectOf: CGSize(width: 600, height: 600))
        super.init()
        bgNode.fillColor = SceneManager.scene!.backgroundColor
        bgNode.zPosition = 25
        self.addChild(bgNode)
        
        var button: ButtonInMenu = SaveSceneButtonNode(self)
        button.position.y = 100
        self.addChild(button)
        
        button = BackToMainMenuNode(self)
        self.addChild(button)
        
        button = BackToSceneButtonNode(self)
        button.position.y = -100
        self.addChild(button)
        
        self.alpha = 0
        self.run(SKAction.fadeAlpha(to: 0.9, duration: 0.3))
    }
    
    func close() {
        self.run(SKAction.fadeOut(withDuration: 0.3), completion: {
            self.removeFromParent()
        })
    }
}

class BackToMainMenuNode: ButtonInMenu {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(_ menuNode: MenuNode) {
        super.init(menuNode)
        self.labelNode.text = "Return to main menu"
    }
    
    override func touchUp(at pos: CGPoint) {
        GlobalStorage.gameView!.performSegue(withIdentifier: "goToMainMenu", sender: GlobalStorage.gameView!)
    }
}

class SaveSceneButtonNode: ButtonInMenu {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(_ menuNode: MenuNode) {
        super.init(menuNode)
        self.labelNode.text = "Save current scene"
    }
    
    override func touchUp(at pos: CGPoint) {
        do {
            let fileManager = FileManager.default
            let folderURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let files = try? fileManager.contentsOfDirectory(atPath: folderURL.absoluteString)
            var count: Int
            
            if files == nil {
                count = 0
            } else {
                count = files!.count
            }
            
            let name = "Scene_\(count + 1)"
            SequencingManager.saveToJSON(fileName: name)
            labelNode.text = "Scene saved"
        } catch {
            labelNode.text = "Error while saving scene"
            print("Error while saving scene")
        }
        
        
    }
}

class BackToSceneButtonNode: ButtonInMenu {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(_ menuNode: MenuNode) {
        super.init(menuNode)
        self.labelNode.text = "Close"
    }
    
    override func touchUp(at pos: CGPoint) {
        menuNode.close()
    }
}

class ButtonInMenu: TouchableNode {
    let menuNode: MenuNode!
    let visibleNode: SKShapeNode!
    let labelNode: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ menuNode: MenuNode) {
        self.menuNode = menuNode
        visibleNode = SKShapeNode(rectOf: CGSize(width: 400, height: 50))
        labelNode = SKLabelNode()
        labelNode.verticalAlignmentMode = .center
        super.init()
        
        self.addChild(visibleNode)
        self.addChild(labelNode)
        self.zPosition = 30
    }
}
