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
    private var setClosure: (Double) -> Void = {(_: Double) in }
    private var getClosure: () -> Double = {() -> Double in return 0}

    init(minValue: Double, maxValue: Double, setClosure: @escaping (Double) -> Void, getClosure: @escaping () -> Double) {
        self.minValue = minValue
        self.maxValue = maxValue

        self.setClosure = setClosure
        self.getClosure = getClosure
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
    
    func incrementByProportion(_ increment: Double) {
        let newProportion = getProportion() + increment
        setProportion(newProportion)
    }
}
