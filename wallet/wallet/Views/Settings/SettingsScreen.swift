//
//  SettingsScreen.swift
//  SettingsScreen
//
//  Created by Lokesh Sehgal on 08/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

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
    case openPrivateServerConfig = 5
    case openiCloudBackup = 6
    case openPrivacyPolicy = 7
    case openTermsAndConditions = 8
    case openSupport = 9
}


struct SettingsScreen: View {
    
    @Environment(\.walletEnvironment) var appEnvironment: ZECCWalletEnvironment
    
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
   
    @State var destination: SettingsDestination?
    
    @State var mSelectedSettingsRowData: SettingsRowData?
    
    var body: some View {
            ZStack{
                ARRRBackground().edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 10) {
                    Spacer(minLength: 5)
                    Text("Settings").font(.barlowRegular(size: 22)).multilineTextAlignment(.center).foregroundColor(.white)
                    Spacer(minLength: 5)
                    List {
                               Section(header: SettingsSectionHeaderView(aTitle: "General").textCase(nil)
                                .listRowInsets(EdgeInsets(
                                   top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 0))
                               )
                              {
                                  
                                  ForEach(generalSection, id: \.id) { settingsRowData in
                                    
                                    SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: self.$mSelectedSettingsRowData)
                                   
                                   }
                               }

                               Section(header: SettingsSectionHeaderView(aTitle: "Security").textCase(nil)) {
                                   ForEach(securitySection, id: \.id) { settingsRowData in
                                    SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: self.$mSelectedSettingsRowData)
                                    }
                               }
                        
                                Section(header: SettingsSectionHeaderView(aTitle: "Manage Wallet").textCase(nil)){
                                   
                                    ForEach(walletSection, id: \.id) { settingsRowData in
                                        SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: self.$mSelectedSettingsRowData)
                                     }
                                }
                        
                                Section(header: SettingsSectionHeaderView(aTitle: "About").textCase(nil)){
                                    ForEach(aboutSection, id: \.id) { settingsRowData in
                                        SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: self.$mSelectedSettingsRowData)
                                     }
                                }
                        
                    }.listStyle(InsetGroupedListStyle())
                    .onTapGesture {
                        self.destination = SettingsDestination(rawValue: self.mSelectedSettingsRowData?.id ?? 0)
                    }
                }
                
                NavigationLink(
                    destination: Text("Open Detail screen of recovery"),
                               tag: SettingsDestination.openRecoveryPhrase,
                               selection: $destination
                        
                ) {
                    EmptyView()
                }
                
            }
    }
    
}


struct SettingsSectionHeaderView : View {
    @State var aTitle: String = ""

    var body: some View {
        
        ZStack {
            Text(aTitle).font(.barlowRegular(size: 20)).foregroundColor(Color.zSettingsSectionHeader)
        }
    }
}

struct SettingsRow: View {

    var mCurrentRowData:SettingsRowData

    @Binding var mSelectedSettingsRowData: SettingsRowData?
        
    var body: some View {
        
        ZStack {
            Text(mCurrentRowData.title).font(.barlowRegular(size: 16)).foregroundColor(.white)
        }.listRowBackground(Color.zSettingsRowBackground).onTapGesture {
            self.mSelectedSettingsRowData = self.mCurrentRowData
        }
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
