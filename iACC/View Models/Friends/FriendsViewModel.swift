//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

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
