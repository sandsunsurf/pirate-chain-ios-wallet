//
//  SettingsScreen.swift
//  SettingsScreen
//
//  Created by Lokesh Sehgal on 08/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI
import Neumorphic
import BottomSheet

struct SettingsRowData : Equatable {
    var id: Int
    var title: String
}


enum SettingsDestination: Int {
    case openLanguage = 0
    case openNotifications = 1
    case handleFaceId = 2
    case openRecoveryPhrase = 3
    case openChangePIN = 4
    case openUnlinkDevice = 5
    case openPrivateServerConfig = 6
    case openiCloudBackup = 7
    case openPrivacyPolicy = 8
    case openTermsAndConditions = 9
    case openSupport = 10
}


struct SettingsScreen: View {
    
    var generalSection = [SettingsRowData(id:0,title:"Language"),
                          SettingsRowData(id:1,title:"Notifications")]
    var securitySection = [SettingsRowData(id:2,title:"Face ID"),
                           SettingsRowData(id:3,title:"Recovery Phrase"),
                           SettingsRowData(id:4,title:"Change PIN"),
                           SettingsRowData(id:5,title:"Unlink Device")]
    var walletSection = [SettingsRowData(id:6,title:"Private Server Config"),
                         SettingsRowData(id:7,title:"iCloud backup")]
    var aboutSection = [SettingsRowData(id:8,title:"Privacy Policy"),
                        SettingsRowData(id:9,title:"Terms & Conditions"),
                        SettingsRowData(id:10,title:"Support")]
    
    @Environment(\.walletEnvironment) var appEnvironment: ZECCWalletEnvironment
    
    @State var destination: SettingsDestination?
    
    @State var openLanguageScreen = false
    
    @State var mSelectedSettingsRowData: SettingsRowData?
    
    var body: some View {
            ZStack{
                ARRRBackground().edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 10) {
                    Spacer(minLength: 5)
                    Text("Settings").font(.barlowRegular(size: 20)).multilineTextAlignment(.center).foregroundColor(.white)
                        
                    ScrollView {

                        SettingsSectionHeaderView(aTitle:"General")
                        VStack {
                            ForEach(generalSection, id: \.id) { settingsRowData in
                                    SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: $mSelectedSettingsRowData, noLineAfter:1)
                                    .onTapGesture {
                                        self.mSelectedSettingsRowData = settingsRowData
                                        openRespectiveScreenBasisSelection()
                                    }
                            }
                            
                        }
                        .modifier(SettingsSectionBackgroundModifier())
                        
                        SettingsSectionHeaderView(aTitle:"Security")
                        VStack {
                            ForEach(securitySection, id: \.id) { settingsRowData in
                                VStack {
                                    
                                    if (settingsRowData.id == 2){
                                        SettingsRowWithToggle(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: $mSelectedSettingsRowData)
                                            .onTapGesture {
                                                self.mSelectedSettingsRowData = settingsRowData
                                                openRespectiveScreenBasisSelection()
                                            }
                                    }else{
                                        SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: $mSelectedSettingsRowData, noLineAfter:5)
                                            .onTapGesture {
                                                self.mSelectedSettingsRowData = settingsRowData
                                                openRespectiveScreenBasisSelection()
                                            }
                                    }
                                }
                            }
                        }
                        .modifier(SettingsSectionBackgroundModifier())
                        
                        SettingsSectionHeaderView(aTitle:"Manage Wallet")
                        VStack {
                            ForEach(walletSection, id: \.id) { settingsRowData in
                                SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: $mSelectedSettingsRowData, noLineAfter:7)
                                    .onTapGesture {
                                        self.mSelectedSettingsRowData = settingsRowData
                                        openRespectiveScreenBasisSelection()
                                    }
                            }
                            
                        }
                        .modifier(SettingsSectionBackgroundModifier())
                        
