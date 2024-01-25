//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

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
