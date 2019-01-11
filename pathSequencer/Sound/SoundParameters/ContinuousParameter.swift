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
    private var isLogarithmic = false
    
    let label: String!
    let displayUnit: String!
    
    init(label: String, minValue: Double, maxValue: Double, setClosure: @escaping (Double) -> Void, getClosure: @escaping () -> Double, displayUnit: String = "", modSource: ModulationSource, isLogarithmic: Bool = false) {
        self.label = label
        self.minValue = minValue
        self.maxValue = maxValue
        self.setClosure = setClosure
        self.getClosure = getClosure
        self.displayUnit = displayUnit
        self.modSource = modSource
        self.isLogarithmic = isLogarithmic
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
        if isLogarithmic {
            return (log10(getCurrentValue()) - log10(minValue)) / (log10(maxValue) - log10(minValue))
        }
        
        return (getCurrentValue() - minValue) / (maxValue - minValue)
    }
    
    func setUserValue(to newValue: Double) {
        userValue = newValue
    }
    
    func getUserValue() -> Double {
        return userValue
    }
    
    func setUserProportion(_ proportion: Double) {
        if isLogarithmic {
            setUserValue(to: pow(10, log10(minValue) + proportion * (log10(maxValue) - log10(minValue))))
        } else {
            setUserValue(to: minValue + proportion * (maxValue - minValue))
        }
    }
    
    func getUserProportion() -> Double {
        if isLogarithmic {
            return (log10(getUserValue()) - log10(minValue)) / (log10(maxValue) - log10(minValue))
        }
        
        return (getUserValue() - minValue) / (maxValue - minValue)
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
        var newValue: Double
        if isLogarithmic {
            newValue = pow(10, log10(userValue) + (log10(maxValue / minValue)) * modAmount * modSource.getModulationValue())
        } else {
            newValue = userValue + (maxValue - minValue) * modAmount * modSource.getModulationValue()
        }
        
        setCurrentValue(to: newValue)
    }
}
