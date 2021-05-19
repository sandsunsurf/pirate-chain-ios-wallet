//
//  InputPasscodeScreen.swift
//  ARRR-Wallet
//
//  Created by Lokesh Sehgal on 19/05/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import Foundation
import SwiftUI

fileprivate struct InputPasscodeScreenConstants {
    static let buttonHeight = CGFloat(48)
    static let horizontalPadding = CGFloat(30)
}

struct InputPasscodeScreen: View {

    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    
    @Environment(\.presentationMode) var mode:Binding<PresentationMode>
        
    @State var copiedValue: PasteboardItemModel?
    
    @State var destination: Destination?
    
    var pincodeDigits: Int = 4
    var label = "Enter a Passcode"
    
    @State var aPin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    
    var callBackHandler: (String, (Bool) -> Void) -> Void

    enum Destination: Int, Identifiable, Hashable {
        case inputPasscode
        var id: Int {
            return self.rawValue
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ZcashBackground.amberSplashScreen
            VStack(spacing: 20) {
                Text(label).font(.title).padding(.all, 20).foregroundColor(.white)
                Spacer()
                ZStack(alignment: .center, content: {
                    centerCircles
                    backgroundInputTextField
                })
                showPinsStackView
            }
        }
       
    }
     
    private var centerCircles: some View {
        HStack {
            Spacer()
            ForEach(0..<pincodeDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 25, weight: .thin, design: .default)).foregroundColor(.white)
                Spacer()
            }
        }
    }
    
    private var backgroundInputTextField: some View {
        let boundPin = Binding<String>(get: { self.aPin }, set: { newValue in
            self.aPin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin).accentColor(.clear).foregroundColor(.clear).keyboardType(.phonePad).disabled(isDisabled).foregroundColor(.white)
    }
    
    private var showPinsStackView: some View {
         HStack {
             Spacer()
             if !aPin.isEmpty {
                 showPinButton
             }
         }
         .frame(height: 40)
         .padding([.trailing])
     }
     
    private var showPinButton: some View {
           Button(action: {
               self.showPin.toggle()
           }, label: {
               self.showPin ?
                   Image(systemName: "eye.slash.fill").foregroundColor(.white) :
                   Image(systemName: "eye.fill").foregroundColor(.white)
           })
    }
    
    
    private func submitPin() {
           guard !aPin.isEmpty else {
               showPin = false
               return
           }
           
           if aPin.count == pincodeDigits {
               isDisabled = true
               
                callBackHandler(aPin) { isSuccess in
                   if isSuccess {
                       print("Pin has matched - Success")
                   } else {
                       aPin = ""
                       isDisabled = false
                       print("Pin has not matched - SHOW SOME ERROR")
                   }
               }
            
                self.mode.wrappedValue.dismiss()
           }
           
           if  aPin.count > pincodeDigits {
               aPin = String(aPin.prefix(pincodeDigits))
               submitPin()
           }
       }
       
    private func getImageName(at index: Int) -> String {
        if index >= self.aPin.count {
            return "circle"
        }
        
        if self.showPin {
            return self.aPin.allDigits[index].numberString + ".circle"
        }
        
        return "circle.fill"
    }
    
}

struct InputPasscodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        InputPasscodeScreen(callBackHandler: { (aString, aBool: (Bool) -> Void) in
            // callback here
        }).environmentObject(ZECCWalletEnvironment.shared)
    }
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}

extension String {
    
    var allDigits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}
