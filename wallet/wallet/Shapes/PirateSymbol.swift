//
//  PirateSymbol.swift
//  ARRR-Wallet
//
//  Created by Lokesh Sehgal on 17/05/21.
//  Copyright © 2021 Francisco Gindre. All rights reserved.
//

import Foundation
import SwiftUI

/*
 
       
 */
struct PirateSymbol: Shape {
    
    static let ratio: CGFloat = 0.56
    func path(in rect: CGRect) -> Path {
        Path { path in
                    path.move(to: CGPoint(x: rect.size.width/2, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: rect.size.width/2))
                    path.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.width/2))
                    path.move(to: CGPoint(x: 0, y: rect.size.width/2))

                    path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/4), radius: rect.size.width/4, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: rect.size.height))

        }.strokedPath(StrokeStyle(lineWidth: 5))

    }
}

struct PirateSymbol_Previews: PreviewProvider {
    static var previews: some View {
        PirateSymbol()
    }
}
