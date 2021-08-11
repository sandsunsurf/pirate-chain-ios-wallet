//
//  NotificationScreen.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 11/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct NotificationScreen: View {
    
    var generalSection = [SettingsRowData(id:0,title:"Push Notifications"),
                          SettingsRowData(id:1,title:"Updates from us")]
    
    @State var mSelectedSettingsRowData: SettingsRowData?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            ARRRBackground().edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 10) {
                Spacer(minLength: 5)
                List {
                           Section(header: SettingsSectionHeaderView(aTitle: "").textCase(nil))
                          {
                              
                              ForEach(generalSection, id: \.id) { settingsRowData in
                                
                                SettingsRow(mCurrentRowData: settingsRowData, mSelectedSettingsRowData: self.$mSelectedSettingsRowData)
                               
                               }
                           }

                    
                }.listStyle(InsetGroupedListStyle())
                .onTapGesture {
//                    self.mSelectedSettingsRowData?.id is the selected ID
                }
            }
           
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:  Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            VStack(alignment: .leading) {
                ZStack{
                    Image("passcodenumericbg")
                    Text("<").foregroundColor(.gray).bold().multilineTextAlignment(.center).font(
                        .barlowRegular(size: Device.isLarge ? 26 : 18)
                    ).padding([.bottom],8).foregroundColor(Color.init(red: 132/255, green: 124/255, blue: 115/255))
                }
            }.padding(.leading,-20).padding(.top,10)
        })

}
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}
