//
//  YAchievementsView.swift
//  Yaam
//
//

import SwiftUI

struct YAchievementsView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = ZZAchievementsViewModel()
    @State private var index = 0
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    HStack(alignment: .top) {
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
                    }
                }.padding([.top])
                Spacer()
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {

                        ForEach(viewModel.achievements, id: \.self) { item in
                            ZStack {
                                Image(.achieveBgY)
                                    .resizable()
                                    .scaledToFit()
                                
                                VStack {
                                    Text(item.title)
                                        .font(.system(size: 19, weight: .black))
                                        .foregroundStyle(.textGreen)
                                        .textCase(.uppercase)
                                        .multilineTextAlignment(.center)
                                    
                                    Image(item.isAchieved ? .openIconY : .lockIconY)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                                }
                            }.frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:200)
                                .onTapGesture {
                                    viewModel.achieveToggle(item)
                                    if item.isAchieved {
                                        user.updateUserMoney(for: 10)
                                    }
                                }
                        }

                    }
                }
                Spacer()
                
               
            }
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
    YAchievementsView()
}
