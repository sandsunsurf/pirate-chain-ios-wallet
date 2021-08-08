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
    var walletSection = ["Private Server Config", "Privacy Policy","Terms & Conditions", "Support"]
    
    var body: some View {
            ZStack{
                ARRRBackground().edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 10) {
                    Spacer(minLength: 5)
                    Text("Settings").font(.barlowRegular(size: 22)).multilineTextAlignment(.center).foregroundColor(.white)                    
                    Spacer(minLength: 5)
                    List {
                               Section(header: SettingsSectionHeaderView(aTitle: "General")
                                .listRowInsets(EdgeInsets(
                                   top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 0))
                               )
                              {
                                  
                                  ForEach(generalSection, id: \.self) { string in
                                            SettingsRow(aTitle:string)
                                   }.listRowBackground(Color.green)
                               }

                               Section(header: SettingsSectionHeaderView(aTitle: "Security")) {
                                   ForEach(securitySection, id: \.self) { string in
                                             SettingsRow(aTitle:string)
                                    }.listRowBackground(Color.green)
                               }
                        
                                Section(header: SettingsSectionHeaderView(aTitle: "Manage Wallet")){
                                    ForEach(walletSection, id: \.self) { string in
                                              SettingsRow(aTitle:string)
                                     }.listRowBackground(Color.green)
                                }
                        
                    }.background(Color.init(red: 0.13, green: 0.14, blue: 0.15))
                        .listStyle(.insetGrouped)
                        
                }
                
            }
    }
}


struct SettingsSectionHeaderView : View {
    @State var aTitle: String = ""
    
    var body: some View {
        
        ZStack {
            Text(aTitle).font(.barlowRegular(size: 18)).foregroundColor(Color.init(red: 107.0/255.0, green: 110.0/255.0, blue: 118.0/255.0))
        }
    }
}

struct SettingsRow: View {
    @State var aTitle: String = ""
    
    var body: some View {
        
        ZStack {
            Text(aTitle).font(.barlowRegular(size: 16)).foregroundColor(.white)
        }.listRowBackground(Color.init(red: 25.0/255.0, green: 28.0/255.0, blue: 29.0/255.0))
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
