//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetFriendsUseCase {
    let friendsAPI: FriendsAPI
    
    init(friendsAPI: FriendsAPI) {
        self.friendsAPI = friendsAPI
    }
    
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void) {
        friendsAPI.loadFriends(result: result, completion: completion)
    }
}
