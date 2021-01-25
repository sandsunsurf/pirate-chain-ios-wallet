# Nighthawk for iOS

The Nighthawk Wallet for iOS wallet using the ZcashLightClientKit that is maintained by ECC core developers.

### Download
<a href="https://apps.apple.com/us/app/nighthawk-wallet/id1524708337" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-US" alt="Download Nighthawk on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>

### Setup
To run, clone the repo, open it in Android Studio and press play. It should just work.™

#### Requirements
- [The code](https://github.com/nighthawk-apps/zcash-ios-wallet/)
- Xcode
- Rust dependencies to build [the ZcashLightClientKit](https://github.com/zcash/ZcashLightClientKit)

# Building the App
1. Clone the project, make sure you have the latest Xcode Version
2. Create `env-vars.sh file` at `${SRCROOT}` [See Instructions](https://github.com/zcash/ZcashLightClientKit#setting-env-varsh-file-to-run-locally)
3. Make sure that your environment has the variable `ZCASH_NETWORK_ENVIRONMENT` set to`MAINNET`or `TESTNET`.
4. Navigate to the wallet directory where the `Podfile` file is located and run `pod install`
5. Open the `ECC-Wallet.xcworkspace` file
6. Locate the `.params` files that are missing in the project and include them at the specified locations
7. Build and run on simulator.

If the variable was properly set *after* you've seen this message, you will need to either a) set it manually on the pod's target or b) doing a clean pod install and subsequent build.

#### a) Setting the flag manually
1. on your workspace, select the Pods project
2. on the Targets pane, select ZcashLightClientKit
3. go to build settings
4. scroll down to see ZCASH_NETWORK_ENVIRONMENT and complete with TESTNET or MAINNET

## Disclosure Policy
Do not disclose any bug or vulnerability on public forums, message boards, mailing lists, etc. prior to responsibly disclosing to Bitcoin ABC and giving sufficient time for the issue to be fixed and deployed. Do not execute on or exploit any vulnerability.

### Reporting a Bug or Vulnerability
When reporting a bug or vulnerability, please provide the following to nighthawkwallet@protonmail.com

A short summary of the potential impact of the issue (if known).
Details explaining how to reproduce the issue or how an exploit may be formed.
Your name (optional). If provided, we will provide credit for disclosure. Otherwise, you will be treated anonymously and your privacy will be respected.
Your email or other means of contacting you.
A PGP key/fingerprint for us to provide encrypted responses to your disclosure. If this is not provided, we cannot guarantee that you will receive a response prior to a fix being made and deployed.

## Encrypting the Disclosure
We highly encourage all disclosures to be encrypted to prevent interception and exploitation by third-parties prior to a fix being developed and deployed.  Please encrypt using the PGP public key with fingerprint: `8c07e1261c5d9330287f4ec35aff0fd018b01972`

## Disclaimers
There are some known areas for improvement:

- This app depends upon related libraries that it uses. There may be bugs.
- This wallet currently only supports transacting between shielded addresses, which makes it incompatible with wallets that do not support sending to shielded addresses. 
- Traffic analysis, like in other cryptocurrency wallets, can leak some privacy of the user.
- The wallet requires a trust in the lighthttps server to display accurate transaction information. 
- This app has been developed and run exclusively on `mainnet` it might not work on `testnet`.  

See the [Wallet App Threat Model](https://zcash.readthedocs.io/en/latest/rtd_pages/wallet_threat_model.html)
for more information about the security and privacy limitations of the wallet.

## Donate to Nighthawk Devs
zs1nhawkewaslscuey9qhnv9e4wpx77sp73kfu0l8wh9vhna7puazvfnutyq5ymg830hn5u2dmr0sf

### License
MIT
