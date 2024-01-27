//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
import UIKit

class FriendsViewModel: ViewModelDelegate {
    static var shared = FriendsViewModel()
    let repo: FriendsRepo
    let cache: FriendsCache
    let isPremium: Bool
    var select: (Friend) -> Void
    var useCase: UseCaseDelegate? {
        get {
            return GetFriendsUseCase(friendsRepo: repo, cache: cache, isPremium: isPremium, select: select)
        }
        set {}
    }
    
    init() {
        self.repo = FriendsRepo()
        self.cache = FriendsCache()
        self.isPremium = false
        self.select = { _ in }
    }
    
    init(select: @escaping (Friend) -> Void) {
        self.repo = FriendsRepo()
        self.cache = (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).cache
        self.isPremium = false
        self.select = select
    }
    
    init(repo: FriendsRepo, cache: FriendsCache, isPremium: Bool, select: @escaping (Friend) -> Void) {
        self.repo = repo
        self.cache = cache
        self.isPremium = isPremium
        self.select = select
    }
    
    func loadFriends(friends: [Friend] = [
        Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
        Friend(id: UUID(), name: "Mary", phone: "1111-1111")
        ],
        completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        useCase?.service?.load(friends, completion)
    }
}
