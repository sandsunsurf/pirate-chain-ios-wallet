//
//  ViewController.swift
//  PirateChainPaymentURISwiftExample
//
//  Created by Lokesh Sehgal on 14/06/21.
//

import UIKit
import PirateChainPaymentURI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createAPirateChainURI()
        
        parseAPirateChainURI()
    }

    private func createAPirateChainURI(){
        
        let pirateChainPaymentURI: PirateChainPaymentURI = PirateChainPaymentURI.init(build: {
                    $0.address = "175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk"
                    $0.amount = 0.67
                    $0.label = "Mr.ET"
                    $0.message = "Bought pizza"
                    $0.isDeepLink = true
                })

        print(pirateChainPaymentURI.uri)
    }
    
    private func parseAPirateChainURI(){

//        guard let pirateChainPaymentURI = PirateChainPaymentURI.parse("arrr://175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk?message=Bought%20pizza&amount=0.67&label=Mr.ET") else {

        guard let pirateChainPaymentURI = PirateChainPaymentURI.parse("arrr:175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk?message=Bought%20pizza&amount=0.67&label=Mr.ET") else {
            print("NOT FOUND")
            return
        }

        print(pirateChainPaymentURI.address)
        print(pirateChainPaymentURI.amount)
        print(pirateChainPaymentURI.label)
        print(pirateChainPaymentURI.message)
    }

}

