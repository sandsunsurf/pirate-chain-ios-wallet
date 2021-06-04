//
//  iCloudBackups.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 04/06/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import Foundation
import SwiftUI
struct iCloudBackups: View {
    
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment

    var body: some View {
        
        ZStack {
            ZcashBackground()
            VStack(alignment: .center) {

                Text("iCloud Backups")
            }
                
        }
    }
}

struct iCloudBackups_Previews: PreviewProvider {
    static var previews: some View {
        BackupWallet().environmentObject(ZECCWalletEnvironment.shared)
    }
}
