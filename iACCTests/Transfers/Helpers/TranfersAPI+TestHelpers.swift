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
	static func once(_ Transfers: [Transfer]) -> TransfersViewModel {
		results([.success(Transfers)])
	}
	
	static func once(_ error: Error) -> TransfersViewModel {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[Transfer], Error>]) -> TransfersViewModel {
		var mutableResults = results
		return resultBuilder { mutableResults.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Transfer], Error>) -> TransfersViewModel {
		TransfersViewModelStub(resultBuilder: resultBuilder)
	}
	
	private class TransfersViewModelStub: TransfersViewModel {
		private let nextResult: () -> Result<[Transfer], Error>
		
		init(resultBuilder: @escaping () -> Result<[Transfer], Error>) {
			nextResult = resultBuilder
            super.init()
		}
		
		override func loadTransfers(transfers: [Transfer], completion: @escaping (Result<[Transfer], Error>) -> Void) {
			completion(nextResult())
		}
	}
}
