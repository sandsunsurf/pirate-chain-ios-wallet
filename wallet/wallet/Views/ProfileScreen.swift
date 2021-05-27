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
    @State var isDisplayAddressAlert = false
    @State var isUserOptingtoChangeLanguage = false
    @State var anAddress = SeedManager.default.exportLightWalletEndpoint()
    @Environment(\.presentationMode) var presentationMode
    static let buttonHeight = CGFloat(48)
    static let horizontalPadding = CGFloat(30)
    @State var copiedValue: PasteboardItemModel?
    @Binding var isShown: Bool
    @State var alertItem: AlertItem?
    @State var shareItem: ShareItem? = nil
    var activeColor = Color.zAmberGradient2
    var inactiveColor = Color.zGray2
    var isUserTyping = false

    var afterEditedString = ""
    @State var isFeedbackActive = false
    @State var isBiometricEnabled = UserSettings.shared.biometricStatus
    var isHighlighted: Bool {
        anAddress.count > 0
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                ZcashBackground.pureBlack
             
                VStack(alignment: .center, spacing: 16) {
                    Button(action: {
                        tracker.track(.tap(action: .copyAddress),
                                      properties: [:])
                        PasteboardAlertHelper.shared.copyToPasteBoard(value: self.appEnvironment.initializer.getAddress() ?? "", notify: "Address Copied to clipboard!")
                        
                    }) {
                        Text("My ARRR Address \n".localized() + (appEnvironment.initializer.getAddress()?.shortZaddress ?? ""))
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    .onReceive(PasteboardAlertHelper.shared.publisher) { (item) in
                        self.copiedValue = item
                    }
                    
//                    .padding(0)
//
//                    Button(action: {
//                        let url = URL(string: "https://sideshift.ai/a/EqcQp4iUM")!
//
//                        UIApplication.shared.open(url)}) {
//                            Text("Fund my wallet via SideShift.ai")
//                                .foregroundColor(.black)
//                                .zcashButtonBackground(shape: .roundedCorners(fillStyle: .solid(color: Color.zYellow)))
//                                .frame(height: Self.buttonHeight)
//                    }
                    
//                    Button(action: {
//                        let url = URL(string: "https://twitter.com/nighthawkwallet")!
//
//                        UIApplication.shared.open(url)}) {
//                            Text("@nighthawkwallet")
//                                .foregroundColor(.black)
//                                .zcashButtonBackground(shape: .roundedCorners(fillStyle: .solid(color: Color.zYellow)))
//                                .frame(height: Self.buttonHeight)
//                    }
                    
                    NavigationLink(destination: LazyView(
                        SeedBackup(hideNavBar: false)
                            .environmentObject(self.appEnvironment)
                        )
                    ) {
                        Text("button_backup".localized())
                            .foregroundColor(.white)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .white, lineWidth: 1)))
                            .frame(height: Self.buttonHeight)
                        
                    }
                    
                    NavigationLink(destination: LazyView(
                                    InputPasscodeWithCustomPad(aTempPasscode:"",mScreenState: InputPasscodeWithCustomPad.ScreenStates.validatePasscode).environmentObject(ZECCWalletEnvironment.shared))
                    ) {
                                    
                        Text("Change PIN".localized())
                            .foregroundColor(.zYellow)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .zYellow, lineWidth: 1)))
                            .frame(height:  Self.buttonHeight)
                    }
                    
                    Button(action: {
                        isUserOptingtoChangeLanguage = true
                    }, label: {
                        Text("Change app language".localized())
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .white, lineWidth: 1)))
                            .foregroundColor(.white)
                          .frame(height: Self.buttonHeight)
                    }).actionSheet(isPresented: $isUserOptingtoChangeLanguage) { () -> ActionSheet in
                        
                       ActionSheet(
                                        title: Text(""),
                                        message: Text("Change app language"),
                                        buttons: [
                                            .default(Text("English")) {
                                                updateLanguageAndResetApp(language: "en")
                                                print("Changed To English")
                                            },
                                            .default(Text("Spanish")) {
                                                updateLanguageAndResetApp(language: "es")
                                                print("Changed To Spanish")
                                            },
                                            .default(Text("Russian")) {
                                                updateLanguageAndResetApp(language: "ru")
                                                print("Changed To Russian")
                                            },
                                            .default(Text("Chinese")) {
                                                updateLanguageAndResetApp(language: "zh-Hans")
                                                print("Changed To Chinese")
                                            },
                                            .default(Text("Italian")) {
                                                updateLanguageAndResetApp(language: "it")
                                                print("Changed To Italian")
                                            },
                                            .default(Text("Korean")) {
                                                updateLanguageAndResetApp(language: "ko")
                                                print("Changed To Korean")
                                            },
                                            .destructive(Text("Cancel")) {
                                                print("cancel")
                                            }
                                            
                                        ]
                                    )
                        
                    }
                    
                    Group {
                                                
                        Toggle(isOn:$isBiometricEnabled){
                            Text("Enable Biometric Security").foregroundColor(.zYellow)
                                .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .zYellow, lineWidth:0)))
                                .frame(height:  Self.buttonHeight/2).multilineTextAlignment(.leading)
                        }
                        
                        Text("My Pirate Chain Endpoint:".localized())
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18))
                            .foregroundColor(.white).padding([.top], 20)
                        
                        TextField("Enter an endpoint".localized(), text: $anAddress, onEditingChanged: { (changed) in
                        }) {
                            self.didEndEditingTextField()
                        }.multilineTextAlignment(.center).foregroundColor(.white).overlay(
                            Baseline().stroke(isHighlighted ? activeColor : inactiveColor , lineWidth: 1)).padding([.leading, .trailing], 60).padding([.top, .bottom], 10)
                        
                    }
                    ActionableMessage(message: "\("Pirate Chain Wallet".localized()) v\(ZECCWalletEnvironment.appVersion ?? "Unknown")", actionText: "Build \(ZECCWalletEnvironment.appBuild ?? "Unknown")", action: {})
                        .disabled(true)
                    
                    NavigationLink(destination: LazyView (
                        NukeWarning().environmentObject(self.appEnvironment)
                    ), isActive: self.$nukePressed) {
                        EmptyView()
                    }.isDetailLink(false)
                    
                    Button(action: {
                        tracker.track(.tap(action: .profileNuke), properties: [:])
                        self.nukePressed = true
                    }) {
                        Text("DELETE WALLET".localized())
                            .foregroundColor(.red)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .red, lineWidth: 1)))
                            .frame(height: Self.buttonHeight)
                    }
                    
                    Text("Powered By Meshbits Ltd Team".localized())
                        .foregroundColor(.white)
                        .offset(y:100).font(.system(size: 10))
                        .frame(height: Self.buttonHeight).padding(.bottom, 20)
                    
                    
                }.padding(.horizontal, Self.horizontalPadding)
                .padding(.bottom, 30)
                
                
            }
            
            .alert(item: self.$copiedValue) { (p) -> Alert in
                PasteboardAlertHelper.alert(for: p)
            }
            .sheet(item: self.$shareItem, content: { item in
                ShareSheet(activityItems: [item.activityItem])
            })
            .alert(item: self.$alertItem, content: { a in
                a.asAlert()
            })
            .alert(isPresented: self.$isDisplayAddressAlert, content: { () -> Alert in
                Alert(title: Text("".localized()),
                      message: Text("Invalid Endpoint Address, Reverting it to pirate chain address!".localized()),
                      dismissButton: .default(Text("button_close".localized()),action: {
                        SeedManager.default.importLightWalletEndpoint(address: ZECCWalletEnvironment.defaultLightWalletEndpoint)
                  }))
            })
//            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarItems(trailing: ZcashCloseButton(action: {
                tracker.track(.tap(action: .profileClose), properties: [:])
                self.isShown = false
            }).frame(width: 30, height: 30))
        }
        .background(Color.black)
//        .navigationBarItems(trailing: ZcashCloseButton(action: {
//            tracker.track(.tap(action: .profileClose), properties: [:])
//            self.isShown = false
//        }).frame(width: 30, height: 30))
       
    }
    
    func updateLanguageAndResetApp(language: String){
        Bundle.setLanguage(lang: language)
        
//        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
//
//        return storyboard.instantiateInitialViewController()!
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            NotificationCenter.default.post(name: NSNotification.Name("MoveToFirstViewLayout"), object: nil)
//        }
    }
//
    func didEndEditingTextField(){
        if anAddress.count == 0 {
            isDisplayAddressAlert = true
        }else{
            SeedManager.default.importLightWalletEndpoint(address: anAddress)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(isShown: .constant(true)).environmentObject(ZECCWalletEnvironment.shared)
    }
}
