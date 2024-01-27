//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct Article: Equatable {
	let id: UUID
	let title: String
	let author: String
}

class ArticlesRepo {
	static var shared = ArticlesRepo()
    var result: (Result<[Article], Error>)?
    var completion: ((Result<[Article], Error>) -> Void)?
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadArticles(result: (Result<[Article], Error>), completion: @escaping (Result<[Article], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
			completion(.success([
				Article(id: UUID(), title: "iOS Architecture 101", author: "Mike A."),
				Article(id: UUID(), title: "Refactoring 101", author: "Caio Z.")
			]))
		}
	}
}
