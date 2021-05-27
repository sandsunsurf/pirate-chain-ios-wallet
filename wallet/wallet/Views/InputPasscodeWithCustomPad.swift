//
//  InputPasscodeWithCustomPad.swift
//  ARRR-Wallet
//
//  Created by Lokesh Sehgal on 20/05/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import Foundation

import SwiftUI

struct InputPasscodeWithCustomPad: View {
    
    @State var isPassCodeEntered = UserSettings.shared.savedPasscode == "" ? false : true
    
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment
    
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    let dragGesture = DragGesture()
    
    @State var isInCorrectPasscode = false
    
    @State var isNewPasscodeCreated = false
    
    @State var copiedValue: PasteboardItemModel?
            
    @State var destination: Destination?
    
    @State var aUniqueCode : [String] = []
    
    @State var customDigits : [NumPadRow] = []
    
    let aPasscodeTitle = "Enter a New Passcode".localized()
    
    let aConfirmPasscode = "Confirm Passcode".localized()
    
    @State var aTempPasscode = ""
    
    @State var aTempConfirmPasscode = ""
    
    @State var mScreenState: ScreenStates?
    
    enum ScreenStates {
        case validatePasscode, newPasscode, confirmPasscode, passcodeAlreadyExists
    }
    
    enum Destination: Int, Identifiable, Hashable {
        case inputPasscode
        var id: Int {
            return self.rawValue
        }
    }
    
    func getRandomNumbers()->[Int]{
        
        var allNumbers = [0,1,2,3,4,5,6,7,8,9]
        
        var uniqueNumbers = [Int]()
        
        while allNumbers.count > 0 {
            
            let number = Int(arc4random_uniform(UInt32(allNumbers.count)))
            
            uniqueNumbers.append(allNumbers[number])
            
            allNumbers.swapAt(number, allNumbers.count-1)
            
            allNumbers.removeLast()
        }
        
        return uniqueNumbers
    }
    
    
    func getRandomizedPadDigits()->[NumPadRow]{
        
        var customPadDigits = [NumPadRow]()
        
        let uniqueNumbers = getRandomNumbers()
        
        var aColumnIndex = 0
        
        var aRowIndex = 0
        
        var arrayOfNumPadValues = [NumPadValue]()
        
        for aNumber in uniqueNumbers {
            
            if aColumnIndex > 2 {
                aColumnIndex = 0
                customPadDigits.append(NumPadRow(id: aRowIndex, row: arrayOfNumPadValues))
                arrayOfNumPadValues.removeAll()
                aRowIndex += 1
            }
            
            if uniqueNumbers.last == aNumber {
                arrayOfNumPadValues.append(NumPadValue(id: 0, value: String(aNumber)))
                arrayOfNumPadValues.append(NumPadValue(id: 1, value: "     "))
                arrayOfNumPadValues.append(NumPadValue(id: 2, value: "delete.left.fill"))
            }else{
                arrayOfNumPadValues.append(NumPadValue(id: aColumnIndex, value: String(aNumber)))
            }
            
            aColumnIndex += 1
        }
        
        customPadDigits.append(NumPadRow(id: 3, row: arrayOfNumPadValues))
        
        return customPadDigits
    }
    
