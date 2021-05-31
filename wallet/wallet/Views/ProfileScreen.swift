//
//  ProfileScreen.swift
//  wallet
//
//  Created by Francisco Gindre on 1/22/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ProfileScreen: View {
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    @State var nukePressed = false
    @State var isDisableBioMetric = false
    @State var isDisplayAddressAlert = false
    @State var isDisplayPortAlert = false
    @State var isUserOptingtoChangeLanguage = false
    @State var anAddress = SeedManager.default.exportLightWalletEndpoint()
    @State var aPort = SeedManager.default.exportLightWalletPort()
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
    @State var isUserEditingPort = false
    @State var isUserEditingAddress = false

    var afterEditedString = ""
    @State var isFeedbackActive = false
    @State var isBiometricEnabled = UserSettings.shared.biometricInAppStatus
    
    var isHighlightedAddress: Bool {
        anAddress.count > 0
    }
    
    var isHighlightedPort: Bool {
        aPort.count > 0
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                ZcashBackground.pureBlack
             
                VStack(alignment: .center, spacing: 14) {
                    Button(action: {
                        tracker.track(.tap(action: .copyAddress),
                                      properties: [:])
                        PasteboardAlertHelper.shared.copyToPasteBoard(value: self.appEnvironment.initializer.getAddress() ?? "", notify: "Address Copied to clipboard!")
                        
                    }) {
                        Text("My ARRR Address \n".localized() + (appEnvironment.initializer.getAddress()?.shortZaddress ?? ""))
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14))
                            .foregroundColor(.white).truncationMode(.tail)
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
                        ).navigationBarBackButtonHidden(true)
                    ) {
                        Text("button_backup".localized())
                            .foregroundColor(.white)
                            .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .white, lineWidth: 1)))
                            .frame(height: Self.buttonHeight)
                        
                    }
                    
                    NavigationLink(destination: LazyView(
                                    InputPasscodeWithCustomPad(aTempPasscode:"",mScreenState: InputPasscodeWithCustomPad.ScreenStates.validatePasscode).environmentObject(ZECCWalletEnvironment.shared)).navigationBarBackButtonHidden(true)
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
                        message: Text("Change app language".localized()),
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
                        
                        if #available(iOS 14.0, *) {
                            Toggle(isOn:$isBiometricEnabled){
                                Text("Enable Biometric Security".localized()).foregroundColor(.zYellow)
                                    .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .zYellow, lineWidth:0)))
                                    .frame(height:  Self.buttonHeight/2).multilineTextAlignment(.leading)
                                
                            }.onChange(of: isBiometricEnabled) {
                                (value) in
                                UserSettings.shared.biometricInAppStatus = value
                                
                                if UserSettings.shared.biometricInAppStatus {
                                    authenticate()
                                }
                            }.disabled(isDisableBioMetric)
                            
                        } else {
                            
                            
                            
                            Toggle(isOn:$isBiometricEnabled.didSet { (state) in
                                   print(state)
                            }){
                                Text("Enable Biometric Security".localized()).foregroundColor(.zYellow)
                                        .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .zYellow, lineWidth:0)))
                                        .frame(height:  Self.buttonHeight/2).multilineTextAlignment(.leading)
                                    
                            }.disabled(isDisableBioMetric)
                            
                        }

                        ActionableMessage(message: "My Pirate Chain Lite Server:".localized(), actionText: "", action: {})
                            .disabled(true)
                        
                        HStack {
                            TextField("Enter a lite server address".localized(), text: $anAddress, onEditingChanged: { (changed) in
                                isUserEditingAddress = true
                            }) {
                                isUserEditingAddress = false
                                self.didEndEditingAddressTextField()
                            }.multilineTextAlignment(.center).foregroundColor(.white).overlay(
                                Baseline().stroke(isHighlightedAddress ? activeColor : inactiveColor , lineWidth: 1)).padding([.leading, .trailing], 10).padding([.top, .bottom], 5).frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity).lineLimit(1)
                            
                            TextField("Port".localized(), text: $aPort, onEditingChanged: { (changed) in
                                isUserEditingPort = true
                            }) {
                                isUserEditingPort = false
                                self.didEndEditingPortTextField()
                            }.multilineTextAlignment(.center).foregroundColor(.white).overlay(
                                Baseline().stroke(isHighlightedPort ? activeColor : inactiveColor , lineWidth: 1)).padding([.leading, .trailing], 20).padding([.top, .bottom], 5).keyboardType(.decimalPad).frame(minWidth: 0,maxWidth:100,minHeight: 0,maxHeight: .infinity).lineLimit(1)
                            
                        }
                        
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
                        .frame(height: Self.buttonHeight).padding(.bottom, 40)
                    
                    
                }.padding(.horizontal, Self.horizontalPadding)
                .padding(.bottom, 30)
                
                
            }
            .onTapGesture {
                
                if isUserEditingPort {
                    isUserEditingPort = false
                    self.didEndEditingPortTextField()
                }
                
                if isUserEditingAddress {
                    isUserEditingAddress = false
                    self.didEndEditingAddressTextField()
                }
                
                UIApplication.shared.endEditing()

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
                      message: Text("Invalid Lite Server Address, Reverting it to pirate chain address!".localized()),
                      dismissButton: .default(Text("button_close".localized()),action: {
                        anAddress = ZECCWalletEnvironment.defaultLightWalletEndpoint
                        SeedManager.default.importLightWalletEndpoint(address: anAddress)
                  }))
            })
            .alert(isPresented: self.$isDisplayPortAlert, content: { () -> Alert in
                Alert(title: Text("".localized()),
                      message: Text("Invalid Lite Server Port, Reverting it to pirate chain port!".localized()),
                      dismissButton: .default(Text("button_close".localized()),action: {
                        aPort = String.init(format: "%d", ZECCWalletEnvironment.defaultLightWalletPort)
                        SeedManager.default.importLightWalletPort(port: aPort)
                  }))
            })
//            .navigationBarTitle("Settings", displayMode: .inline)
            
        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(false)
//        .navigationBarItems(trailing: ZcashCloseButton(action: {
//            tracker.track(.tap(action: .profileClose), properties: [:])
//            self.isShown = false
//        }).frame(width: 30, height: 30))
        
        
        .background(Color.black)
        .onReceive(AuthenticationHelper.authenticationPublisher) { (output) in
            switch output {
            case .failed(_), .userFailed:
                print("SOME ERROR OCCURRED")
            case .success:
                print("SUCCESS AND SHOW SOME ALERT HERE")
            case .userDeclined:
                print("DECLINED AND SHOW SOME ALERT HERE")
                break
            }
        }.onAppear(){
            #if targetEnvironment(simulator)
                isDisableBioMetric = true
            #endif
        }
        
       
    }
    
    func authenticate() {
        if UserSettings.shared.biometricInAppStatus {
            AuthenticationHelper.authenticate(with: "Authenticate Biometric".localized())
        }
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
    func didEndEditingAddressTextField(){
        if anAddress.count == 0 {
            isDisplayAddressAlert = true
        }else{
            SeedManager.default.importLightWalletEndpoint(address: anAddress)
        }
    }
    
    func didEndEditingPortTextField(){
        if aPort.count == 0 {
            isDisplayPortAlert = true
        }else{
            // save port
            SeedManager.default.importLightWalletPort(port: aPort)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(isShown: .constant(true)).environmentObject(ZECCWalletEnvironment.shared)
    }
}

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
