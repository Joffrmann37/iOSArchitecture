//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct TransfersViewModelAdapter: ItemsViewModelAdapter {
    let longDateStyle: Bool
    let select: (Transfer) -> Void
    var viewModel: TransfersViewModel
    
    init(longDateStyle: Bool, select: @escaping (Transfer) -> Void, viewModel: TransfersViewModel) {
        self.longDateStyle = longDateStyle
        self.select = select
        self.viewModel = viewModel
    }
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        viewModel.loadTransfers(completion: completion)
    }
}

class TransfersViewModel: ViewModelDelegate {
    static var shared = TransfersViewModel()
    let repo: TransfersRepo
    var select: (Transfer) -> Void
    let longDateStyle: Bool
    var useCase: UseCaseDelegate? {
        get {
            return GetTransfersUseCase(transfersRepo: repo, select: select, longDateStyle: longDateStyle)
        }
        set {}
    }
    
    init() {
        self.repo = TransfersRepo()
        self.select = { _ in }
        self.longDateStyle = false
    }
    
    init(select: @escaping (Transfer) -> Void) {
        self.repo = TransfersRepo()
        self.select = select
        self.longDateStyle = false
    }
    
    init(repo: TransfersRepo, select: @escaping (Transfer) -> Void, longDateStyle: Bool) {
        self.repo = repo
        self.select = select
        self.longDateStyle = longDateStyle
    }
    
    func loadTransfers(transfers: [Transfer] = [
        Transfer(
            id: 1,
            description: "Restaurant bill",
            amount: Decimal(42.78),
            currencyCode: "USD",
            sender: "J. Doe",
            recipient: "Bob",
            isSender: true,
            date: Date(timeIntervalSince1970: 1690276063)
        ),
        Transfer(
            id: 2,
            description: "Rent",
            amount: Decimal(728),
            currencyCode: "USD",
            sender: "J. Doe",
            recipient: "Mary",
            isSender: true,
            date: Date(timeIntervalSince1970: 1690347770)
        ),
        Transfer(
            id: 3,
            description: "Gas",
            amount: Decimal(37.75),
            currencyCode: "USD",
            sender: "Bob",
            recipient: "J. Doe",
            isSender: false,
            date: Date(timeIntervalSince1970: 1690373492)
        )
        ],
        completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        useCase?.service?.load(transfers, completion)
    }
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        useCase?.service?.load(items, completion)
    }
}
