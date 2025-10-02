//
//  CPSettingsViewModel.swift
//  Yaam
//
//  Created by Dias Atudinov on 02.10.2025.
//


import SwiftUI

class CPSettingsViewModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true

}
