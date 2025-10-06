//
//  YShopView.swift
//  Yaam
//
//

import SwiftUI

struct YShopView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CPShopViewModel
    @State var category: JGItemCategory = .background
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        ZStack {
            VStack(spacing: 35) {
                
                HStack(spacing: 20) {
                    
                    Button {
                        category = .background
                    } label: {
                        Image(category == .background ? .bgTextOnY : .bgTextOffY)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:45)
                    }
                    
                    Button {
                        category = .skin
                    } label: {
                        Image(category == .skin ? .skinsTextOnY : .skinsTextOffY)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:45)
                    }
                }
                
                VStack {
                    
                    HStack {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(category == .skin ? viewModel.shopSkinItems :viewModel.shopBgItems, id: \.self) { item in
                                achievementItem(item: item, category: category == .skin ? .skin : .background)
                                
                            }
                        }.frame(width: ZZDeviceManager.shared.deviceType == .pad ? 200:300)
                        
                    }
                }
                
            }.padding(20)
            .background(
                Image(.shopBgY)
                    .resizable()
                    .scaledToFit()
            )
            
            
            
            
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
    
    @ViewBuilder func achievementItem(item: JGItem, category: JGItemCategory) -> some View {
        Button {
            viewModel.selectOrBuy(item, user: user, category: category)
        } label: {
            ZStack {
                VStack {
                    Spacer()
                    
                    
                    if viewModel.isPurchased(item, category: category) {
                        
                        Image(viewModel.isCurrentItem(item: item, category: category) ? "\(item.icon)Current":item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 200:100)
                        
                        
                    } else {
                        ZStack {
                            Image(item.icon)
                                .resizable()
                                .scaledToFit()
                            
                            Image(.lockIconY)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 50:42)
                        }.frame(height: ZZDeviceManager.shared.deviceType == .pad ? 200:100)
                        
                    }
                    
                    
                    
                }.offset(y: 8)
                
            }
        }
    }
}

#Preview {
    YShopView(viewModel: CPShopViewModel())
}
