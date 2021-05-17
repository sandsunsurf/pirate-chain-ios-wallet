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
            
            let width = rect.height * Self.ratio
            let origin = CGPoint(x: rect.midX - width / 2, y: rect.origin.y)
            let height = rect.height
            let middle = origin.x + width / 2
            let endX = origin.x + width
            let yOffset = height / 8
            let caretWidth = yOffset
            let caretheight = yOffset
            let caretStartX = middle - caretWidth / 2
            let caretEndX = caretStartX + caretWidth
            let strokeHeight = caretheight * 1.25
            
            
           
            
            path.move(
                to: CGPoint(
                    x: origin.x,
                    y: caretheight
                )
            )
            
            //   __
            path.addLine(
                to: CGPoint(
                    x: caretStartX,
                    y: yOffset
                )
            )
            //     ____
            path.addLine(to:
                CGPoint(
                    x: caretStartX,
                    y: caretheight
                )
            )
            /*
            
            ______
            */
            path.addLine(to:
                CGPoint(
                    x: caretStartX,
                    y: caretheight
                )
            )
            /*
               
             ______
            */
            path.addLine(to:
                CGPoint(
                    x: caretEndX,
                    y: caretheight
                )
            )
            
                /*

                     */
            path.addLine(
                to: CGPoint(
                    x: endX,
                    y: caretheight
                )
            )
            
            /*
                              _
                           __| |__
                                  |
                                */
            path.addLine(
                to: CGPoint(
                    x: endX,
                    y: caretheight + strokeHeight * 0.75
                )
            )
            /*
               _
            __| |__
            |_____ |
                   /
                  /
                 /
                /
               /
 */
 
            path.addLine(
                to: CGPoint(
                    x: caretStartX,
                    y: caretheight + strokeHeight + strokeHeight * 3
                )
            )
            
             /*
                          _
                       __| |__
                       |_____ |
                              /
                             /
                            /
                           /
                          /____
            */
            
            path.addLine(
                to: CGPoint(
                    x: endX,
                    y: caretheight + strokeHeight + strokeHeight * 3
                )
            )
            
            /*
                          _
                       __| |__
                       |_____ |
                              /
                             /
                            /
                           /
                          /____
                               |
            */
            
            
            path.addLine(
                to: CGPoint(
                    x: endX,
                    y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight
                )
            )
            
/*
              _
           __| |__
           |_____ |
                  /
                 /
                /
               /
              /____
                ___|

               
*/
           
           
           path.addLine(
               to: CGPoint(
                    x: caretEndX,
                    y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight
               )
           )
            /*
                          _
                       __| |__
                       |_____ |
                              /
                             /
                            /
                           /
                          /____
                            ___|
                           _|
                           
            */
            
            path.addLine(
                to: CGPoint(
                     x: caretEndX,
                     y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight
                )
            )
            
            /*
                          _
                       __| |__
                       |_____ |
                              /
                             /
                            /
                           /
                          /____
                          _____|
                          
                           
            */
             path.addLine(
                           to: CGPoint(
                                x: caretStartX,
                                y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight
                           )
                       )
            
           /*
                                _
                             __| |__
                             |_____ |
                                    /
                                   /
                                  /
                                 /
                                /____
                              _______|
                                
                                 
                  */
            
            path.addLine(
                to: CGPoint(
                     x: caretStartX,
                     y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight
                )
            )
          
        /*
                                 _
                              __| |__
                                     |
                                     /
                                    /
                                   /
                                  /
                                 /____
                             |___  ___|
                                 |_|
                                  
                   */
            
            path.addLine(
                to: CGPoint(
                    x: origin.x,
                     y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight
                )
            )
            
            /*
                    _
                 __| |__
                        |
                        /
                       /
                      /
                     /
                    /____
                |___  ___|
                    |_|
                                             
                              */
                       
            path.addLine(
                to: CGPoint(
                    x: origin.x,
                     y: caretheight + strokeHeight + strokeHeight * 3 + strokeHeight * 0.25
                )
            )
            
            /*
                        _
                     __| |__
                     ____  |
                         /  /
                        /  /
                       /  /
                      /  /
                     /  /____
                    |___  ___|
                        |_|
                                                 
                                  */
            path.addLine(
                          to: CGPoint(
                              x: caretEndX,
                               y: caretheight + strokeHeight
                          )
                      )
            
            
            /*
                                     _
                                 ___| |__
                                 ______  |
                                      /  /
                                     /  /
                                    /  /
                                   /  /
                                  /  /____
                                 |___  ___|
                                     |_|
                                      
                       */
           path.addLine(
               to: CGPoint(
                x: origin.x,
                    y: caretheight + strokeHeight
               )
           )
           path.closeSubpath()
         
        }
    }
}
