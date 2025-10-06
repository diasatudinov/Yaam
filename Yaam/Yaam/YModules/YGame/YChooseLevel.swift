//
//  YChooseLevel.swift
//  Yaam
//
//

import SwiftUI

struct YChooseLevel: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showGame = false

    var body: some View {
        ZStack {

            HStack {
                Button {
                    showGame = true
                } label: {
                    Image(.easyBtnY)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
                
                Button {
                    showGame = true
                } label: {
                    Image(.mediumBtnY)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
                
                Button {
                    showGame = true
                } label: {
                    Image(.hardBtnY)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
            }
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconY)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:85)
                    }
                    
                    Spacer()
                    
                    ZZCoinBg()
                    
                }.padding()
                Spacer()
                
            }
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $showGame) {
            ContentView()
        }
            .background(
                ZStack {
                    Image(.menuBgY)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                }
            )
    }
}

#Preview {
    YChooseLevel()
}
