//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetCardsUseCase {
    static var shared = GetCardsUseCase()
    var repo: CardRepo
    var select: (Card) -> Void
    
    init() {
        self.repo = CardRepo()
        self.select = { _ in }
    }
    
    init(select: @escaping (Card) -> Void) {
        self.repo = CardRepo()
        self.select = select
    }
    
    init(repo: CardRepo, select: @escaping (Card) -> Void) {
        self.repo = repo
        self.select = select
    }
    
    func loadCards(cards: [Card] = [
        Card(id: 1, number: "****-0899", holder: "J. DOE"),
        Card(id: 2, number: "****-6544", holder: "DOE J.")
        ],
        completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        repo.loadCards { res in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
                DispatchQueue.main.async {
                    completion(res.map { items in
                        return items.map { item in
                            ViewModel(card: item) {
                                self.select(item)
                            }
                        }
                    })
                }
            }
        }
    }
}
