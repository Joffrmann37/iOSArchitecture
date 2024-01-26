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
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void) {
        completion(result)
    }
}
