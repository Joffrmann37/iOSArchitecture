//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class TransfersRepo {
	static var shared = TransfersRepo()
    var result: (Result<[Transfer], Error>)?
    var completion: ((Result<[Transfer], Error>) -> Void)?
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
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
        completion: @escaping (Result<[Transfer], Error>) -> Void) {
            completion(.success(transfers))
        } 
}
