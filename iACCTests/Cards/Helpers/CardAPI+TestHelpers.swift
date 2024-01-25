//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `CardAPI` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension CardsViewModel {
	static func once(_ cards: [Card]) -> CardsViewModel {
		results([.success(cards)])
	}
	
	static func once(_ error: Error) -> CardsViewModel {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[Card], Error>]) -> CardsViewModel {
		var results = results
		return resultBuilder { results.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Card], Error>) -> CardsViewModel {
        CardViewModelStub(resultBuilder: resultBuilder)
	}
	
	private class CardViewModelStub: CardsViewModel {
		private let nextResult: () -> Result<[Card], Error>
		
		init(resultBuilder: @escaping () -> Result<[Card], Error>) {
			nextResult = resultBuilder
            super.init()
		}
		
        override func loadCards(cards: [Card], completion: @escaping (Result<[Card], Error>) -> Void) {
			completion(nextResult())
		}
	}
}
