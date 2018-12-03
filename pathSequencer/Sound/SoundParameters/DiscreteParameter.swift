//
//  DiscreteParameter.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 11/20/18.
//  Copyright © 2018 Kacper Sagnowski. All rights reserved.
//

import Foundation

class DiscreteParameter<T: Equatable & Hashable> {
    private var values: Array<T>!
    private var valueLabels: Dictionary<T, String>!
    private let setClosure: (T) -> Void
    private let getClosure: () -> T
    let label: String
    var valueCount: Int {
        get {
            return values.count
        }
    }
    
    init(label: String, setClosure: @escaping (T) -> Void, getClosure: @escaping () -> T) {
        self.label = label
        self.setClosure = setClosure
        self.getClosure = getClosure
        values = Array<T>()
        valueLabels = Dictionary<T, String>()
    }
    
    deinit {
        print("DiscreteParameter deinit done")
    }
    
    func addValue(value: T, valueLabel: String) {
        values.append(value)
        valueLabels[value] = valueLabel
    }
    
    func setValue(newValue: T) {
        setClosure(newValue)
    }
    
    func setValue(index: Int) {
        if index < values.count {
            setValue(newValue: values[index])
        }
    }
    
    // No guarantee that the returned value is among allowed values
    func getValue() -> T {
        return getClosure()
    }
    
    func goToNextState() {
        var index = values.index(of: getValue())
        if index != nil {
            index = (index! + 1) % values.count
            setValue(index: index!)
        }
    }
    
    func getCurrentValueLabel() -> String {
        return valueLabels[getValue()]!
    }
    
    func getValueLabel(value: T) -> String {
        return valueLabels[value]!
    }
}
