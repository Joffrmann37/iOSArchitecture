//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `CardAPI` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension GetCardsUseCase {
	static func once(_ cards: [ItemViewModel]) -> GetCardsUseCase {
		results([.success(cards)])
	}
	
	static func once(_ error: Error) -> GetCardsUseCase {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[ItemViewModel], Error>]) -> GetCardsUseCase {
		var results = results
		return resultBuilder { results.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[ItemViewModel], Error>) -> GetCardsUseCase {
        GetCardsUseCaseModelStub(resultBuilder: resultBuilder)
	}
    
    func getMappedItemViewModels(cards: [Card]) -> [ItemViewModel] {
        return cards.map { item in
            ItemViewModel(card: item) {
                
            }
        }
    }
    
    func getMappedResults(_ results: [Result<[Card], Error>]) -> [Result<[ItemViewModel], Error>] {
        return results.map { result in
            switch result {
            case let .success(items):
                let vms = items.map { item in
                    ItemViewModel(card: item) {
                        
                    }
                }
                return .success(vms)
            case let .failure(error):
                return .failure(error)
            }
        }
    }
	
	private class GetCardsUseCaseModelStub: GetCardsUseCase {
		private let nextResult: () -> Result<[ItemViewModel], Error>
		
		init(resultBuilder: @escaping () -> Result<[ItemViewModel], Error>) {
			nextResult = resultBuilder
            super.init()
		}
        
        override func loadCards(cards: [Card], completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
            completion(nextResult())
        }
	}
}
