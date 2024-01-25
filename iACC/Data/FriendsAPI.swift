//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol FriendsRepo: AnyObject {
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void)
}

class FriendsAPI: FriendsRepo {
    static var shared = FriendsAPI()
    
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void) {
        completion(result)
	}
}
