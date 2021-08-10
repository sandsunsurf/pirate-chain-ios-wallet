//
//  SettingsScreen.swift
//  SettingsScreen
//
//  Created by Lokesh Sehgal on 08/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {
    
    var generalSection = ["Language", "Notifications"]
    var securitySection = ["Face ID", "Recovery Phrase","Change PIN", "Unlink Device"]
    var walletSection = ["Private Server Config","iCloud backup"]
    var aboutSection = ["Privacy Policy","Terms & Conditions", "Support"]
    
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
                                  
                                  ForEach(generalSection, id: \.self) { string in
                                            SettingsRow(aTitle:string)
                                   }
                               }

                               Section(header: SettingsSectionHeaderView(aTitle: "Security").textCase(nil)) {
                                   ForEach(securitySection, id: \.self) { string in
                                             SettingsRow(aTitle:string)
                                    }
                               }
                        
                                Section(header: SettingsSectionHeaderView(aTitle: "Manage Wallet").textCase(nil)){
                                    ForEach(walletSection, id: \.self) { string in
                                              SettingsRow(aTitle:string)
                                     }
                                }
                        
                                Section(header: SettingsSectionHeaderView(aTitle: "About").textCase(nil)){
                                    ForEach(aboutSection, id: \.self) { string in
                                              SettingsRow(aTitle:string)
                                     }
                                }
                        
                    }.listStyle(InsetGroupedListStyle())
                    
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
    @State var aTitle: String = ""
    
    var body: some View {
        
        ZStack {
            Text(aTitle).font(.barlowRegular(size: 16)).foregroundColor(.white)
        }.listRowBackground(Color.zSettingsRowBackground)
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
