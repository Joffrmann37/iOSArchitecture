//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class TransfersRepo {
	static var shared = TransfersRepo()
    var result: (Result<[Transfer], Error>)?
    var completion: ((Result<[Transfer], Error>) -> Void)?
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void) {
        completion(result)
    }
}

extension TransfersRepo: Repo {
    func load(repoType: RepoType) {
        if repoType == .transfers {
            if let result = result, let completion = completion {
                loadTransfers(result: result, completion: completion)
            }
        }
    }
}
