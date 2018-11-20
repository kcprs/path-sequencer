//
//  PathIconGroupNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class PathIconGroupNode: SKNode {
    private var icons: Array<PathIconNode>!
    private var width: CGFloat = 0
    private var addNewButton: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        icons = Array<PathIconNode>()
        addNewButton = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        width = 50
        
        super.init()
        
        addNewButton.fillColor = .magenta
        self.addChild(addNewButton)
        
        self.isUserInteractionEnabled = true
    }
    
    func addIcon(_ icon: PathIconNode) {
        icons.append(icon)
        icon.position = CGPoint(x: width - 50, y: 0)
        self.addChild(icon)
        width += icon.getWidth()
        
        updatePosition()
    }
    
    private func updatePosition() {
        self.run(SKAction.move(to: CGPoint(x: -width / 2, y: self.position.y), duration: 0.5))
        addNewButton.run(SKAction.move(to: CGPoint(x: width - 25, y: 0), duration: 0.25))
    }
    
    private func createNewPath() {
        let gameScene = scene as! GameScene
        gameScene.addPathWithCursor()
    }
    
    private func touchDown(atPoint pos: CGPoint) {
        if self.scene!.nodes(at: pos).contains(addNewButton) {
            createNewPath()
        }
    }
    
    private func touchMoved(toPoint pos: CGPoint) {

    }
    
    private func touchUp(atPoint pos: CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.scene!)) }
    }
}
