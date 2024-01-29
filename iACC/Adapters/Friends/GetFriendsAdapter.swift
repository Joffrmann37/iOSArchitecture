//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
import UIKit

protocol ItemsUseCaseAdapter {
    func load(_ completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}


struct GetFriendsUseCaseAdapter: ItemsUseCaseAdapter {
    let select: (Friend) -> Void
    var useCase: GetFriendsUseCase
    
    func load(_ completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        useCase.loadFriends(completion: completion)
    }
}

struct GetFriendsUseCaseCacheAdapter: ItemsUseCaseAdapter {
    let cache: FriendsCache
    let select: (Friend) -> Void
    let useCase: GetFriendsUseCase
    
    func load(_ completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        cache.loadFriends(completion: completion)
    }
}

struct ItemsUseCaseAdapterWithFallback: ItemsUseCaseAdapter {
    let primary: ItemsUseCaseAdapter
    let fallback: ItemsUseCaseAdapter
    
    func load(_ completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        primary.load { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                fallback.load(completion)
            }
        }
    }
}

extension ItemsUseCaseAdapter {
    func fallback(_ fallback: ItemsUseCaseAdapter) -> ItemsUseCaseAdapter {
        return ItemsUseCaseAdapterWithFallback(primary: self, fallback: fallback)
    }
    
    func retry(_ retryCount: UInt) -> ItemsUseCaseAdapter {
        var adapter: ItemsUseCaseAdapter = self
        for _ in 0..<retryCount {
            adapter = adapter.fallback(self)
        }
        
        return adapter
    }
}
