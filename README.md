# pirate-chain-ios-wallet

[![Build Status](https://travis-ci.org/zcash/zcash-ios-wallet.svg?branch=master)](https://travis-ci.org/zcash/zcash-ios-wallet)

## Motivation
Dogfooding - _transitive verb_ - is the practice of an organization using its own product. This app was created to help us learn.

Please take note: the wallet is not an official product by ECC, but rather a tool for learning about our libraries that it is built on. This means that we do not have robust infrasturcture or user support for this application. We open sourced it as a resource to make wallet development easier for the Zcash ecosystem.

## Description

iOS wallet using the Zcash iOS SDK that is maintained by core developers.

There are some known areas for improvement:

- Traffic analysis, like in other cryptocurrency wallets, can leak some privacy
  of the user.
- The wallet might display inaccurate transaction information if it is connected
  to an untrustworthy server.

See the [Wallet App Threat
Model](https://zcash.readthedocs.io/en/latest/rtd_pages/wallet_threat_model.html)
for more information about the security and privacy limitations of the wallet.

## Prerequisites
* make sure you can build ZcashLightClientKit Demo Apps successfully

# Building the App
1. Clone the project, make sure you have the latest Xcode Version

2. Create `env-vars.sh file` at `${SRCROOT}` [See Instructions](https://github.com/zcash/ZcashLightClientKit#setting-env-varsh-file-to-run-locally)

3. make sure that your environment has the variable `ZCASH_NETWORK_ENVIRONMENT` set to`MAINNET`.

4. Navigate to the wallet directory where the `Podfile` file is located and run `pod install`. If pod packages are already installed, and need to update the pod packages, then execute command `pod update`.

5. open the `ECC-Wallet.xcworkspace` file. (It is a "X WORK SPACE" file. Do not confuse to read it as "X CODE PROJECT" file.)

6. locate the `.params` files that are missing in the project and include them at the specified locations. These are the 2 files named `sapling-output.params` and `sapling-spend.params`, which you'll find from the ZcashParams data directory which you usually get while compiling Zcash or Komodo. If need to get the files, you can use this [fetch-params.sh](https://github.com/PirateNetwork/pirate/blob/master/zcutil/fetch-params.sh) file on your machine via Terminal. After it finished downloading the parameters, on MacOS go to `$HOME/Library/Application Support/ZcashParams` and you'll find the relevant files there. Copy the files mentioned earlier and paste them inside `zcash-ios-wallet/wallet/wallet` directory.

7. build and run on simulator.


# To Log or not to Log

This is our internal dogfooding app, and we implemented some level of event logging to be able to study user interactions and improve the User Experience with Zcash on mobile devices.

## No Logs please

*You can build and run the app **without it** by using the `wallet-no-logging`*

The "no logging" target does not even build or include the Mixpanel sdk on your build or any code related with it. You can make sure of this by looking at the code yourself. If you think there's a better way achieve this, please open an Issue with your proposal. :-) 

<!-- ## I want to use Mixpanel

If you wish to use mixpanel in your own build, make sure to include the following line in your env-vars.sh file
`export MIXPANEL_TOKEN="YOUR_TOKEN"`
And build the `wallet` target. Sourcery will pick it up and generate the Constants.generated.swift file that the Mixpanel SDK will use to send the events to your board
 -->
 
## I use some other kind of tracker...
that I would like to include in my project. The app does not care about the details of the event logger as long as it implements this protocol
````Swift
protocol EventLogging {
    func track(_ event: LogEvent, properties: KeyValuePairs<String, String>)
}
````

You can implement your own tracker proxy
## Troubleshooting

### No network environment....
if you see this message when building:
```No network environment. Set ZCASH_NETWORK_ENVIRONMENT to MAINNET```
make sure your dev environment has this variable set before the build starts. *DO NOT CHANGE IT DURING THE BUILD PROCESS*.

If the variable was properly set *after* you've seen this message, you will need to either a) set it manually on the pod's target or b) doing a clean pod install and subsequent build.

To set the environment variable `ZCASH_NETWORK_ENVIRONMENT`'s value, make sure to open `X WORK SPACE` file `ECC-Wallet.xcworkspace`, and then click on `Pods` from left pane, which will result in showing build settings in right/middle pane. There under `TARGETS` click on `ZcashLiteClientKit`, then select `Build Settings` from top buttons showing under this settings pane. Scroll to the bottom and find the variable showing in bold named `ZCASH_NETWORK_ENVIRONMENT`. Double click on the right side of that variable where you can input `MAINNET` and hit enter key. That will set this environment variable's value. For reference see the following screen shot:
<img width="809" alt="Screen Shot 2021-05-19 at 10 58 04 PM" src="https://user-images.githubusercontent.com/12998093/118802714-979c4a80-b8f6-11eb-94a4-23816faf856b.png">


#### a) setting the flag manually
1. on your workspace, select the Pods project
2. on the Targets pane, select ZcashLightClientKit
3. go to build settings
4. scroll down to see ZCASH_NETWORK_ENVIRONMENT and complete with MAINNET

#### Transparent address is not showing in right format as per KMD's chain params
After the `pod install` or `pod upgrade` step, go to `zcash-ios-wallet/wallet/Pods/ZcashLightClientKit` and execute the command `cargo build` inside there.
Then try build and run on simulator.

#### Cleaning temporary and cache files related to project
Other things you can try is cleaing up the cache on Xcode, Pods, and Rust cargo packages.
- For Xcode, can use combination of keys `Command+Shift+K` or `Command+Option+Shift+K`.
- For Pods, just delete the `Pods` directory where you executed the command `pod install` or `pod update`. After that execute `pod update` to fetch latest packages again. Make sure to set the environment vairable `ZCASH_NETWORK_ENVIRONMENT`'s value to `MAINNET` after this step. It gets reset each time `pod install` or `pod update` is executed.
- For Rust cargo pacakges go to `~/.cargo` and delete `git` and `registry` with command `rm -rf git/ registery/`
- For iOS simulator, when the simulator iPhone is running, go to it's top menu options showing for the Simulator app on MacOS, select `Device -> Erase All Contents and Settings...`
