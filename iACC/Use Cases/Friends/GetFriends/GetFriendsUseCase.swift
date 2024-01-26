//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetFriendsUseCase {
    var result: (Result<[Friend], Error>)?
    var completion: ((Result<[Friend], Error>) -> Void)?
    
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void) {
        if let repo = repo as? FriendsRepo {
            repo.loadFriends(result: result, completion: completion)
        }
    }
}

extension GetFriendsUseCase: UseCaseDelegate {
    var repo: Repo? {
        get {
            return FriendsRepo()
        }
        set {}
    }
    
    func load(repoType: RepoType) {
        if repoType == .friends, let repo = repo as? FriendsRepo, let result = result, let completion = completion {
            repo.loadFriends(result: result, completion: completion)
        }
    }
}
