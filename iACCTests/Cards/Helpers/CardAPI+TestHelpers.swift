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
	static func once(_ cards: [ViewModel]) -> CardsViewModel {
		results([.success(cards)])
	}
	
	static func once(_ error: Error) -> CardsViewModel {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[ViewModel], Error>]) -> CardsViewModel {
		var results = results
		return resultBuilder { results.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[ViewModel], Error>) -> CardsViewModel {
        CardViewModelStub(resultBuilder: resultBuilder)
	}
    
    func getMappedViewModels(cards: [Card]) -> [ViewModel] {
        return cards.map { item in
            ViewModel(card: item) {
                
            }
        }
    }
    
    func getMappedResults(_ results: [Result<[Card], Error>]) -> [Result<[ViewModel], Error>] {
        return results.map { result in
            switch result {
            case let .success(items):
                let vms = items.map { item in
                    ViewModel(card: item) {
                        
                    }
                }
                return .success(vms)
            case let .failure(error):
                return .failure(error)
            }
        }
    }
	
	private class CardViewModelStub: CardsViewModel {
		private let nextResult: () -> Result<[ViewModel], Error>
		
		init(resultBuilder: @escaping () -> Result<[ViewModel], Error>) {
			nextResult = resultBuilder
            super.init()
		}
        
        override func loadCards(cards: [Card], completion: @escaping (Result<[ViewModel], Error>) -> Void) {
            completion(nextResult())
        }
	}
}
