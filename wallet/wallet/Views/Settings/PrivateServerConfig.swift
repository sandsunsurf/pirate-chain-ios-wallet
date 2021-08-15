//
//  PrivateServerConfig.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 15/08/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct PrivateServerConfig: View {
    @State private var lightServerString: String = ""
    @State private var lightPortString: String = ""
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    @Environment(\.presentationMode) var presentationMode
    @State var isAutoConfigEnabled = true

    var body: some View {
        ZStack{
             
            ARRRBackground()
          
            VStack(alignment: .center, spacing: 5){

                Spacer(minLength: 10)
                
                Text("Private Server Config").foregroundColor(.gray).font(.barlowRegular(size: 20)).multilineTextAlignment(.center).foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                     HStack {
                         Text("Auto Config").foregroundColor(.gray).font(.barlowRegular(size: 14)).multilineTextAlignment(.center).foregroundColor(.white)
                         
                         Toggle("", isOn: $isAutoConfigEnabled)
                             .toggleStyle(ColoredToggleStyle()).labelsHidden()
                     }
                     Divider().foregroundColor(.white).frame(height:2).padding()
                     
                     VStack(alignment: .leading, spacing: nil, content: {
                         Text("Chain lite server ").font(.barlowRegular(size: 14)).foregroundColor(.gray).multilineTextAlignment(.leading)
                         TextField("lightd.meshbits.io", text: $lightServerString).font(.barlowRegular(size: 14))
                         .modifier(BackgroundPlaceholderModifier())
                         Text("Port ").foregroundColor(.gray).multilineTextAlignment(.leading).font(.barlowRegular(size: 14))
                         TextField("9067", text: $lightPortString).font(.barlowRegular(size: 14))
                         .modifier(BackgroundPlaceholderModifier())
                     }).modifier(ForegroundPlaceholderModifier())
                 }
                 .modifier(BackgroundPlaceholderModifier())
                 
               
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

struct PrivateServerConfig_Previews: PreviewProvider {
    static var previews: some View {
        PrivateServerConfig()
    }
}


struct BackgroundPlaceholderModifier: ViewModifier {

var backgroundColor = Color(.systemBackground)

func body(content: Content) -> some View {
    content
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12).fill(Color.init(red: 29.0/255.0, green: 32.0/255.0, blue: 34.0/255.0))
                .softInnerShadow(RoundedRectangle(cornerRadius: 12), darkShadow: Color.init(red: 0.06, green: 0.07, blue: 0.07), lightShadow: Color.init(red: 0.26, green: 0.27, blue: 0.3), spread: 0.05, radius: 2))
        .padding()
    }
}



struct ForegroundPlaceholderModifier: ViewModifier {

var backgroundColor = Color(.systemBackground)

func body(content: Content) -> some View {
    content
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12).fill(Color.init(red: 29.0/255.0, green: 32.0/255.0, blue: 34.0/255.0))
                .softInnerShadow(RoundedRectangle(cornerRadius: 12), darkShadow: Color.init(red: 0.26, green: 0.27, blue: 0.3), lightShadow: Color.init(red: 0.06, green: 0.07, blue: 0.07), spread: 0.05, radius: 2))
        .padding()
    }
}
