//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetFriendsUseCase {
    static var shared = GetFriendsUseCase()
    let cache: FriendsCache
    var select: (Friend) -> Void
    let shouldLoadFromCache: Bool
    let repo: FriendsRepo
    
    init() {
        self.shouldLoadFromCache = false
        self.repo = FriendsRepo()
        self.cache = FriendsCache()
        self.select = { _ in }
    }
    
    init(select: @escaping (Friend) -> Void) {
        self.shouldLoadFromCache = false
        self.repo = FriendsRepo()
        self.cache = FriendsCache()
        self.select = select
    }
    
    init(shouldLoadFromCache: Bool, repo: FriendsRepo, cache: FriendsCache, isPremium: Bool, select: @escaping (Friend) -> Void) {
        self.shouldLoadFromCache = shouldLoadFromCache
        self.repo = repo
        self.cache = cache
        self.select = select
    }
    
    func loadFriends(friends: [Friend] = [
        Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
        Friend(id: UUID(), name: "Mary", phone: "1111-1111")
        ],
        completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        repo.loadFriends { res in
            completion(res.map { items in
                let itemsToSave = items.map { item in
                    ItemViewModel(friend: item) {
                        self.select(item)
                    }
                }
                self.cache.save(itemsToSave)
                return itemsToSave
            })
        }
    }
}
