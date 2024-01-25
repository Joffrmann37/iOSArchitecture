//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetCardsUseCase {
    private let cardAPI: CardAPI
    
    init(cardAPI: CardAPI) {
        self.cardAPI = cardAPI
    }
    
    func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void) {
        cardAPI.loadCards(result: result, completion: completion)
    }
}
