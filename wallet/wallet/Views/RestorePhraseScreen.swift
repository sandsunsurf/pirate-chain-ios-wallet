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
        ZStack{
            ARRRBackground()
            
            VStack(alignment: .center) {
                ZcashNavigationBar(
                    leadingItem: {
                       
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                Image("passcodenumericbg")
                                Text("<").foregroundColor(.gray).bold().multilineTextAlignment(.center).font(
                                    .barlowRegular(size: Device.isLarge ? 26 : 18)
                                ).padding([.bottom],8)
                            }
                        }

                        
                },
                    headerItem: {
                },
                    trailingItem: {
                        
                }).frame(height: 50)
                    .padding([.top],50)
                   
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct RestorePhraseScreen_Previews: PreviewProvider {
    static var previews: some View {
        RestorePhraseScreen()
    }
}
