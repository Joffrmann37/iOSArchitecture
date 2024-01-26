//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetArticlesUseCase: UseCaseDelegate {
    var repo: Repo? {
        get {
            return ArticlesRepo()
        }
        set {}
    }
    
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void) {
        repo?.load(result, completion)
    }
}
