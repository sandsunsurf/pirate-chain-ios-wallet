//
//  OpenInAppBrowser.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 18/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI
import WKView

struct OpenInAppBrowser: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var aURLString:String
    
    var body: some View
    {
        ZStack{
            ARRRBackground()
            NavigationView {
                
                WebView(url: aURLString,
                        tintColor: Color.gray,
                        titleColor: .yellow,
                        backText: Text("").italic(),
                        reloadImage: Image(""),
                        goForwardImage: Image(systemName: "forward.frame.fill"),
                        goBackImage: Image(systemName: "backward.frame.fill"))
                
            }
        }.edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("").navigationBarTitleDisplayMode(.inline)
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
