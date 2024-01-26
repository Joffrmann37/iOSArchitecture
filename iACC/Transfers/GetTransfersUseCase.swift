//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetTransfersUseCase {
    var result: (Result<[Transfer], Error>)?
    var completion: ((Result<[Transfer], Error>) -> Void)?
    
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void) {
        if let repo = repo as? TransfersRepo {
            repo.loadTransfers(result: result, completion: completion)
        }
    }
}

extension GetTransfersUseCase: UseCaseDelegate {
    var repo: Repo? {
        get {
            return CardRepo()
        }
        set {}
    }
    
    func load(repoType: RepoType) {
        if repoType == .cards, let repo = repo as? TransfersRepo, let result = result, let completion = completion {
            repo.loadTransfers(result: result, completion: completion)
        }
    }
}
