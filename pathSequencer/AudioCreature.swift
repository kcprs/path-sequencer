//
//  AudioCreature.swift
//  iOsAssignment
//
//  Created by Kacper Sagnowski on 10/30/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import SpriteKit
import AudioKit

class AudioCreature {
    
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
    private let parentCreaturePath : CreaturePath!
    
    init(audioManager: AudioManager, parentNode: SKNode, path: CreaturePath) {
        self.audioManager = audioManager
        self.parentNode = parentNode
        self.parentCreaturePath = path
        
        audioManager.addAudioCreature(self)
        
        sprite = SKSpriteNode(imageNamed: "square.png")
        sprite.setScale(0.05)
        parentNode.addChild(sprite)
        
        fromNode = parentCreaturePath.pathNodes[0]
        toNode = parentCreaturePath.pathNodes[1]
        
        oscillator = AKOscillator()
        oscillator.start()
        
        ampEnvelope = AKAmplitudeEnvelope(oscillator, attackDuration: 0.1, decayDuration: 2, sustainLevel: 0, releaseDuration: 2)
        
        output = AKMixer(ampEnvelope)
    }
    
    func updatePosition() {
        let targetDifferenceX = toNode.position.x - fromNode.position.x
        let targetDifferenceY = toNode.position.y - fromNode.position.y
        
        let newPosition = CGPoint(x: fromNode.position.x + moveProgress * targetDifferenceX, y: fromNode.position.y + moveProgress * targetDifferenceY)
        
        let path = CGMutablePath()
        path.move(to: newPosition)
        path.addLine(to: toNode.position)
        sprite.removeAction(forKey: "move")
        
        sprite.run(SKAction.follow(path, asOffset: false, orientToPath: true, speed: speed), withKey: "move", optionalCompletion: circleReached)
    }
    
    func circleReached() {
        ping(frequency: 400)
        
        fromNode = toNode
        let index = (parentCreaturePath.pathNodes.index(of: toNode as! SKSpriteNode)! + 1) % parentCreaturePath.pathNodes.count
        toNode = parentCreaturePath.pathNodes[index]
        
        let path = CGMutablePath()
        path.move(to: fromNode.position)
        path.addLine(to: toNode.position)
        sprite.removeAction(forKey: "move")
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
    
    func ping(frequency: Double) {
        oscillator.frequency = frequency
        ampEnvelope.start()
    }
    
    
}
