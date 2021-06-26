//
//  SeedManagement.swift
//  wallet
//
//  Created by Francisco Gindre on 1/23/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation
import ZcashLightClientKit
final class SeedManager {
    
    enum SeedManagerError: Error {
        case alreadyImported
        case uninitializedWallet
    }
    
    static var `default`: SeedManager = SeedManager()
    private static let zECCWalletKeys = "zECCWalletKeys"
    private static let zECCWalletSeedKey = "zEECWalletSeedKey"
    private static let zECCWalletBirthday = "zECCWalletBirthday"
    private static let zECCWalletPhrase = "zECCWalletPhrase"
    private static let aRRRLightWalletEndpoint = "aRRRLightWalletEndpoint"
    private static let aRRRLightWalletPort = "aRRRLightWalletPort"

    private let cloudkitKeyValueStore = NSUbiquitousKeyValueStore.default
    
    func importBirthday(_ height: BlockHeight) throws {
        
        guard cloudkitKeyValueStore.string(forKey: Self.zECCWalletBirthday) == nil else {
            throw SeedManagerError.alreadyImported
        }
        
        cloudkitKeyValueStore.set(String(height), forKey: Self.zECCWalletBirthday)

        cloudkitKeyValueStore.synchronize()
    }
    
    func exportBirthday() throws -> BlockHeight {
        
        guard let birthday = cloudkitKeyValueStore.string(forKey: Self.zECCWalletBirthday),
              let value = BlockHeight(birthday) else {
            throw SeedManagerError.uninitializedWallet
        }
        
        return value
    }
    
    func importPhrase(bip39 phrase: String) throws {
        
        guard cloudkitKeyValueStore.string(forKey: Self.zECCWalletPhrase) == nil else {
            throw SeedManagerError.alreadyImported
        }
        
        cloudkitKeyValueStore.set(phrase, forKey: Self.zECCWalletPhrase)

        cloudkitKeyValueStore.synchronize()
    }
    
    func exportPhrase() throws -> String {
        guard let seed = cloudkitKeyValueStore.string(forKey: Self.zECCWalletPhrase) else { throw SeedManagerError.uninitializedWallet }
        return seed
    }
    
    func importLightWalletEndpoint(address: String) {
        guard cloudkitKeyValueStore.string(forKey: Self.aRRRLightWalletEndpoint) == nil else {
           
            cloudkitKeyValueStore.set(address, forKey: Self.aRRRLightWalletEndpoint)

            cloudkitKeyValueStore.synchronize()

            return
        }
        
        cloudkitKeyValueStore.set(ZECCWalletEnvironment.defaultLightWalletEndpoint, forKey: Self.aRRRLightWalletEndpoint)

        cloudkitKeyValueStore.synchronize()


    }

    func exportLightWalletEndpoint() -> String {
        guard let address = cloudkitKeyValueStore.string(forKey: Self.aRRRLightWalletEndpoint) else
        {
            return ZECCWalletEnvironment.defaultLightWalletEndpoint
        }
        return address
    }
    
    func importLightWalletPort(port: String) {
        guard cloudkitKeyValueStore.string(forKey: Self.aRRRLightWalletPort) == nil else {
            cloudkitKeyValueStore.set(port, forKey: Self.aRRRLightWalletPort)
            cloudkitKeyValueStore.synchronize()
            return
        }
        
        cloudkitKeyValueStore.set(String.init(format: "%d", ZECCWalletEnvironment.defaultLightWalletPort), forKey: Self.aRRRLightWalletPort)
        cloudkitKeyValueStore.synchronize()
        
    }

    func exportLightWalletPort() -> String {
        guard let port = cloudkitKeyValueStore.string(forKey: Self.aRRRLightWalletPort) else
        {
            return String.init(format: "%d", ZECCWalletEnvironment.defaultLightWalletPort)
        }
        return port
    }

    
    
    /**
     Use carefully: Deletes the seed phrase from the keychain
     */
    func nukePhrase() {
        cloudkitKeyValueStore.removeObject(forKey: Self.zECCWalletPhrase)
        cloudkitKeyValueStore.synchronize()
    }
    /**
        Use carefully: Deletes the keys from the keychain
     */
    func nukeKeys() {
        cloudkitKeyValueStore.removeObject(forKey: Self.zECCWalletKeys)
        cloudkitKeyValueStore.synchronize()
    }

    /**
       Use carefully: Deletes the seed from the keychain.
     */
    func nukeSeed() {
        cloudkitKeyValueStore.removeObject(forKey: Self.zECCWalletSeedKey)
        cloudkitKeyValueStore.synchronize()
    }
    
    /**
     Use carefully: deletes the wallet birthday from the keychain
     */
    
    func nukeBirthday() {
        cloudkitKeyValueStore.removeObject(forKey: Self.zECCWalletBirthday)
        cloudkitKeyValueStore.synchronize()
    }
    
    
    /**
    There's no fate but what we make for ourselves - Sarah Connor
    */
    func nukeWallet() {
        nukeKeys()
        nukeSeed()
        nukePhrase()
        nukeBirthday()
        
        // Fix: retrocompatibility with old wallets, previous to IVK Synchronizer updates
        // TODO: Replace all key deletion
//        for key in keychain.allKeys {
//            keychain.delete(key)
//        }
    }
}
