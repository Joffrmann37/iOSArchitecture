//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class CardsViewModel {
    static var shared = CardsViewModel()
    
    func loadCards(cards: [Card] = [
        Card(id: 1, number: "****-0899", holder: "J. DOE"),
        Card(id: 2, number: "****-6544", holder: "DOE J.")
        ],
        completion: @escaping (Result<[Card], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            if let useCase = self.useCase {
                useCase.load(repoType: .cards)
            }
        }
    }
}

extension CardsViewModel: ViewModelDelegate {
    var useCase: UseCaseDelegate? {
        get {
            return GetCardsUseCase()
        }
        set {}
    }
}
