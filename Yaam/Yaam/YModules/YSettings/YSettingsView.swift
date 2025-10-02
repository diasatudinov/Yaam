//
//  YSettingsView.swift
//  Yaam
//
//

import SwiftUI

struct YSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var settingsVM = CPSettingsViewModel()
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack {
                    
                    Image(.settingsBgY)
                        .resizable()
                        .scaledToFit()
                    
                    
                    VStack(spacing: 20) {
                        
                        VStack {
                            
                            Image(.musicTextY)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:30)
                            
                            Button {
                                withAnimation {
                                    settingsVM.musicEnabled.toggle()
                                }
                            } label: {
                                Image(settingsVM.musicEnabled ? .onY:.offY)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:35)
                            }
                        }
                        
                        VStack {
                            
                            Image(.soundTextY)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:30)
                            
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                Image(settingsVM.soundEnabled ? .onY:.offY)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:35)
                            }
                        }
                        
                    }.padding(.bottom,0)
                }.frame(height: ZZDeviceManager.shared.deviceType == .pad ? 88:300)
                
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
        }.frame(maxWidth: .infinity)
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
    YSettingsView()
}
