//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `TransfersViewModel` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension TransfersViewModel {
	static func once(_ transfers: [ViewModel]) -> TransfersViewModel {
		results([.success(transfers)])
	}
	
	static func once(_ error: Error) -> TransfersViewModel {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[ViewModel], Error>]) -> TransfersViewModel {
		var mutableResults = results
		return resultBuilder { mutableResults.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[ViewModel], Error>) -> TransfersViewModel {
		TransfersViewModelStub(resultBuilder: resultBuilder)
	}
    
    func getMappedViewModels(longDateStyle: Bool, transfers: [Transfer]) -> [ViewModel] {
        return transfers.map { item in
            ViewModel(transfer: item, longDateStyle: longDateStyle) {
                
            }
        }
    }
    
    func getMappedResults(longDateStyle: Bool, _ results: [Result<[Transfer], Error>]) -> [Result<[ViewModel], Error>] {
        return results.map { result in
            switch result {
            case let .success(items):
                let vms = items.map { item in
                    ViewModel(transfer: item, longDateStyle: longDateStyle) {
                        
                    }
                }
                return .success(vms)
            case let .failure(error):
                return .failure(error)
            }
        }
    }
	
	private class TransfersViewModelStub: TransfersViewModel {
		private let nextResult: () -> Result<[ViewModel], Error>
		
		init(resultBuilder: @escaping () -> Result<[ViewModel], Error>) {
			nextResult = resultBuilder
            super.init()
		}
		
        override func loadTransfers(transfers: [Transfer], completion: @escaping (Result<[ViewModel], Error>) -> Void) {
            completion(nextResult())
        }
	}
}
