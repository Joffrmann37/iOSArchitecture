//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct GetCardsUseCase: UseCaseDelegate {
    var cardRepo: CardRepo
    let select: (Card) -> Void

    var service: ItemsService? {
        get {
            return CardRepoAdapter(repo: cardRepo, select: select)
        }
        set {}
    }
}
