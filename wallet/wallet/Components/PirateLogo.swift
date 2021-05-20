//
//  PirateLogo.swift
//  ARRR-Wallet
//
//  Created by Lokesh Sehgal on 19/05/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct PirateLogo<S: ShapeStyle>: View {

    var fillStyle: S
    
    
    init(fillStyle: S) {
        self.fillStyle = fillStyle
    }
    
    var body: some View {
        ZStack {
            Ring()
            .stroke(lineWidth: 14)
                .fill(fillStyle)
                .frame(width: 80, height: 80, alignment: .center)
            VStack (alignment: .center) {
                Image("splash_icon")
                    .renderingMode(.original)
                    .padding(5)
            }
        }
    }
}

struct PirateLogo_Previews: PreviewProvider {
    static var previews: some View {
        
        PirateLogo(fillStyle: LinearGradient.amberGradient)
    }
}

extension LinearGradient {
    static var amberGradient: LinearGradient {
        LinearGradient(gradient: Gradient(
                                    colors: [Color.zAmberGradient1,
                                             Color.zAmberGradient2]
                                    ),
                       startPoint: UnitPoint(x: 0.5, y: 0),
                       endPoint: UnitPoint(x: 0.5, y: 1.0))
    }
}
