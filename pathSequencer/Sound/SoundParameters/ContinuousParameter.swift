//
//  ContinuousParameter.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

class ContinuousParameter: Modulatable {
    unowned let modSource: ModulationSource
    
    private let maxValue: Double!
    private let minValue: Double!
    private let setClosure: (Double) -> Void
    private let getClosure: () -> Double
    private var userValue: Double! { didSet { update() }}
    var modAmount: Double! = 0 { didSet { update() }}
    var isActive: Bool = false
    var defaultValue: Double?
    
    let label: String!
    let displayUnit: String!
    
    init(label: String, minValue: Double, maxValue: Double, setClosure: @escaping (Double) -> Void, getClosure: @escaping () -> Double, displayUnit: String = "", modSource: ModulationSource) {
        self.label = label
        self.minValue = minValue
        self.maxValue = maxValue
        self.setClosure = setClosure
        self.getClosure = getClosure
        self.displayUnit = displayUnit
        self.modSource = modSource
        self.userValue = getCurrentValue()
    }
    
    deinit {
        print("ContinuousParameter deinit done")
    }
    
    private func setCurrentValue(to newValue: Double) {
        setClosure(max(minValue, min(maxValue, newValue)))
    }
    
    func getCurrentValue() -> Double {
        return getClosure()
    }
    
    func getCurrentProportion() -> Double {
        return (getCurrentValue() - minValue) / (maxValue - minValue)
    }
    
    func getCurrentLogProportion() -> Double {
        return (log10(getCurrentValue()) - log10(minValue)) / (log10(maxValue) - log10(minValue))
    }
    
    func setUserValue(to newValue: Double) {
        userValue = newValue
    }
    
    func getUserValue() -> Double {
        return userValue
    }
    
    func setUserProportion(_ proportion: Double) {
        setUserValue(to: minValue + proportion * (maxValue - minValue))
    }
    
    func getUserProportion() -> Double {
        return (getUserValue() - minValue) / (maxValue - minValue)
    }
    
    func setUserLogProportion(_ proportion: Double) {
        setUserValue(to: pow(10, log10(minValue) + proportion * (log10(maxValue) - log10(minValue))))
    }
    
    func getUserLogProportion() -> Double {
        return (log10(getUserValue()) - log10(minValue)) / (log10(maxValue) - log10(minValue))
    }
    
    func setModAmount(to newValue: Double) {
        let furthestModValue = userValue + newValue * (maxValue - minValue)
        if  minValue < furthestModValue && furthestModValue < maxValue {
            modAmount = min(1, max(-1, newValue))
        }
    }
    
    func getModAmount() -> Double {
        return modAmount
    }
    
    func incrementModAmount(by increment: Double) {
        let newValue = modAmount + increment
        setModAmount(to: newValue)
    }
    
    func resetToDefaultValue() {
        if defaultValue != nil {
            setUserValue(to: defaultValue!)
        } else {
            setUserValue(to: (maxValue + minValue) / 2)
        }
    }
    
    func update() {
        let newValue = userValue + (maxValue - minValue) * modAmount * modSource.getModulationValue()
        setCurrentValue(to: newValue)
    }
}
