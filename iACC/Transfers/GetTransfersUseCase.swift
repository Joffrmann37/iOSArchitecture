//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetTransfersUseCase {
    static var shared = GetTransfersUseCase()
    var repo: TransfersRepo
    var select: (Transfer) -> Void
    let longDateStyle: Bool
    
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
        completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        repo.loadTransfers { res in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
                DispatchQueue.main.async {
                    completion(res.map { items in
                        return items.map { item in
                            ItemViewModel(transfer: item, longDateStyle: self.longDateStyle) {
                                self.select(item)
                            }
                        }
                    })
                }
            }
        }
    }
}