                        SettingsSectionHeaderView(aTitle:"About")
                        VStack {
                            ForEach(aboutSection, id: \.id) { settingsRowData in
                               SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: $mSelectedSettingsRowData, noLineAfter:10)
                                .onTapGesture {
                                    self.mSelectedSettingsRowData = settingsRowData
                                    openRespectiveScreenBasisSelection()
                                }
                            }
                        }
                        .modifier(SettingsSectionBackgroundModifier())
                    }
                    .background(Color.screenBgColor)
          
                }
                
                NavigationLink(
                    destination: UnlinkDevice().environmentObject(self.appEnvironment),
                               tag: SettingsDestination.openUnlinkDevice,
                               selection: $destination
                ) {
                   EmptyView()
                }
                
                NavigationLink(
                    destination: PrivateServerConfig().environmentObject(self.appEnvironment),
                               tag: SettingsDestination.openPrivateServerConfig,
                               selection: $destination
                ) {
                   EmptyView()
                }
                
            }.bottomSheet(isPresented: $openLanguageScreen,
                          height: 500,
                          topBarHeight: 0,
                          topBarCornerRadius: 20,
                          showTopIndicator: true) {
                SelectLanguage().environmentObject(appEnvironment)
            }.onAppear(){
                NotificationCenter.default.addObserver(forName: NSNotification.Name("DismissSettings"), object: nil, queue: .main) { (_) in
                    openLanguageScreen = false
                }
            }
    }
    
    func openRespectiveScreenBasisSelection(){
        self.destination = SettingsDestination(rawValue: self.mSelectedSettingsRowData?.id ?? 0)
        
        
        switch(self.mSelectedSettingsRowData?.id){
            case SettingsDestination.openLanguage.rawValue:
                openLanguageScreen.toggle()
            break
           
            default:
                print("Something else is tapped")
        }
        
    }
    
}



struct SettingsSectionHeaderView : View {
    @State var aTitle: String = ""

    var body: some View {
        
        ZStack {
            
            Text(aTitle).font(.barlowRegular(size: 20)).foregroundColor(Color.zSettingsSectionHeader)
                            .frame(width: 230, height: 22,alignment: .leading)
                            .foregroundColor(Color.white)
                .padding(.trailing, 150)
        }
    }
}

struct SettingsRow: View {

    var mCurrentRowData:SettingsRowData
   
    @Binding var mSelectedSettingsRowData: SettingsRowData?
    
    var noLineAfter = 0

    var body: some View {
//
        VStack {
            HStack{
                Text(mCurrentRowData.title).font(.barlowRegular(size: 16)).foregroundColor(Color.textTitleColor)
                                .frame(width: 230, height: 22,alignment: .leading)
                                .foregroundColor(Color.white)
                    .padding(.trailing, 80)
                    .padding()
                
                Image("arrow_right").resizable().frame(width: 20, height: 20, alignment: .trailing)
            }
            if mCurrentRowData.id < noLineAfter {
                Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
            }
        }
    }
}

struct SettingsRowWithToggle: View {

    var mCurrentRowData:SettingsRowData
   
    @Binding var mSelectedSettingsRowData: SettingsRowData?
    
    @State var isFaceIdEnabled = true

    var body: some View {

        VStack {
            HStack{
                Text(mCurrentRowData.title).font(.barlowRegular(size: 16)).foregroundColor(Color.textTitleColor)
                                .frame(width: 200, height: 22,alignment: .leading)
                                .foregroundColor(Color.white)
                    .padding()
                
                
                Toggle("", isOn: $isFaceIdEnabled)
                    .toggleStyle(ColoredToggleStyle()).labelsHidden()
            }

            Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
            
        }
    }
}


struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color.onColor
    var offColor = Color.offColor
    var thumbOnColor = Color.thumbOnColor
    var thumbOffColor = Color.thumbOffColor
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 40, height: 29)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? thumbOnColor : thumbOffColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(Animation.easeInOut(duration: 0.2))
                .onTapGesture { configuration.isOn.toggle() }
        }
        .font(.title)
        .padding(.horizontal)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

struct SettingsSectionBackgroundModifier: ViewModifier {

        var backgroundColor = Color(.systemBackground)

        func body(content: Content) -> some View {
            content
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30).fill(Color.depthRoundedRectColor)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.darkShadow, lightShadow: Color.lightShadow, spread: 0.05, radius: 2))
                .padding()
            }
}
