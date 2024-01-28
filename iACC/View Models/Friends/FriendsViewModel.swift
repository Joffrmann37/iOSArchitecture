//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
import UIKit

protocol ItemsViewModelAdapter {
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void)
}


struct FriendsViewModelAdapter: ItemsViewModelAdapter {
    let cache: FriendsCache
    let select: (Friend) -> Void
    var viewModel: FriendsViewModel
    let shouldLoadFromCache: Bool
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        if shouldLoadFromCache {
            cache.loadFriends(completion: completion)
        } else {
            viewModel.loadFriends(completion: completion)
        }
    }
}

class FriendsViewModel: ViewModelDelegate {
    static var shared = FriendsViewModel()
    let shouldLoadFromCache: Bool
    let repo: FriendsRepo
    var cache: FriendsCache
    var select: (Friend) -> Void
    var useCase: UseCaseDelegate? {
        get {
            return GetFriendsUseCase(friendsRepo: repo, cache: cache, select: select)
        }
        set {}
    }
    
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
        completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        useCase?.service?.load(friends, completion)
    }
}
