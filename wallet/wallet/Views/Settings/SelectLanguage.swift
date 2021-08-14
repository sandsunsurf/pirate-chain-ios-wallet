//
//  SelectLanguage.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 14/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI


struct CheckBoxRowData : Equatable {
    var id: Int
    var title: String
    var isSelected: Bool
}

struct SelectLanguage: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var allLanguages = [CheckBoxRowData(id:0,title:"English",isSelected: true),
                        CheckBoxRowData(id:1,title:"Spanish  (Español)",isSelected: false),
                        CheckBoxRowData(id:2,title:"Russian  (pусский)",isSelected: false)]
    
    @State var mSelectedSettingsRowData: CheckBoxRowData?
    
    var body: some View {
        ZStack{
            
            ARRRBackground().edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 10) {
                Spacer(minLength: 5)
                
                Text("Select Language").frame(height:40).font(.barlowRegular(size: 20)).multilineTextAlignment(.center).foregroundColor(Color.zSettingsSectionHeader)
                    
                ScrollView {

                    VStack {
                        ForEach(allLanguages, id: \.id) { settingsRowData in
                            SettingsRowWithCheckbox(mCurrentRowData: settingsRowData, mSelectedCheckBoxRowData: $mSelectedSettingsRowData, noLineAfter:2, isSelected: settingsRowData.isSelected)
                        }
                        
                    }
                    .modifier(SettingsSectionBackgroundModifier())
                    
                    Spacer(minLength: 50)
                    
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name("DismissSettings"), object: nil)
                    } label: {
                        BlueButtonView(aTitle: "Cancel")
                    }

                }
                .background(Color.init(red: 33.0/255.0, green: 36.0/255.0, blue: 38.0/255.0))
      
                .onTapGesture {
                    // Selection
                }
                
               
                
                
            }
           
        }

    }
}

struct SettingsRowWithCheckbox: View {

    var mCurrentRowData:CheckBoxRowData
   
    @Binding var mSelectedCheckBoxRowData: CheckBoxRowData?
    
    var noLineAfter = 0
    
    var isSelected = true

    var body: some View {

        VStack {
            HStack{
                Text(mCurrentRowData.title).font(.barlowRegular(size: 16))
                                .frame(width: 230, height: 22,alignment: .leading)
                    .foregroundColor(isSelected ? Color.arrrBarAccentColor : Color.textTitleColor)
                    .padding(.trailing, isSelected ? 60 : 80)
                    .padding()
                
                if isSelected {
                    Image(systemName: "checkmark").resizable().frame(width: 10, height: 10, alignment: .trailing).foregroundColor(isSelected ? Color.arrrBarAccentColor : Color.textTitleColor)
                }
            }
            if mCurrentRowData.id < noLineAfter {
                Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
            }
        }.onTapGesture {
            self.mSelectedCheckBoxRowData = self.mCurrentRowData
        }
    }
}

struct SelectLanguage_Previews: PreviewProvider {
    static var previews: some View {
        SelectLanguage()
    }
}
