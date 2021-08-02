//
//  IntroWelcome.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 31/07/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct IntroWelcome: View {
    @Environment(\.presentationMode) var presentationMode
    @State var animateForwardOrBackward = false
    @State var isViewVisible = false
    var body: some View {
         NavigationView
         {
            ZStack{
                ARRRBackground()
                
                        VStack(alignment: .center, content: {
                            Text("Welcome to Pirate Wallet").font(.title).padding(.trailing,80).padding(.leading,80).foregroundColor(.white).multilineTextAlignment(.center)
                            Text("Reliable, fast & Secure").padding(.trailing,80).padding(.leading,80).foregroundColor(.white).multilineTextAlignment(.center).foregroundColor(.gray).padding(.top,20)
                            ZStack{
                                Image("backgroundglow")
                                    .padding(.trailing,80).padding(.leading,80)
                                
                                HStack(alignment: .center, spacing: -30, content: {

                                    withAnimation(Animation.linear(duration: 4).delay(4).repeatForever(autoreverses: true)){
                                        Image("skullcoin")
                                            .offset(y: isViewVisible ? 40:0)
                                            .animation(Animation.linear(duration: 4).delay(4).repeatForever(autoreverses: true), value: isViewVisible)
                                    }
                                    
                                    Image("coin").padding(.top,50)
                                        .rotationEffect(Angle(degrees: isViewVisible ? -40 : 0))
//                                        .transition(.move(edge: .top))
                                        .animation(Animation.linear(duration: 4).delay(4).repeatForever(autoreverses: true), value: isViewVisible)
                                        .onAppear {
                                        withAnimation(.linear){
                                            DispatchQueue.main.asyncAfter(deadline:.now()+4){
                                                isViewVisible = true
                                            }
                                        }
                                    }

                                })
                            }
                            GetStartedButtonView()
                        })

                    }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Recovery Phrase")
                    .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:  Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    VStack(alignment: .leading) {
                        ZStack{
                            Image("passcodenumericbg")
                            Text("<").foregroundColor(.gray).bold().multilineTextAlignment(.center).padding([.bottom],8).foregroundColor(Color.init(red: 132/255, green: 124/255, blue: 115/255))
                        }
                    }.padding(.leading,-20).padding(.top,10)
                })
         }.onAppear(){
//            withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 1)){
//                DispatchQueue.main.asyncAfter(deadline:.now()+2){
//                    isViewVisible = true
//                }
//            }
         }
    }
}

struct GetStartedButtonView : View {
    var body: some View {
        ZStack {
            
            Image("bluebuttonbackground").resizable().fixedSize().frame(width: 225.0, height:84).padding(.top,5)
            
            Text("Get Started").foregroundColor(Color.black)
                .frame(width: 225.0, height:84)
                .cornerRadius(15)
                .multilineTextAlignment(.center)
        }.frame(width: 225.0, height:84)
        
    }
}

struct IntroWelcome_Previews: PreviewProvider {
    static var previews: some View {
        IntroWelcome()
    }
}
