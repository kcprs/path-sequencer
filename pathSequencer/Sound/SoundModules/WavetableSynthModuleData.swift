//
//  WavetableSynthModuleData.swift
//  pathSequencer
//
//  Created by Kacper Sagnowski on 1/15/19.
//  Copyright © 2019 Kacper Sagnowski. All rights reserved.
//

import Foundation

class WavetableSynthSoundModuleData: SoundModuleData {
    var volume: Double!
    var volumeMod: Double!
    var attack: Double!
    var attackMod: Double!
    var hold: Double!
    var holdMod: Double!
    var decay: Double!
    var decayMod: Double!
    var wavetableIndex: Double!
    var wavetableIndexMod: Double!
    var filterCutoff: Double!
    var filterCutoffMod: Double!
    var pitchQuantisation: Bool!
    var effectsData: EffectsModuleData!
}
