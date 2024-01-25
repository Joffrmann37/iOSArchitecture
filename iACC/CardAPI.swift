//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol CardRepo: AnyObject {
    func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void)
}

struct Card: Equatable {
	let id: Int
	let number: String
	let holder: String
}

class CardsViewModel {
    static var shared = CardsViewModel()
    var getCardsUseCase: GetCardsUseCase
    var cardsAPI: CardAPI = CardAPI()
    
    init() {
        self.getCardsUseCase = GetCardsUseCase(cardAPI: CardAPI())
    }
    
    init(getCardsUseCase: GetCardsUseCase) {
        self.getCardsUseCase = getCardsUseCase
    }
    
    func loadCards(cards: [Card] = [
        Card(id: 1, number: "****-0899", holder: "J. DOE"),
        Card(id: 2, number: "****-6544", holder: "DOE J.")
        ],
        completion: @escaping (Result<[Card], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            self.getCardsUseCase.loadCards(result: .success(cards), completion: completion)
        }
    }
}

class GetCardsUseCase {
    private let cardAPI: CardAPI
    
    init(cardAPI: CardAPI) {
        self.cardAPI = cardAPI
    }
    
    func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void) {
        cardAPI.loadCards(result: result, completion: completion)
    }
}

class CardAPI: CardRepo {
	static var shared = CardAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
			completion(.success([
				Card(id: 1, number: "****-0899", holder: "J. DOE"),
				Card(id: 2, number: "****-6544", holder: "DOE J.")
			]))
		}
	}
}
