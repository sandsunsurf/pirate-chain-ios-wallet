//
//  ARRRBackground.swift
//  ECC-Wallet
//
//  Created by Lokesh Sehgal on 20/07/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct ARRRBackground: View {
    var backgroundColor: Color = Color.init(red: 0.13, green: 0.14, blue: 0.15)
    var colors: [Color] = [Color.zDarkGradient1, Color.zDarkGradient2]
    
    var showGradient = true
    func radialGradient(radius: CGFloat, center: UnitPoint = .center) -> some View {
        let gradientColors = Gradient(colors: colors)
        
        let conic = RadialGradient(gradient: gradientColors, center: center, startRadius: 0, endRadius: radius)
        return conic
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                self.backgroundColor
                
                if self.showGradient {
                    self.radialGradient(
                        radius: max(geometry.size.width, geometry.size.height),
                        center: UnitPoint(
                            x: 0.5,
                            y: 0.3
                        )
                    )
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ARRRBackground_Previews: PreviewProvider {
    static var previews: some View {
        ARRRBackground()
    }
}


extension ARRRBackground {
   
    static var darkSplashScreen: ZcashBackground {
        ZcashBackground(colors: [Color.zDarkGradient1, .zDarkGradient2])
    }
}
