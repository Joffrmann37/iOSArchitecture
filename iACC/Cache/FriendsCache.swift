//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class FriendsCache {	
	private var friendVMs: [ViewModel]?
    private var result: (Result<[ViewModel], Error>)!
	
	private struct NoFriendsFound: Error {}
	
	/// For demo purposes, this method simulates an database lookup with a pre-defined in-memory response and delay.
	func loadFriends(completion: @escaping (Result<[ViewModel], Error>) -> Void) {
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
	func save(_ newFriends: [ViewModel]) {
		friendVMs = newFriends
	}
    
    func getFriends() -> [ViewModel]? {
        return friendVMs
    }
}
