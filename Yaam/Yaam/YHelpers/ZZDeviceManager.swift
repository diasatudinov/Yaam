//
//  ZZDeviceManager.swift
//  Yaam
//
//  Created by Dias Atudinov on 02.10.2025.
//


import UIKit

class ZZDeviceManager {
    static let shared = ZZDeviceManager()
    
    var deviceType: UIUserInterfaceIdiom
    
    private init() {
        self.deviceType = UIDevice.current.userInterfaceIdiom
    }
}
