# PirateChainPaymentURISwift

[![Build Status](https://travis-ci.org/SandroMachado/BitcoinPaymentURISwift.svg?branch=master)](https://travis-ci.org/SandroMachado/BitcoinPaymentURISwift)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

PirateChainPaymentURISwift is an open source library to handle the pirate chain payment URI based on the [BIT 21](https://github.com/bitcoin/bips/blob/master/bip-0021.mediawiki). The purpose of this library is to provide a simpler way to the developers to integrate in their applications support for this URI Scheme to easily make payments.

# Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate PirateChainPaymentURI into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Meshbits/PirateChainPaymentURISwift" "piratechain"
```

Run `carthage update` to build the framework and drag the built `PirateChainPaymentURI.framework` into your Xcode project.

Or In your project -> Targets -> Build Phases -> Link Binary with Libraries -> Import -> PirateChainPaymentURI.framework

In your project -> Targets -> Frameworks, Libraries and Embedded Content -> PirateChainPaymentURI.framework -> Update it to Embed & Sign 

# Usage

## Code

Parse the URI `arrr:175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W?amount=50&label=Luke-Jr&message=Donation%20for%20project%20xyz`.

```Swift
   guard let pirateChainPaymentURI = PirateChainPaymentURI.parse("arrr:175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk?message=Bought%20pizza&amount=0.67&label=Mr.ET") else {
            return
        }

        print(pirateChainPaymentURI.address)
        print(pirateChainPaymentURI.amount)
        print(pirateChainPaymentURI.label)
        print(pirateChainPaymentURI.message)
```

In case you want to open the deep link to our Pirate Chain Wallet:

https://github.com/Meshbits/pirate-chain-ios-wallet

Parse the URI `arrr**://**175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W?amount=50&label=Luke-Jr&message=Donation%20for%20project%20xyz`.

```Swift
   guard let pirateChainPaymentURI = PirateChainPaymentURI.parse("arrr://175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk?message=Bought%20pizza&amount=0.67&label=Mr.ET") else {
            return
        }

        print(pirateChainPaymentURI.address)
        print(pirateChainPaymentURI.amount)
        print(pirateChainPaymentURI.label)
        print(pirateChainPaymentURI.message)
```

Generatig the following URI `arrr://175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk?message=Bought%20pizza&amount=0.67&label=Mr.ET`

```Swift
     let pirateChainPaymentURI: PirateChainPaymentURI = PirateChainPaymentURI.init(build: {
                    $0.address = "175kjasjtWpb8K1S7NmH4Zx6rewF9WQrcZv245Wsknjadnsadnk"
                    $0.amount = 0.67
                    $0.label = "Mr.ET"
                    $0.message = "Bought pizza"
                })

        print(pirateChainPaymentURI.uri)
```
