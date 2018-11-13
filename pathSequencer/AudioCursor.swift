//
//  AudioCursor.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class AudioCursor {
    
    internal var audioManager : AudioManager!
    var output : AKMixer!
    private var oscillator : AKOscillator!
    private var ampEnvelope : AKAmplitudeEnvelope!
    private var sprite : SKSpriteNode!
    private var speed : CGFloat = 100
    private var moveProgress : CGFloat = 0
    private var fromNode : SKNode!
    private var toNode : SKNode!
    private let parentNode : SKNode!
    private let parentCursorPath : CursorPath!
    
    init(audioManager: AudioManager, parentNode: SKNode, path: CursorPath) {
        self.audioManager = audioManager
        self.parentNode = parentNode
        self.parentCursorPath = path
        
        sprite = SKSpriteNode(imageNamed: "square.png")
        sprite.setScale(0.05)
        parentNode.addChild(sprite)
        
        fromNode = parentCursorPath.pathNodes[0]
        toNode = parentCursorPath.pathNodes[1]
        
        oscillator = AKOscillator()
        oscillator.rampDuration = 0

        ampEnvelope = AKAmplitudeEnvelope(oscillator)
        
        output = AKMixer(ampEnvelope)

        audioManager.addAudioCursor(self)
    }
    
    func start() {
        oscillator.start()
        output.start()
        
        ampEnvelope.attackDuration = 0.01
        ampEnvelope.decayDuration = 0.1
        ampEnvelope.sustainLevel = 0
        ampEnvelope.releaseDuration = 0.1
    }
    
    func updatePosition() {
        sprite.removeAction(forKey: "move")
        
        let targetDifferenceX = toNode.position.x - fromNode.position.x
        let targetDifferenceY = toNode.position.y - fromNode.position.y
        
        let newPosition = CGPoint(x: fromNode.position.x + moveProgress * targetDifferenceX, y: fromNode.position.y + moveProgress * targetDifferenceY)
        
        let path = CGMutablePath()
        path.move(to: newPosition)
        path.addLine(to: toNode.position)
        
        sprite.run(SKAction.follow(path, asOffset: false, orientToPath: true, speed: speed), withKey: "move", optionalCompletion: circleReached)
    }
    
    private func circleReached() {
        triggerSound(atNode: toNode)
        
        sprite.removeAction(forKey: "move")
        
        fromNode = toNode
        let index = (parentCursorPath.pathNodes.index(of: toNode as! SKSpriteNode)! + 1) % parentCursorPath.pathNodes.count
        toNode = parentCursorPath.pathNodes[index]
        
        let path = CGMutablePath()
        path.move(to: fromNode.position)
        path.addLine(to: toNode.position)
        
        sprite.run(SKAction.follow(path, asOffset: false, orientToPath: true, speed: speed), withKey: "move", optionalCompletion: circleReached)
    }
    
    func saveProgress() {
        // Calculate progress between fromNode and toNode. To avoid square root operations, use proportion of difference between x or y coordinates (whichever is greater - for better accuracy)
        
        // TODO: Make sure progress uses X for both or Y for both and not a mix of the two
        let targetDifferenceX = toNode.position.x - fromNode.position.x
        let targetDifferenceY = toNode.position.y - fromNode.position.y
        let currentDifferenceX = sprite.position.x - fromNode.position.x
        let currentDifferenceY = sprite.position.y - fromNode.position.y
        moveProgress = max(abs(currentDifferenceX), abs(currentDifferenceY))/max(abs(targetDifferenceX), abs(targetDifferenceY))
    }
    
    private func triggerSound(atNode node: SKNode) {
        oscillator.frequency = parentCursorPath.getFreqAtNode(node: node)
        ampEnvelope.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001, execute: {self.ampEnvelope.stop()})
    }
    
    func isNextTo(node: SKNode) -> Bool {
        if node is SKSpriteNode && (node == fromNode || node == toNode) {
            return true
        }
        
        return false
    }
    
    
}
