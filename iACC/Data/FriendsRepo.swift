//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

enum RepoType: String {
    case friends
    case cards
    case transfers
    case articles
}

protocol Repo: AnyObject {
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void)
}

class FriendsRepo {
    static var shared = FriendsRepo()
    var result: (Result<[Friend], Error>)?
    var completion: ((Result<[Friend], Error>) -> Void)?
    
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void) {
        completion(result)
	}
}

extension FriendsRepo: Repo {
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void) {
        completion(result)
    }
}
