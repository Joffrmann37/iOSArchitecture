//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
import UIKit

protocol ItemsViewModelAdapter {
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void)
}


struct FriendsViewModelAdapter: ItemsViewModelAdapter {
    let select: (Friend) -> Void
    var viewModel: FriendsViewModel
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        viewModel.loadFriends(completion: completion)
    }
}

struct FriendsViewModelCacheAdapter: ItemsViewModelAdapter {
    let cache: FriendsCache
    let select: (Friend) -> Void
    var viewModel: FriendsViewModel
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        cache.loadFriends(completion: completion)
    }
}

struct ItemsViewModelAdapterWithFallback: ItemsViewModelAdapter {
    let primary: ItemsViewModelAdapter
    let fallback: ItemsViewModelAdapter
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        primary.load(items) { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                fallback.load(items, completion)
            }
        }
    }
}

extension ItemsViewModelAdapter {
    func fallback(_ fallback: ItemsViewModelAdapter) -> ItemsViewModelAdapter {
        return ItemsViewModelAdapterWithFallback(primary: self, fallback: fallback)
    }
    
    func retry(_ retryCount: UInt) -> ItemsViewModelAdapter {
        var adapter: ItemsViewModelAdapter = self
        for _ in 0..<retryCount {
            adapter = adapter.fallback(self)
        }
        
        return adapter
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
