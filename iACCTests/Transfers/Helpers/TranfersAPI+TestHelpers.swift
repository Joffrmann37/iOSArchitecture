//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `GetTransfersUseCase` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension GetTransfersUseCase {
	static func once(_ transfers: [ItemViewModel]) -> GetTransfersUseCase {
		results([.success(transfers)])
	}
	
	static func once(_ error: Error) -> GetTransfersUseCase {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[ItemViewModel], Error>]) -> GetTransfersUseCase {
		var mutableResults = results
		return resultBuilder { mutableResults.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[ItemViewModel], Error>) -> GetTransfersUseCase {
		GetTransfersUseCaseStub(resultBuilder: resultBuilder)
	}
    
    func getMappedItemViewModels(longDateStyle: Bool, transfers: [Transfer]) -> [ItemViewModel] {
        return transfers.map { item in
            ItemViewModel(transfer: item, longDateStyle: longDateStyle) {
                
            }
        }
    }
    
    func getMappedResults(longDateStyle: Bool, _ results: [Result<[Transfer], Error>]) -> [Result<[ItemViewModel], Error>] {
        return results.map { result in
            switch result {
            case let .success(items):
                let vms = items.map { item in
                    ItemViewModel(transfer: item, longDateStyle: longDateStyle) {
                        
                    }
                }
                return .success(vms)
            case let .failure(error):
                return .failure(error)
            }
        }
    }
	
	private class GetTransfersUseCaseStub: GetTransfersUseCase {
		private let nextResult: () -> Result<[ItemViewModel], Error>
		
		init(resultBuilder: @escaping () -> Result<[ItemViewModel], Error>) {
			nextResult = resultBuilder
            super.init()
		}
		
        override func loadTransfers(transfers: [Transfer], completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
            completion(nextResult())
        }
	}
}
