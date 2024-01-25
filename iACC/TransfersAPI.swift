//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol TransfersRepo: AnyObject {
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void)
}

struct Transfer: Equatable {
	let id: Int
	let description: String
	let amount: Decimal
	let currencyCode: String
	let sender: String
	let recipient: String
	let isSender: Bool
	let date: Date
}

class TransfersViewModel {
    static var shared = TransfersViewModel()
    var getTransfersUseCase: GetTransfersUseCase
    var transfersAPI: TransfersAPI = TransfersAPI()
    
    init() {
        self.getTransfersUseCase = GetTransfersUseCase(transfersAPI: TransfersAPI())
    }
    
    init(getTransfersUseCase: GetTransfersUseCase) {
        self.getTransfersUseCase = getTransfersUseCase
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
        completion: @escaping (Result<[Transfer], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            self.getTransfersUseCase.loadTransfers(result: .success(transfers), completion: completion)
        }
    }
}

class GetTransfersUseCase {
    private let transfersAPI: TransfersAPI
    
    init(transfersAPI: TransfersAPI) {
        self.transfersAPI = transfersAPI
    }
    
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void) {
        transfersAPI.loadTransfers(result: result, completion: completion)
    }
}

class TransfersAPI: TransfersRepo {
	static var shared = TransfersAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void) {
        completion(result)
    }
}
