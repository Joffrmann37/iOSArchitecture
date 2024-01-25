//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol FriendsRepo: AnyObject {
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void)
}

struct Friend: Equatable {
	let id: UUID
	let name: String
	let phone: String
}

class FriendsViewModel {
    static var shared = FriendsViewModel()
    var getFriendsUseCase: GetFriendsUseCase
    
    init() {
        self.getFriendsUseCase = GetFriendsUseCase(friendsAPI: FriendsAPI())
    }
    
    init(getFriendsUseCase: GetFriendsUseCase) {
        self.getFriendsUseCase = getFriendsUseCase
    }
    
    func loadFriends(friends: [Friend] = [
        Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
        Friend(id: UUID(), name: "Mary", phone: "1111-1111")
        ],
        completion: @escaping (Result<[Friend], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            self.getFriendsUseCase.loadFriends(result: .success(friends), completion: completion)
        }
    }
}

class GetFriendsUseCase {
    let friendsAPI: FriendsAPI
    
    init(friendsAPI: FriendsAPI) {
        self.friendsAPI = friendsAPI
    }
    
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void) {
        friendsAPI.loadFriends(result: result, completion: completion)
    }
}

class FriendsAPI: FriendsRepo {
    static var shared = FriendsAPI()
    
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadFriends(result: (Result<[Friend], Error>), completion: @escaping (Result<[Friend], Error>) -> Void) {
        completion(result)
	}
}
