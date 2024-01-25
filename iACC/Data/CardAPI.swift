//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol CardRepo: AnyObject {
    func loadCards(result: (Result<[Card], Error>), completion: @escaping (Result<[Card], Error>) -> Void)
}

class CardAPI: CardRepo {
	static var shared = CardAPI()
	
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
