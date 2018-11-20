//
//  GUIContinuousParameter.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

class GUIContinuousParameter {
    private let maxValue: Double!
    private let minValue: Double!
    private let displayUnit: String!
    private var setClosure: (Double) -> Void = {(_: Double) in }
    private var getClosure: () -> Double = {() -> Double in return 0}
    
    init(minValue: Double, maxValue: Double, setClosure: @escaping (Double) -> Void, getClosure: @escaping () -> Double, displayUnit: String) {
        
        self.minValue = minValue
        self.maxValue = maxValue
        self.setClosure = setClosure
        self.getClosure = getClosure
        self.displayUnit = displayUnit
    }

    convenience init(minValue: Double, maxValue: Double, setClosure: @escaping (Double) -> Void, getClosure: @escaping () -> Double) {
        self.init(minValue: minValue, maxValue: maxValue, setClosure: setClosure, getClosure: getClosure, displayUnit: "")
    }

    func setValue(to newValue: Double) {
        setClosure(max(minValue, min(maxValue, newValue)))
    }

    func getValue() -> Double {
        return getClosure()
    }
    
    func setProportion(_ proportion: Double) {
        setValue(to: minValue + proportion * (maxValue - minValue))
    }
    
    func getProportion() -> Double {
        return (getValue() - minValue) / (maxValue - minValue)
    }
    
    func setLogProportion(_ proportion: Double) {
        print("log(min) = \(log10(minValue)) \t log(max) = \(log10(maxValue)) \t prop = \(proportion)")
        setValue(to: pow(10, log10(minValue) + proportion * (log10(maxValue) - log10(minValue))))
        print("Value = \(getValue())")
    }
    
    func getLogProportion() -> Double {
        return (log10(getValue()) - log10(minValue)) / (log10(maxValue) - log10(minValue))
    }
    
    func getDisplayUnit() -> String {
        return displayUnit
    }
    
    func isAtLimit() -> Bool {
        return getValue() <= minValue || maxValue <= getValue()
    }
}
