//
//  CreateNewWallet.swift
//  wallet
//
//  Created by Francisco Gindre on 12/30/19.
//  Copyright © 2019 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct CreateNewWallet: View {
    
    enum Destinations: Int {
        case createNew
        case restoreWallet
        case icloudBackup
    }
    
    enum AlertType: Identifiable {
        case feedback(destination: Destinations, cause: Error)
        case error(cause:Error)
        var id: Int {
            switch self {
            case .error:
                return 0
            case .feedback:
                return 1
            }
        }
    }
    
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    @State var error: UserFacingErrors?
    @State var showError: AlertType?
    @State var destination: Destinations?
    let itemSpacing: CGFloat = 20
    let buttonPadding: CGFloat = 24
    let buttonHeight: CGFloat = 50
    var body: some View {

        ZStack {
            NavigationLink(destination:
                LazyView (
                    BackupWallet().environmentObject(self.appEnvironment)
                    .navigationBarHidden(true)
                ),
                           tag: Destinations.createNew,
                           selection: $destination
                
            ) {
              EmptyView()
            }
            ZcashBackground()
            
            VStack(alignment: .center, spacing: self.itemSpacing) {
                Spacer()
                
                Image("splash_icon")
                
                Spacer()
                
                /***************** CREATE WALLET AND ITS ACTION******************/
                Button(action: {
                    do {
                        tracker.track(.tap(action: .landingBackupWallet), properties: [:])
                        try self.appEnvironment.createNewWallet()
                        self.destination = Destinations.createNew
                    } catch WalletError.createFailed(let e) {
                        if case SeedManager.SeedManagerError.alreadyImported = e {
                            self.showError = AlertType.feedback(destination: .createNew, cause: e)
                        } else {
                            fail(WalletError.createFailed(underlying: e))
                        }
                    } catch {
                        fail(error)
                    }

                }) {
                    Text("Create New Wallet".localized())
                      .font(.system(size: 20))
                      .foregroundColor(Color.black)
                      .zcashButtonBackground(shape: .rounded(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient)))
                      
                      .frame(height: self.buttonHeight)
                }
                
                /***************** CREATE WALLET ENDS HERE ******************/

                /***************** RESTORE FROM ICLOUD BACKUP ******************/
                
                NavigationLink(
                    destination: iCloudBackups()
                                    .environmentObject(self.appEnvironment),
                               tag: Destinations.icloudBackup,
                               selection: $destination
                        
                ){
                    
                    Button(action: {
                        guard !ZECCWalletEnvironment.shared.credentialsAlreadyPresent() else {
                            self.showError = .feedback(destination: .restoreWallet, cause: SeedManager.SeedManagerError.alreadyImported)
                            return
                        }
                        self.destination = .icloudBackup
                        
                    }) {
                        Text("Restore from iCloud Backup".localized())
                          .font(.system(size: 20))
                          .foregroundColor(Color.black)
                          .zcashButtonBackground(shape: .rounded(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient)))
                          .frame(height: self.buttonHeight)
                    }
                }
                /***************** RESTORE FROM ICLOUD BACKUP ENDS HERE ******************/
                
                /***************** RESTORE FROM SEED PHRASE ******************/
                NavigationLink(
                    destination: RestoreWallet()
                                    .environmentObject(self.appEnvironment),
                               tag: Destinations.restoreWallet,
                               selection: $destination
                        
                ) {
                   
                    Button(action: {
                        guard !ZECCWalletEnvironment.shared.credentialsAlreadyPresent() else {
                            self.showError = .feedback(destination: .restoreWallet, cause: SeedManager.SeedManagerError.alreadyImported)
                            return
                        }
                        self.destination = .restoreWallet
                    }) {
                        Text("Restore from Recovery Phrase".localized())
                          .font(.system(size: 20))
                          .foregroundColor(Color.black)
                            .zcashButtonBackground(shape: .rounded(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient)))
                          .frame(height: self.buttonHeight)
                    }
                    
                    
                }
                
                /***************** RESTORE FROM SEED PHRASE ENDS HERE ******************/
            }
            .padding([.horizontal, .bottom], self.buttonPadding)
        }
        .onAppear {
            tracker.track(.screen(screen: .landing), properties: [ : ])
        }
        .alert(item: self.$showError) { (alertType) -> Alert in
            switch alertType {
            case .error(let cause):
                let userFacingError = mapToUserFacingError(ZECCWalletEnvironment.mapError(error: cause))
                return Alert(title: Text(userFacingError.title),
                             message: Text(userFacingError.message),
                             dismissButton: .default(Text("button_close".localized())))
            case .feedback(let destination, let cause):
                if let feedbackCause = cause as? SeedManager.SeedManagerError,
                   case SeedManager.SeedManagerError.alreadyImported = feedbackCause {
                    return existingCredentialsFound(originalDestination: destination)
                } else {
                    return defaultAlert(cause)
                }

            }
        }
    }
    
    func fail(_ error: Error) {
        let message = "could not create new wallet:"
        logger.error("\(message) \(error)")
        tracker.track(.error(severity: .critical),
                      properties: [
                        ErrorSeverity.messageKey : message,
                        ErrorSeverity.underlyingError : "\(error)"
                        ])
       
       self.showError = .error(cause: mapToUserFacingError(ZECCWalletEnvironment.mapError(error: error)))
        
    }
    
    func existingCredentialsFound(originalDestination: Destinations) -> Alert {
        Alert(title: Text("Existing keys found!".localized()),
              message: Text("it appears that this device already has keys stored on it. What do you want to do?".localized()),
              primaryButton: .default(Text("Restore existing keys".localized()),
                                      action: {
                                        do {
                                            try ZECCWalletEnvironment.shared.initialize()
                                            self.destination = .createNew
                                        } catch {
                                            DispatchQueue.main.async {
                                                self.fail(error)
                                            }
                                        }
                                      }),
              secondaryButton: .destructive(Text("Discard them and continue".localized()),
                                            action: {
                                                
                                                ZECCWalletEnvironment.shared.nuke(resetToLogin: false)
                                                do {
                                                    try ZECCWalletEnvironment.shared.reset()
                                                } catch {
                                                    self.fail(error)
                                                    return
                                                }
                                                switch originalDestination {
                                                case .createNew:
                                                    do {
                                                        try self.appEnvironment.createNewWallet()
                                                        self.destination = originalDestination
                                                    } catch {
                                                            self.fail(error)
                                                    }
                                                case .restoreWallet:
                                                    self.destination = originalDestination
                                                
                                                    
                                                case .icloudBackup:
                                                    self.destination = originalDestination
                                                }
                                            }))
    }
    
    
    func defaultAlert(_ error: Error? = nil) -> Alert {
        guard let e = error else {
            return Alert(title: Text("Error Initializing Wallet".localized()),
                         message: Text("There was a problem initializing the wallet".localized()),
                         dismissButton: .default(Text("button_close".localized())))
        }
        
        return Alert(title: Text("Error"),
                     message: Text(mapToUserFacingError(ZECCWalletEnvironment.mapError(error: e)).message),
                     dismissButton: .default(Text("button_close".localized())))
        
    }
}

struct CreateNewWallet_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewWallet()
            .colorScheme(.dark)
    }
}

extension CreateNewWallet.Destinations: Hashable {}
