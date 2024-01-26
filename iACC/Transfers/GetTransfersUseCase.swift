//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetTransfersUseCase: UseCaseDelegate {
    var repo: Repo? {
        get {
            return CardRepo()
        }
        set {}
    }
    
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void) {
        repo?.load(result, completion)
    }
}
