//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetCardsUseCase {
    static var getCardsUseCase = GetCardsUseCase()
    var result: (Result<[Card], Error>)?
    var completion: ((Result<[Card], Error>) -> Void)?
    
    func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void) {
        if let repo = repo as? CardRepo {
            repo.loadCards(result: result, completion: completion)
        }
    }
}

extension GetCardsUseCase: UseCaseDelegate {
    var repo: Repo? {
        get {
            return CardRepo()
        }
        set {}
    }
    
    func load(repoType: RepoType) {
        if repoType == .cards, let repo = repo as? CardRepo, let result = result, let completion = completion {
            repo.loadCards(result: result, completion: completion)
        }
    }
}
