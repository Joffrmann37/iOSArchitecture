//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation


class CardRepo {
	static var shared = CardRepo()
    var result: (Result<[Card], Error>)?
    var completion: ((Result<[Card], Error>) -> Void)?
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
			completion(.success([
				Card(id: 1, number: "****-0899", holder: "J. DOE"),
				Card(id: 2, number: "****-6544", holder: "DOE J.")
			]))
		}
	}
}

extension CardRepo: Repo {
    func load(repoType: RepoType) {
        if repoType == .cards {
            if let result = result, let completion = completion {
                loadCards(result: result, completion: completion)
            }
        }
    }
}