    var body: some View {
        
        ZStack() {
            
            NavigationView{
                
                ZStack {
                    
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        
                        VStack{
                            
                            Spacer().background(Color.black)
                            
                            Text(!isPassCodeEntered ? aPasscodeTitle : aConfirmPasscode).font(.title).foregroundColor(.white)
                            
                            HStack(spacing: 20){
                                
                                ForEach(aUniqueCode,id: \.self){i in
                                    
                                    Text(i).font(.title).fontWeight(.semibold).foregroundColor(.white)
                                    
                                }
                                
                            }.padding(.vertical)
                            
                            Spacer().background(Color.black)
                            
                            CustomNumberPad(uniqueCodes: $aUniqueCode,customDigits: $customDigits)
                            
                        }.background(Color.aPureBlack).edgesIgnoringSafeArea(.all)
                        
                    }.background(Color.aPureBlack).edgesIgnoringSafeArea(.all).onAppear {
                        
                        if customDigits.isEmpty {
                            customDigits = getRandomizedPadDigits()
                        }
                        
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("EnteredCode"), object: nil, queue: .main) { (_) in
                           
                                let anEnteredPasscode = aUniqueCode.joined()
                                
                                if anEnteredPasscode != "" {
                                                                        
                                    switch mScreenState {

                                    case .validatePasscode:

                                        if anEnteredPasscode == UserSettings.shared.savedPasscode {

                                            mScreenState = .newPasscode

                                            isPassCodeEntered = false
                                            
                                        }else{
                                            isInCorrectPasscode = true
                                         }

                                    case .newPasscode:
                                        
                                            aTempPasscode = anEnteredPasscode
                                            
                                            mScreenState = .confirmPasscode
                                            
                                            isPassCodeEntered = true
                                        
                                    case .confirmPasscode:
                                       
                                        if aTempPasscode == anEnteredPasscode {
                                          
                                            aTempConfirmPasscode = anEnteredPasscode
                                            
                                            isNewPasscodeCreated = true
                                            
                                        }
                                        
                                    case .passcodeAlreadyExists:
                                                                                
                                         if aTempPasscode == anEnteredPasscode {
                                           
                                            self.presentationMode.wrappedValue.dismiss()
                                             
                                         }else{
                                            isInCorrectPasscode = true
                                         }
                                        
                                    default:
                                        print("Invalid use case")
                                    }
                                    
                                    
                                }
                                
                                
                                aUniqueCode.removeAll()

                        }
                        
                    }.background(Color.aPureBlack).edgesIgnoringSafeArea(.all).padding(.bottom)
                    .alert(isPresented: $isInCorrectPasscode) { () -> Alert in
                        Alert(title: Text("Pirate Chain".localized()),
                              message: Text("Invalid Passcode, Please enter a valid passcode to change it".localized()),
                              dismissButton: .default(Text("button_close".localized()),action: {
                                isInCorrectPasscode = false
                              }))
                    }.alert(isPresented: $isNewPasscodeCreated) { () -> Alert in
                        Alert(title: Text("Pirate Chain".localized()),
                              message: Text("Great, you have set a new passcode!".localized()),
                              dismissButton: .default(Text("button_close".localized()),action: {
                                UserSettings.shared.savedPasscode = aTempConfirmPasscode
                                self.presentationMode.wrappedValue.dismiss()
                              }))
                    }
                    
                }
                
            }.highPriorityGesture(dragGesture)
        }.background(Color.aPureBlack).edgesIgnoringSafeArea(.all)
        
    }
}

//struct InputPasscodeWithCustomPad_Previews: PreviewProvider {
//    static var previews: some View {
//        InputPasscodeWithCustomPad()
//    }
//}

struct NumPadRow : Identifiable {
    
    var id : Int
    var row : [NumPadValue]
}

struct NumPadValue : Identifiable {
    
    var id : Int
    var value : String
}


struct CustomNumberPad : View {
    
    @Binding var uniqueCodes : [String]
    
    @Binding var customDigits : [NumPadRow]
    
    @State var notifyOnce = false
    
    var MAX_DIGITS = 6
    
    var body : some View{
        
        VStack(alignment: .center){
            
            ForEach(customDigits){index in
                
                HStack(spacing: self.getScreenSpacing()){
                    
                    ForEach(index.row){jIndex in
                        
                        Button(action: {
                            
                            if jIndex.value == "delete.left.fill"{
                                
                                if self.uniqueCodes.count > 0 {
                                    self.uniqueCodes.removeLast()
                                }
                            }else if jIndex.value == "     "{
                                
                                // Do nothing
                            }
                            else{
                                
                                self.uniqueCodes.append(jIndex.value)
                                
                                if self.uniqueCodes.count == MAX_DIGITS{
                                    
                                    // Success here code is verified
                                    //                                    print(self.getPasscode())
                                    
                                    
                                    if notifyOnce == false {
                                        notifyOnce = true
                                        NotificationCenter.default.post(name: NSNotification.Name("EnteredCode"), object: nil)
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        
                                        self.uniqueCodes.removeAll()
                                        notifyOnce = false
                                    }
                                    
                                }
                            }
                            
                        }) {
                            
                            if jIndex.value == "delete.left.fill"{
                                
                                Image(systemName: jIndex.value).font(.body).padding()
                                
                            }else if jIndex.value == "     "{
                                
                                Text(jIndex.value).font(.title).fontWeight(.semibold).padding()
                                
                            }
                            else{
                                
                                Text(jIndex.value).font(.title).fontWeight(.semibold).padding().multilineTextAlignment(.center).frame(width: 60, height: 60, alignment: .center)
                                    .overlay(Circle()
                                                .stroke(Color.gray, lineWidth: 2)
                                                .padding(6)
                                    )
                                
                                
                            }
                            
                            
                        }
                    }
                }
                
            }
            
        }.foregroundColor(.white).padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 40))
    }
    
    
    func getScreenSpacing()->CGFloat{
        
        return UIScreen.main.bounds.width / 3 - 40
    }
    
    func getPasscode()->String{
        
        var code = ""
        
        for i in self.uniqueCodes{
            
            code += i
            
        }
        
        return code.replacingOccurrences(of: " ", with: "")
    }
}
