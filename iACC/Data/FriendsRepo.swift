//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class FriendsRepo {
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadFriends(friends: [Friend] = [
        Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
        Friend(id: UUID(), name: "Mary", phone: "1111-1111")
        ], completion: @escaping (Result<[Friend], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            DispatchQueue.main.async {
                completion(.success(friends))
            }
        }
	}
}
