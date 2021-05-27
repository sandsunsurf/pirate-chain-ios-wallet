//
//  UserSettings.swift
//  ECC-Wallet
//
//  Created by Francisco Gindre on 1/29/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import Foundation


class UserSettings {
    
    static let shared = UserSettings()
    
    private init() {}
    struct Keys {
        static let lastUsedAddress = "lastUsedAddress"
        static let everShielded = "everShielded"
        static let rescanPendingFix = "rescanPendingFix"
        static let aPassCode = "aPassCode"
        static let aBiometricEnable = "aBiometricEnable"

    }
    
    var lastUsedAddress: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.lastUsedAddress)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.lastUsedAddress)
        }
    }
    
    
    var didRescanPendingFix: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.rescanPendingFix)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey:Keys.rescanPendingFix)
        }
    }
    
    
    var savedPasscode: String?  {
        get {
            UserDefaults.standard.string(forKey: Keys.aPassCode)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.aPassCode)
        }
    }

    var biometricStatus: Bool  {
        get {
            UserDefaults.standard.bool(forKey: Keys.aBiometricEnable)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.aBiometricEnable)
        }
    }

    
}
