//
//  ScrollSelectorNode.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 12/4/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit

class ScrollSelectorNode<T: Hashable>: TouchableNode {
    unowned private let parameter: DiscreteParameter<T>
    
    private let cropNode: SKCropNode!
    private let maskNode: SKShapeNode!
    private let frameNode: SKShapeNode!
    private let scrollRoot: SKNode!
    private let labels: Array<SKLabelNode>!
    private var touchedPoint: CGPoint?
    private let yGap: CGFloat = 30
    private var valueIndex: Int = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parameter: DiscreteParameter<T>) {
        self.parameter = parameter
        cropNode = SKCropNode()
        maskNode = SKShapeNode(rectOf: CGSize(width: 100, height: yGap))
        frameNode = SKShapeNode(rectOf: CGSize(width: 100, height: yGap))
        scrollRoot = SKNode()
        labels = Array<SKLabelNode>()
        super.init()
        
        maskNode.fillColor = .black
        
        var labelPos: CGFloat = 0
        for value in parameter.values {
            let label = SKLabelNode(text: parameter.getValueLabel(value: value))
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: labelPos)
            labels.append(label)

            labelPos += yGap
        }
        scrollRoot.constraints = [SKConstraint.positionY(SKRange(lowerLimit: -labelPos + yGap, upperLimit: 0))]
        
        cropNode.maskNode = maskNode
        cropNode.addChild(scrollRoot)
        
        self.addChild(cropNode)
        self.addChild(frameNode)
        
        valueIndex = self.parameter.getCurrentIndex()!
        scrollRoot.addChild(labels[valueIndex])
        snapToClosest()
    }
    
    private func snapToClosest() {
        scrollRoot.removeAllActions()
        let action = SKAction.move(to: CGPoint(x: 0, y: CGFloat(-valueIndex) * yGap), duration: 0.2)
        action.timingMode = .easeOut
        scrollRoot.run(action)
    }
    
    private func updateValue() {
        let oldValueIndex = valueIndex
        valueIndex = -Int((scrollRoot.position.y / yGap).rounded())
        valueIndex = min(max(valueIndex, 0), parameter.valueCount - 1)
        
        if valueIndex != oldValueIndex {
            parameter.setValue(index: valueIndex)
        }
    }
    
    private func addAllLabelNodes() {
        for node in labels {
            if !scrollRoot.children.contains(node) {
                scrollRoot.addChild(node)
            }
        }
    }
    
    private func removeNonSelected() {
        for i in 0..<labels.count {
            if i != valueIndex {
                labels[i].removeFromParent()
            }
        }
    }
    
    override func touchDown(at pos: CGPoint) {
        touchedPoint = pos
        addAllLabelNodes()
    }
    
    override func touchMoved(to pos: CGPoint) {
        if touchedPoint != nil {
            scrollRoot.position.y = scrollRoot.position.y + pos.y - touchedPoint!.y
        }
        touchedPoint = pos
        updateValue()
    }
    
    override func touchUp(at pos: CGPoint) {
        touchedPoint = nil
        snapToClosest()
        removeNonSelected()
    }
}
