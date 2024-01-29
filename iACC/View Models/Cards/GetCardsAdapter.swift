//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct GetCardsUseCaseAdapter: ItemsUseCaseAdapter {
    let select: (Card) -> Void
    var useCase: GetCardsUseCase
    
    init(select: @escaping (Card) -> Void, useCase: GetCardsUseCase) {
        self.select = select
        self.useCase = useCase
    }
    
    func load(_ completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        useCase.loadCards(completion: completion)
    }
}
