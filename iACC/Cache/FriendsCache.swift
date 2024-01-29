//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class FriendsCache {	
	private var friendVMs: [ItemViewModel]?
    private var result: (Result<[ItemViewModel], Error>)!
	
	private struct NoFriendsFound: Error {}
	
	/// For demo purposes, this method simulates an database lookup with a pre-defined in-memory response and delay.
	func loadFriends(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
			if let friends = self.friendVMs {
                self.result = .success(friends)
			} else {
                self.result = .failure(NoFriendsFound())
			}
            completion(self.result)
		}
	}
	
	/// For demo purposes, this method simulates a cache with an in-memory reference to the provided friends.
	func save(_ newFriends: [ItemViewModel]) {
		friendVMs = newFriends
	}
    
    func getFriends() -> [ItemViewModel]? {
        return friendVMs
    }
}
