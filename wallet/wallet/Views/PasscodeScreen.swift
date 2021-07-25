//
//  PasscodeScreen.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 20/07/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI


public class PasscodeViewModel: ObservableObject{
    
    @Published var mStateOfPins = [false,false,false,false,false,false]
    
    @Published var mPressedKeys = []
    
    init() {
        
    }
    
    func captureKeyPress(mKeyPressed:Int,isBackPressed:Bool){
        
        let mCurrentSelectedNumber = mKeyPressed
        
        if isBackPressed {
            
            if mPressedKeys.count > 0 {
                mPressedKeys.removeLast()
            }
            
            return
        }
        
        if mPressedKeys.count < 6 {
            
            mPressedKeys.append(mCurrentSelectedNumber)
            
        }

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

struct PasscodeScreen: View {
    
   @ObservedObject var passcodeViewModel = PasscodeViewModel()
    
    var body: some View {
        ZStack {
            PasscodeBackgroundView()
            VStack(alignment: .center, spacing: 10, content: {
                PasscodeScreenTopImageView().padding(.leading,20).padding(.top,50)
                
                HStack(alignment: .center, spacing: 0, content: {
                    
                    ForEach(0 ..< passcodeViewModel.mStateOfPins.count) { index in
                        PasscodePinImageView(isSelected: Binding.constant(passcodeViewModel.mStateOfPins[index]))
                    }
                }).padding(20)

                PasscodeNumberView(passcodeViewModel: Binding.constant(passcodeViewModel))
                                
            })
            
        }
    }
}

struct PasscodeNumber: View {
    
    @Binding var passcodeValue: String
    
    @Binding var passcodeViewModel: PasscodeViewModel
    
    var body: some View {
        
            Button(action: {
                passcodeViewModel.updateLayout(isBackPressed: passcodeValue == "delete" ? true : false)
                
                if passcodeValue == "delete" {
                    passcodeViewModel.captureKeyPress(mKeyPressed: -1, isBackPressed: true)
                }else{
                    passcodeViewModel.captureKeyPress(mKeyPressed: Int(passcodeValue)!, isBackPressed: false)
                }

            }, label: {
                ZStack {
                    Image("passcodenumericbg")

                    if passcodeValue == "delete" {
                        Text("").foregroundColor(.white)
                        Image(systemName: "delete.left.fill").foregroundColor(.gray)
                    }
                 
                    if passcodeValue != "delete" {
                        Text(passcodeValue).foregroundColor(.gray).bold().multilineTextAlignment(.center).font(
                            .barlowRegular(size: Device.isLarge ? 32 : 24)
                        )
                    }
                }.padding(2)
            })
    }
    
}

struct PasscodeNumpadRow: View {
    
    @Binding var startIndex : Int
    @Binding var endIndex : Int
    @Binding var passcodeViewModel: PasscodeViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            ForEach(startIndex ..< endIndex) { index in
                PasscodeNumber(passcodeValue: Binding.constant(String(index)),passcodeViewModel: $passcodeViewModel)
            }
        })
    }
}

struct PasscodeNumberView : View {
    @Binding var passcodeViewModel: PasscodeViewModel
    var body: some View {
        VStack {
            PasscodeNumpadRow(startIndex: Binding.constant(1), endIndex: Binding.constant(4),passcodeViewModel: Binding.constant(passcodeViewModel))
            PasscodeNumpadRow(startIndex: Binding.constant(4), endIndex: Binding.constant(7),passcodeViewModel: Binding.constant(passcodeViewModel))
            PasscodeNumpadRow(startIndex: Binding.constant(7), endIndex: Binding.constant(10),passcodeViewModel: Binding.constant(passcodeViewModel))
            HStack(alignment: .center, spacing: nil, content: {
                
                PasscodeNumber(passcodeValue: Binding.constant(""),passcodeViewModel: $passcodeViewModel).hidden()
                PasscodeNumber(passcodeValue: Binding.constant("0"),passcodeViewModel: $passcodeViewModel)
                PasscodeNumber(passcodeValue: Binding.constant("delete"),passcodeViewModel: $passcodeViewModel)
            })
        }
    }
}

struct PasscodeBackgroundView : View {
    var body: some View{
        Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color.zDarkGradient1, Color.zDarkGradient2]), startPoint: .top, endPoint: .bottom)).edgesIgnoringSafeArea(.all)
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
//
//struct PasscodeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        PasscodeScreen()
//    }
//}


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
