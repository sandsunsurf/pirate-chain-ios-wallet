//
//  SelectLanguage.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 14/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct SelectLanguage: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var allLanguages = [SettingsRowData(id:0,title:"English"),
                          SettingsRowData(id:1,title:"Spanish (Español)"),
                          SettingsRowData(id:2,title:"Russian (pусский)")]
    
    @State var mSelectedSettingsRowData: SettingsRowData?
    
    var body: some View {
        ZStack{
            
            ARRRBackground().edgesIgnoringSafeArea(.all)
            
            ARRRBackground().edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 10) {
                Spacer(minLength: 5)
                Text("Select Language").font(.barlowRegular(size: 20)).multilineTextAlignment(.center).foregroundColor(Color.zSettingsSectionHeader)
                    
                ScrollView {

                    VStack {
                        ForEach(allLanguages, id: \.id) { settingsRowData in
                                SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: $mSelectedSettingsRowData, noLineAfter:2)
                        }
                        
                    }
                    .modifier(SettingsSectionBackgroundModifier())
                    
                }
                .background(Color.init(red: 33.0/255.0, green: 36.0/255.0, blue: 38.0/255.0))
      
                .onTapGesture {
                    // Selection
                }
                
                BlueButtonView(aTitle: "Cancel")
            }
           
        }

    }
}

struct SelectLanguage_Previews: PreviewProvider {
    static var previews: some View {
        SelectLanguage()
    }
}
