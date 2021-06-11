//
//  QRCodeScanner.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 11/06/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI
struct QRCodeScanner: View {
    
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment

    var body: some View {
        
        ZStack {
            ZcashBackground()
            VStack(alignment: .center) {

                Text("Scanner Layout here")
            }
                
        }
    }
}

struct QRCodeScanner_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScanner().environmentObject(ZECCWalletEnvironment.shared)
    }
}
