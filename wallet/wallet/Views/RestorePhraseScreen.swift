//
//  RestorePhraseScreen.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 31/07/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct RestorePhraseScreen: View {
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ZStack{
                ARRRBackground()
               
                VStack(alignment: .center) {
                    
                    RestoreScreenTitleAndSubtitle(aTitle: "Enter Recovery Phrase", aSubtitle: "Please enter your recovery phrase to unlink the wallet from your device", aTitlesize: Device.isLarge ? 28 : 18, aSubTitleSize: Device.isLarge ? 18 : 12, padding: 50)
                    
                }
            }
            .background(NavigationConfigurator { nc in
                nc.interactivePopGestureRecognizer?.isEnabled = true
             }).edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden(true)
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


struct RestoreScreenTitleAndSubtitle : View {
    @State var aTitle: String
    @State var aSubtitle: String
    @State var aTitlesize: CGFloat
    @State var aSubTitleSize: CGFloat
    @State var padding:CGFloat
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            Text(aTitle).foregroundColor(.white).font(
                .barlowRegular(size: aTitlesize)
            ).padding(.top,padding)
            Text(aSubtitle).lineLimit(nil).foregroundColor(.white).font(
                .barlowRegular(size: aSubTitleSize)
            ).padding(.leading,padding).padding(.trailing,padding).multilineTextAlignment(.center)

        })
    }
}

struct RestorePhraseScreen_Previews: PreviewProvider {
    static var previews: some View {
        RestorePhraseScreen()
    }
}
