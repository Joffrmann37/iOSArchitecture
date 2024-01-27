//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct GetFriendsUseCase: UseCaseDelegate {
    var friendsRepo: FriendsRepo
    let cache: FriendsCache
    let select: (Friend) -> Void
    
    var service: ItemsService? {
        get {
            return FriendsRepoAdapter(repo: friendsRepo, cache: cache, select: select)
        }
        set {}
    }
}
