//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol TransfersRepo: AnyObject {
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void)
}

class TransfersAPI: TransfersRepo {
	static var shared = TransfersAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void) {
        completion(result)
    }
}
