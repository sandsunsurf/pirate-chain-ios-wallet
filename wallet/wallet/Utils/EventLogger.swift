//
//  EventLogger.swift
//  wallet
//
//  Created by Francisco Gindre on 7/8/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation
import Combine

protocol EventLogging {
    func track(_ event: LogEvent, properties: KeyValuePairs<String, String>)
}

enum Screen: String {
    case backup
    case home
    case history = "wallet.detail"
    case landing
    case profile
    case feedback
    case receive
    case restore
    case scan
    case sendAddress = "send.address"
    case sendConfirm = "send.confirm"
    case sendFinal = "send.final"
    case sendMemo = "send.memo"
    case sendTransaction = "send.transaction"
    
}
enum Action: String {
    case backupDone = "backup.done"
    case backupVerify = "backup.verify"
    case walletPrompt = "landing.devwallet.prompt"
    case walletImport = "landing.devwallet.import"
    case walletCancel = "landing.devwallet.cancel"
    case ladingRestoreWallet = "landing.restore"
    case landingCreateNew = "landing.new"
    case landingBackupWallet = "landing.backup"
    case landingBackupSkipped1 = "landing.backup.skip.1"
    case landingBackupSkipped2 = "landing.backup.skip.2"
    case landingBackupSkipped3 = "landing.backup.skip.3"
    case showProfile = "home.profile"
    case receive = "home.scan"
    case receiveBack = "receive.back"
    case receiveScan = "receive.scan"
    case scanBack = "scan.back"
    case scanReceive = "scan.receive"
    case scanTorch = "scan.torch"
    case homeSend = "home.send"
    case sendAddressNext = "send.address.next"
    case sendAddressDoneAddress = "send.address.done.address"
    case sendAddressDoneAmount = "send.address.done.amount"
    case sendAddressPaste = "send.address.paste"
    case sendAddressBack = "send.address.back"
    case sendAddressScan = "send.address.scan"
    case sendConfirmBack = "send.confirm.back"
    case sendConfirmNext = "send.confirm.next"
    case sendMemoInclude = "send.memo.include"
    case sendMemoExclude = "send.memo.exclude"
    case sendMemoSkip = "send.memo.skip"
    case sendMemoNext = "send.memo.next"
    case sendFinalExit = "send.final.exit"
    case sendFinalClose = "send.final.close"
    case sendFinalDetails = "send.final.details"
    case profileClose = "profile.close"
    case profileNuke = "profile.nuke"
    case profileBackup = "profile.backup"
    case copyAddress = "copy.address"
    case backgroundAppRefreshStart = "background.apprefresh.start"
    case backgroundAppRefreshEnd = "background.apprefresh.end"
    case backgroundProcessingStart = "background.processing.start"
    case backgroundProcessingEnd = "background.processing.end"
}
enum LogEvent: Equatable {
    case screen(screen: Screen)
    case tap(action: Action)
    case error(severity: ErrorSeverity)
    case feedback
}

enum ErrorSeverity: String {
    case critical = "error.critical"
    case noncritical = "error.noncritical"
    case warning = "error.warning"
    
    static let messageKey = "message"
    static let underlyingError = "error"
}



class NullLogger: EventLogging {
    func track(_ event: LogEvent, properties: KeyValuePairs<String, String>) {}
}
