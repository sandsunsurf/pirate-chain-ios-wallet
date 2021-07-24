//
//  PasscodeScreen.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 20/07/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct PasscodeScreen: View {
    
    @State var mStateOfPins = [false,false,false,false,false,false]
    
    var body: some View {
        ZStack {
            PasscodeBackgroundView()
            VStack(alignment: .center, spacing: 10, content: {
                PasscodeScreenTopImageView().padding(.leading,20).padding(.top,50)
                
                HStack(alignment: .center, spacing: 10, content: {
                    
                    ForEach(0 ..< mStateOfPins.count) { index in
                        PasscodePinImageView(isSelected: Binding.constant(mStateOfPins[index]))
                    }
                }).padding(20)

                PasscodeNumberView(mStateOfPins: $mStateOfPins)
                                
            })
            
        }
    }
}

struct PasscodeNumber: View {
    
    @Binding var passcodeValue: String
    
    @Binding var mStateOfPins :[Bool]
    
    var body: some View {
        
            Button(action: {
                updateLayout(isBackPressed: passcodeValue == "delete" ? true : false)
            }, label: {
                ZStack {
                    Image("passcodenumericbg")

                    if passcodeValue == "delete" {
                        Text("").foregroundColor(.white)
                        Image(systemName: "delete.left.fill").foregroundColor(.gray)
                    }
                 
                    if passcodeValue != "delete" {
                        Text(passcodeValue).foregroundColor(.gray).bold().fontWeight(.heavy).multilineTextAlignment(.center)
                    }
                }.padding(2)
            })
    }
    
    func updateLayout(isBackPressed:Bool){
       var mCurrentSelectedIndex = -1

       for index in 0 ..< mStateOfPins.count {
           if mStateOfPins[index] {
               mCurrentSelectedIndex = index
           }
       }

        if !isBackPressed {
            mCurrentSelectedIndex += 1
        }

       if mCurrentSelectedIndex < mStateOfPins.count {
        
        if isBackPressed {
            mStateOfPins[mCurrentSelectedIndex] = false
        }else{
            mStateOfPins[mCurrentSelectedIndex] = true
        }
           
       }
    }
}

struct PasscodeNumpadRow: View {
    
    @Binding var startIndex : Int
    @Binding var endIndex : Int
    @Binding var mStateOfPins :[Bool]
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            ForEach(startIndex ..< endIndex) { index in
                PasscodeNumber(passcodeValue: Binding.constant(String(index)),mStateOfPins: $mStateOfPins)
            }
        })
    }
}

struct PasscodeNumberView : View {
    @Binding var mStateOfPins :[Bool]
    
    var body: some View {
        VStack {
            PasscodeNumpadRow(startIndex: Binding.constant(1), endIndex: Binding.constant(4),mStateOfPins: $mStateOfPins)
            PasscodeNumpadRow(startIndex: Binding.constant(4), endIndex: Binding.constant(7),mStateOfPins: $mStateOfPins)
            PasscodeNumpadRow(startIndex: Binding.constant(7), endIndex: Binding.constant(10),mStateOfPins: $mStateOfPins)
            HStack(alignment: .center, spacing: nil, content: {
                PasscodeNumber(passcodeValue: Binding.constant(""),mStateOfPins: $mStateOfPins).hidden()
                PasscodeNumber(passcodeValue: Binding.constant("0"),mStateOfPins: $mStateOfPins)
                PasscodeNumber(passcodeValue: Binding.constant("delete"),mStateOfPins: $mStateOfPins)
            })
        }
    }
}

struct PasscodeBackgroundView : View {
    var body: some View{
        Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.13, green: 0.14, blue: 0.15), Color.init(red: 0.11, green: 0.12, blue: 0.14)]), startPoint: .top, endPoint: .bottom)).edgesIgnoringSafeArea(.all)
    }
}

struct PasscodePinImageView: View {
    @Binding var isSelected:Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Image(isSelected ? "radioiconselected" : "radioiconunselected")
        }).frame(width: 40, height: 40, alignment: .center)
    }
}

struct PasscodeScreenTopImageView : View {
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Spacer()
            Image("passcodeIcon").padding(.horizontal)
            Spacer()
        })
    }
}

struct PasscodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeScreen()
    }
}


//struct PasscodeScreen: View {
//
//    @State var allowUserToMoveToHome = false
//
//    var body: some View {
//
//
//        NavigationLink(destination:
//            Home().environmentObject(HomeViewModel())
//            ,isActive: $allowUserToMoveToHome
//        ){
//
//            Button(action: {
//                allowUserToMoveToHome = true
//            }) {
//                Text("Open Home, WIP")
//            }
//
//
//        }
//
//    }
//}
