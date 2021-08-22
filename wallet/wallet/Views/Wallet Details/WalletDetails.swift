//
//  WalletDetails.swift
//  wallet
//
//  Created by Francisco Gindre on 1/21/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import SwiftUI
import Combine
class WalletDetailsViewModel: ObservableObject {
    // look at before changing https://stackoverflow.com/questions/60956270/swiftui-view-not-updating-based-on-observedobject
    @Published var items = [DetailModel]()

    var showError = false
    var balance: Double = 0
    private var synchronizerEvents = Set<AnyCancellable>()
    private var internalEvents = Set<AnyCancellable>()
    @State var showMockData = false // Change it to false = I have used it for mock data testing
    
    var groupedByDate: [Date: [DetailModel]] {
        Dictionary(grouping: self.items, by: {$0.date})
    }
    
    var headers: [Date] {
        groupedByDate.map({ $0.key }).sorted().reversed()
    }

    init(){
        subscribeToSynchonizerEvents()
    }
    
    deinit {
        unsubscribeFromSynchonizerEvents()
    }

    func getSortedItems()-> [DetailModel]{
        return self.items.sorted(by: { $0.date > $1.date })
    }
    
    func subscribeToSynchonizerEvents() {
        ZECCWalletEnvironment.shared.synchronizer.walletDetailsBuffer
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (d) in
                self?.items = self!.showMockData ? DetailModel.mockDetails : d
            })
            .store(in: &synchronizerEvents)
        
        ZECCWalletEnvironment.shared.synchronizer.balance
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (b) in
                self?.balance = b
            })
            .store(in: &synchronizerEvents)
    }
    
    func unsubscribeFromSynchonizerEvents() {
        synchronizerEvents.forEach { (c) in
            c.cancel()
        }
        synchronizerEvents.removeAll()
    }
    var balanceStatus: BalanceStatus {
        let status = ZECCWalletEnvironment.shared.balanceStatus
        switch status {
        case .available(_):
            return .available(showCaption: false)
        default:
            return status
        }
    }
    
    var zAddress: String {
        ZECCWalletEnvironment.shared.getShieldedAddress() ?? ""
    }
}

struct WalletDetails: View {
    @EnvironmentObject var viewModel: WalletDetailsViewModel
    @Environment(\.walletEnvironment) var appEnvironment: ZECCWalletEnvironment
    @Environment(\.presentationMode) var presentationMode
    @Binding var isActive: Bool
    @State var selectedModel: DetailModel? = nil
    var zAddress: String {
        viewModel.zAddress
    }
    
    var status: BalanceStatus {
        viewModel.balanceStatus
    }
    
    func converDateToString(headerDate:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: headerDate)
    }
    
    var body: some View {
        
        ZStack {
            ARRRBackground()
            VStack(alignment: .center, spacing: 20) {
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Wallet History").font(.barlowRegular(size: 25)).multilineTextAlignment(.center).foregroundColor(.gray)
                }
                
                ZcashNavigationBar(
                    leadingItem: {

                    },
                   headerItem: {
//                    if appEnvironment.synchronizer.synchronizer.getShieldedBalance() > 0 {
                        BalanceDetailView(
                                availableZec: appEnvironment.synchronizer.verifiedBalance.value,
                                status: status)
                                
//                    }
//                    else {
//                        ActionableMessage(message: "balance_nofunds".localized())
//                    }
                   },
                   trailingItem: { EmptyView() }
                )
                .padding(.horizontal, 10)
                

                List {
                    
                    ForEach(self.viewModel.headers, id: \.self) { header in
                     
                       Section(header: Text(converDateToString(headerDate: header))) {
                            ForEach(self.viewModel.groupedByDate[header]!) { row in
                                Button(action: {
                                    self.selectedModel = row
                                }) {
                                    DetailCard(model: row, backgroundColor: .zDarkGray2)
                                }
                                .listRowBackground(Color.zDarkGray2)
                                .frame(height: 69)
                                .padding(.horizontal, 16)
                                .cornerRadius(0)
                                .border(Color.zGray, width: 1)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                  
                           }
                       }
                    }
                    
                }
                .listStyle(PlainListStyle())
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.zGray, lineWidth: 1.0)
                )
                .padding()
                
            }
        }
        .onAppear() {
            
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().backgroundColor = UIColor.clear
            tracker.track(.screen(screen: .history), properties: [:])

        }
        .alert(isPresented: self.$viewModel.showError) {
            Alert(title: Text("Error"),
                  message: Text("an error ocurred"),
                  dismissButton: .default(Text("button_close")))
        }
        .onDisappear() {
            UITableView.appearance().separatorStyle = .singleLine
        }
        .navigationBarHidden(true)
        .sheet(item: self.$selectedModel, onDismiss: {
            self.selectedModel = nil
        }) { (row)  in
            TxDetailsWrapper(row: row)
        }

    }
}

struct WalletDetails_Previews: PreviewProvider {
    static var previews: some View {
        return WalletDetails(isActive: .constant(true)).environmentObject(ZECCWalletEnvironment.shared)
    }
}

class MockWalletDetailViewModel: WalletDetailsViewModel {
    
    override init() {
        super.init()
        
    }
    
}

extension DetailModel {
    static var mockDetails: [DetailModel] {
        var items =  [DetailModel]()
       
            items.append(contentsOf:
                [
                    
                    DetailModel(
                        id: "bb031",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Date(),
                        arrrAmount: -2.345,
                        status: .paid(success: true),
                        subtitle: "Sent 11/18/19 4:12pm"
                        
                    ),
                    
                    
                    DetailModel(
                        id: "bb032",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                        arrrAmount: 0.011,
                        status: .received,
                        subtitle: "Received 11/18/19 4:12pm"
                        
                    ),
                    

                    DetailModel(
                        id: "bb033",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                        arrrAmount: 0.002,
                        status: .paid(success: false),
                        subtitle: "Sent 11/18/19 4:12pm"
                    ),

                    DetailModel(
                        id: "bb034",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Date(),
                        arrrAmount: -1.345,
                        status: .paid(success: true),
                        subtitle: "Sent 11/15/19 3:12pm"
                        
                    ),
                    
                    
                    DetailModel(
                        id: "bb035",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                        arrrAmount: 0.022,
                        status: .received,
                        subtitle: "Received 11/18/20 4:12pm"
                        
                    ),
                    

                    DetailModel(
                        id: "bb036",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                        arrrAmount: 0.012,
                        status: .paid(success: false),
                        subtitle: "Sent 12/18/19 4:12pm"
                    ),
                    
                    
                    DetailModel(
                        id: "bb036",
                        arrrAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                        date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                        arrrAmount: 0.012,
                        status: .paid(success: false),
                        subtitle: "Sent 12/18/19 4:12pm"
                    )
                ]
            )
        
        return items
    }
}

