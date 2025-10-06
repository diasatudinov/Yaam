//
//  CPSettingsViewModel.swift
//  Yaam
//
//


import SwiftUI

class CPSettingsViewModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true

}
