//
//  BlockExplorerUrlHandling.swift
//  ECC-Wallet
//
//  Created by Francisco Gindre on 8/21/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation
import ZcashLightClientKit
class UrlHandler {
    
    static func blockExplorerURL(for txId: String) -> URL? {
        blockExplorerURLMainnet(for: txId)
    }

    static func blockExplorerURLMainnet(for txId: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.host = "explorer.pirate.black"
        urlComponents.scheme = "https"
        urlComponents.path = "/tx"
        
        return urlComponents.url?.appendingPathComponent(txId)
    }
}
