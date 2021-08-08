//
//  SettingsScreen.swift
//  SettingsScreen
//
//  Created by Lokesh Sehgal on 08/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
            ZStack{
                ARRRBackground().edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 10) {
                    Spacer(minLength: 5)
                    Text("Settings").font(.barlowRegular(size: 22)).multilineTextAlignment(.center).foregroundColor(.white)
                    Spacer(minLength: 5)
                    List {
                               Section(header: Text("General").font(.barlowRegular(size: 18)).foregroundColor(Color.init(red: 107.0/255.0, green: 110.0/255.0, blue: 118.0/255.0))
                                .listRowInsets(EdgeInsets(
                                   top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 0))
                               )
                              {
                                   Text("Language").font(.barlowRegular(size: 16))
                                   Text("Notifications").font(.barlowRegular(size: 16))
                               }

                               Section(header: Text("Security").font(.barlowRegular(size: 18)).foregroundColor(Color.init(red: 107.0/255.0, green: 110.0/255.0, blue: 118.0/255.0))) {
                                   Text("Face ID").font(.barlowRegular(size: 16))
                                   Text("Recovery Phrase").font(.barlowRegular(size: 16))
                                   Text("Change PIN").font(.barlowRegular(size: 16))
                                   Text("Unlink Device").font(.barlowRegular(size: 16))
                               }
                        
                                Section(header: Text("Manage Wallet").font(.barlowRegular(size: 18)).foregroundColor(Color.init(red: 107.0/255.0, green: 110.0/255.0, blue: 118.0/255.0))) {
                                    Text("Private Server Config").font(.barlowRegular(size: 16))
                                    Text("Privacy Policy").font(.barlowRegular(size: 16))
                                    Text("Terms & Conditions").font(.barlowRegular(size: 16))
                                    Text("Support").font(.barlowRegular(size: 16))
                                }
                        
                    }.background(Color.init(red: 0.13, green: 0.14, blue: 0.15))
                        .listStyle(.insetGrouped)
                        
                }
                
            }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
