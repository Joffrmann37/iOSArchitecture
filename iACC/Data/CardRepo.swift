//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct CardRepoAdapter: ItemsService {
    let repo: CardRepo
    let select: (Card) -> Void
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        repo.loadCards { res in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
                DispatchQueue.main.async {
                    completion(res.map { items in
                        return items.map { item in
                            ViewModel(card: item) {
                                select(item)
                            }
                        }
                    })
                }
            }
        }
    }
}

class CardRepo {
	static var shared = CardRepo()
    var result: (Result<[Card], Error>)?
    var completion: ((Result<[Card], Error>) -> Void)?
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadCards(cards: [Card] = [
        Card(id: 1, number: "****-0899", holder: "J. DOE"),
        Card(id: 2, number: "****-6544", holder: "DOE J.")
    ], completion: @escaping (Result<[Card], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            completion(.success(cards))
        }
	}
}
