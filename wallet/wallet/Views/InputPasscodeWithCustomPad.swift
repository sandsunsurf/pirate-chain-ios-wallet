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
    
    @State var isPassCodeEntered = false
        
    @EnvironmentObject var appEnvironment: ZECCWalletEnvironment

    @Environment(\.presentationMode) var mode:Binding<PresentationMode>
        
    @State var copiedValue: PasteboardItemModel?

    @State var destination: Destination?
    
    @State var aUniqueCode : [String] = []
    
    @State var customDigits : [NumPadRow] = []
    
    var anInitialPassCode = ""
    
    let aPasscodeTitle = "Enter a Passcode".localized()
    
    let aConfirmPasscode = "Confirm Passcode".localized()
    
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
                arrayOfNumPadValues.append(NumPadValue(id: 0, value: "delete.left.fill"))
                arrayOfNumPadValues.append(NumPadValue(id: 1, value: String(aNumber)))
            }else{
                arrayOfNumPadValues.append(NumPadValue(id: aColumnIndex, value: String(aNumber)))
            }
            
            aColumnIndex += 1
        }
                      
        customPadDigits.append(NumPadRow(id: 3, row: arrayOfNumPadValues))
        
        return customPadDigits
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            ZcashBackground.pureBlack
         
            NavigationView{
                VStack{

                        VStack{
                            Spacer()
                            Text(!isPassCodeEntered ? aPasscodeTitle : aConfirmPasscode).font(.title)
                            HStack(spacing: 20){
                                ForEach(aUniqueCode,id: \.self){i in
                                    Text(i).font(.title).fontWeight(.semibold)
                                }
                            }.padding(.vertical)
                            Spacer()
                            
                            CustomNumberPad(uniqueCodes: $aUniqueCode,customDigits: $customDigits)
                        }
                 
                }.onAppear {

                    if customDigits.isEmpty {
                        customDigits = getRandomizedPadDigits()
                    }

                    NotificationCenter.default.addObserver(forName: NSNotification.Name("EnteredCode"), object: nil, queue: .main) { (_) in
                        
                        self.isPassCodeEntered = true
                    }
                }
                
            }.preferredColorScheme(.dark)
            .animation(.spring())
        }.background(Color.black)
        
       
        
    }
}

struct InputPasscodeWithCustomPad_Previews: PreviewProvider {
    static var previews: some View {
        InputPasscodeWithCustomPad()
    }
}

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
    
    var body : some View{
        
        VStack(alignment: .leading,spacing: 20){
                        
            ForEach(customDigits){index in
                
                HStack(spacing: self.getScreenSpacing()){
                    
                    ForEach(index.row){jIndex in
                        
                        Button(action: {
                            
                            if jIndex.value == "delete.left.fill"{
                             
                                self.uniqueCodes.removeLast()
                            }
                            else{
                                
                                self.uniqueCodes.append(jIndex.value)
                                
                                if self.uniqueCodes.count == 4{
                                    
                                    // Success here code is verified
                                    print(self.getPasscode())
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        
                                        NotificationCenter.default.post(name: NSNotification.Name("EnteredCode"), object: nil)

                                        self.uniqueCodes.removeAll()
                                    }
                                    
                                }
                            }
                            
                        }) {
                            
                            if jIndex.value == "delete.left.fill"{
                                
                                Image(systemName: jIndex.value).font(.body).padding(.vertical)
                            }
                            else{
                                
                                Text(jIndex.value).font(.title).fontWeight(.semibold).padding(.vertical)
                            }
                            
                            
                        }
                    }
                }
                
            }
            
        }.foregroundColor(.white)
    }

    
    func getScreenSpacing()->CGFloat{
        
        return UIScreen.main.bounds.width / 3
    }
    
    func getPasscode()->String{
        
        var code = ""
        
        for i in self.uniqueCodes{
        
            code += i
            
        }

        return code.replacingOccurrences(of: " ", with: "")
    }
}
