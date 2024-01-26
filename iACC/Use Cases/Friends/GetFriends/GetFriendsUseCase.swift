//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetFriendsUseCase: UseCaseDelegate {
    var repo: Repo? {
        get {
            return FriendsRepo()
        }
        set {}
    }
    
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void) {
        repo?.load(result, completion)
    }
}
