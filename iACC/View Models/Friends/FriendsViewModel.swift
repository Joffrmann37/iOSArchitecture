//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class FriendsViewModel {
    static var shared = FriendsViewModel()
    
    func loadFriends(friends: [Friend] = [
        Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
        Friend(id: UUID(), name: "Mary", phone: "1111-1111")
        ],
        completion: @escaping (Result<[Friend], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            self.useCase?.load(repoType: .friends)
        }
    }
}

extension FriendsViewModel: ViewModelDelegate {
    var useCase: UseCaseDelegate? {
        get {
            return GetFriendsUseCase()
        }
        set {}
    }
}
