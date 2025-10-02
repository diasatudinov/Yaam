//
//  ZZCoinBg.swift
//  Yaam
//
//  Created by Dias Atudinov on 02.10.2025.
//


import SwiftUI

struct ZZCoinBg: View {
    @StateObject var user = ZZUser.shared
    var height: CGFloat = ZZDeviceManager.shared.deviceType == .pad ? 100:50
    var body: some View {
        ZStack {
            Image(.coinsBgZZ)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: ZZDeviceManager.shared.deviceType == .pad ? 45:25, weight: .black))
                .foregroundStyle(.white)
                .textCase(.uppercase)
                .offset(x: 15)
            
            
            
        }.frame(height: height)
        
    }
}

#Preview {
    ZZCoinBg()
}