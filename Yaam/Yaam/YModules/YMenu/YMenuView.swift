//
//  YMenuView.swift
//  Yaam
//
//

import SwiftUI

struct YMenuView: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    @State private var showCalendar = false
    @State private var showDailyReward = false
    
    //    @StateObject var shopVM = CPShopViewModel()
    
    var body: some View {
        
        ZStack {
            
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(.settingsIconY)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:85)
                    }
                    
                    Spacer()
                    
                    ZZCoinBg()
                    
                    
                }.padding(20)
                Spacer()
                
                
            }
            
            VStack(spacing: 0) {
                
                Button {
                    showShop = true
                } label: {
                    Image(.shopIconY)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:105)
                }
                
                Button {
                    showGame = true
                } label: {
                    Image(.playIconY)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:105)
                }
                
                Button {
                    showAchievement = true
                } label: {
                    Image(.achievementsIconY)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:105)
                }
                
            }
            
        }.frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Image(.menuBgY)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
            )
            .fullScreenCover(isPresented: $showGame) {
                //                LevelPickerView()
            }
            .fullScreenCover(isPresented: $showAchievement) {
                YAchievementsView()
            }
            .fullScreenCover(isPresented: $showShop) {
                //                ZZShopView(viewModel: shopVM)
            }
            .fullScreenCover(isPresented: $showSettings) {
                YSettingsView()
            }
            .fullScreenCover(isPresented: $showDailyReward) {
                //                ZZDailyView()
            }
    }
}

#Preview {
    YMenuView()
}
