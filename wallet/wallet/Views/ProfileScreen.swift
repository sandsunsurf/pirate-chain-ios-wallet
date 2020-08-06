//
//  ProfileScreen.swift
//  wallet
//
//  Created by Francisco Gindre on 1/22/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import SwiftUI


struct ProfileScreen: View {
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    @State var nukePressed = false
    static let buttonHeight = CGFloat(48)
    static let horizontalPadding = CGFloat(30)
    @State var isCopyAlertShown = false
    @Binding var isShown: Bool
    @State var isFeedbackActive = false
    var body: some View {
        NavigationView {
            ZStack {
                ZcashBackground()
                VStack(alignment: .center, spacing: 16) {
                    Image("zebra_profile")
                    Button(action: {
                        UIPasteboard.general.string = self.appEnvironment.initializer.getAddress()
                        tracker.track(.tap(action: .copyAddress),
                                      properties: [:])
                        self.isCopyAlertShown = true
                    }) {
                        Text("My Zcash Address\n".localized() + (appEnvironment.initializer.getAddress()?.shortZaddress ?? ""))
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(0)
                    
                    Button(action: {
                        let url = URL(string: "https://sideshift.ai/a/EqcQp4iUM")!
                        
                        UIApplication.shared.open(url)}) {
                        Text("Fund via SideShift.ai")
                            .foregroundColor(.black)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .solid(color: Color.zYellow)))
                            .frame(height: Self.buttonHeight)
                    }
                                        
                    Button(action: {
                        let url = URL(string: "https://twitter.com/nighthawkwallet")!
                        
                        UIApplication.shared.open(url)}) {
                        Text("@nighthawkwallet")
                            .foregroundColor(.black)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .solid(color: Color.zYellow)))
                            .frame(height: Self.buttonHeight)
                    }
                    
                    NavigationLink(destination: LazyView(
                        SeedBackup(hideNavBar: false)
                            .environmentObject(self.appEnvironment)
                        )
                    ) {
                        Text("Backup Wallet".localized())
                            .foregroundColor(.white)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .white, lineWidth: 1)))
                            .frame(height: Self.buttonHeight)
                        
                    }
                    
                    Button(action: {
                        UIPasteboard.general.string = "zs1nhawkewaslscuey9qhnv9e4wpx77sp73kfu0l8wh9vhna7puazvfnutyq5ymg830hn5u2dmr0sf"
                        self.isCopyAlertShown = true}) {
                        Text("Donate to Nighthawk\n".localized() + ("zs1nhawkewaslscuey9qhnv9e4wpx77sp73kfu0l8wh9vhna7puazvfnutyq5ymg830hn5u2dmr0sf"))
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink(destination: LazyView (
                        NukeWarning().environmentObject(self.appEnvironment)
                    ), isActive: self.$nukePressed) {
                        EmptyView()
                    }.isDetailLink(false)
                    
                    Button(action: {
                        tracker.track(.tap(action: .profileNuke), properties: [:])
                        self.nukePressed = true
                    }) {
                        Text("NUKE WALLET".localized())
                            .foregroundColor(.red)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .red, lineWidth: 1)))
                            .frame(height: Self.buttonHeight)
                    }
                    
                }
                .padding(.horizontal, Self.horizontalPadding)
                .padding(.bottom, 30)
                .alert(isPresented: self.$isCopyAlertShown) {
                    Alert(title: Text(""),
                          message: Text("Address Copied to clipboard!".localized()),
                          dismissButton: .default(Text("OK".localized()))
                    )
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(false)
            .navigationBarItems(trailing: ZcashCloseButton(action: {
                tracker.track(.tap(action: .profileClose), properties: [:])
                self.isShown = false
            }).frame(width: 30, height: 30))
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(isShown: .constant(true)).environmentObject(ZECCWalletEnvironment.shared)
    }
}
