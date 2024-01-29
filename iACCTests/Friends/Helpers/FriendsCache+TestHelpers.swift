//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `FriendsCache` test helper extension provides fast and reliable ways of stubbing
/// database requests with canned responses to prevent making real database requests during tests.
/// It also allows observing save commands via the `saveCallback` method.
///
extension FriendsCache {
	static var never: FriendsCache {
		results([])
	}
	
	static func once(_ friends: [ItemViewModel]) -> FriendsCache {
        results([.success(friends)], { _ in }, friends)
	}
	
	static func once(_ error: Error) -> FriendsCache {
		results([.failure(error)])
	}
	
    static func saveCallback(uuids: [UUID] = [], _ ItemViewModels: [ItemViewModel] = [],
		_ saveCallback: @escaping ([ItemViewModel]) -> Void
	) -> FriendsCache {
        var finalFriends = [Friend]()
        let friends = getMappedFriends(uuids: uuids, ItemViewModels: ItemViewModels)
        if uuids.count > 0 {
            for i in 0..<friends.count {
                let newFriend = Friend(id: uuids[i], name: friends[i].name, phone: friends[i].phone)
                finalFriends.append(newFriend)
            }
            saveCallback(getMappedItemViewModels(friends: finalFriends))
        }
        return results([], saveCallback)
	}
    
    static func getMappedFriends(uuids: [UUID] = [], ItemViewModels: [ItemViewModel]) -> [Friend] {
        return ItemViewModels.map { item in
            Friend(id: UUID(), name: item.title, phone: item.subtitle)
        }
    }
    
    static func getMappedItemViewModels(friends: [Friend]) -> [ItemViewModel] {
        return friends.map { friend in
            ItemViewModel(friend: friend) {
                
            }
        }
    }

	static func results(
		_ results: [Result<[ItemViewModel], Error>],
		_ saveCallback: @escaping ([ItemViewModel]) -> Void = { _ in },
        _ vms: [ItemViewModel] = []
	) -> FriendsCache {
		var results = results
		return resultBuilder({ results.removeFirst() }, saveCallback, vms)
	}
		
	static func resultBuilder(
		_ resultBuilder: @escaping () -> Result<[ItemViewModel], Error>,
		_ saveCallback: @escaping ([ItemViewModel]) -> Void = { _ in },
        _ vms: [ItemViewModel] = []
	) -> FriendsCache {
		FriendsCacheSpy(resultBuilder: resultBuilder, saveCallback: saveCallback, vms: vms)
	}
		
	private class FriendsCacheSpy: FriendsCache {
		private let nextResult: () -> Result<[ItemViewModel], Error>
		private let saveCallback: ([ItemViewModel]) -> Void
        private var friendVMs: [ItemViewModel]?
		
		init(
			resultBuilder: @escaping () -> Result<[ItemViewModel], Error>,
			saveCallback save: @escaping ([ItemViewModel]) -> Void,
            vms: [ItemViewModel] = []
		) {
			nextResult = resultBuilder
			saveCallback = save
            friendVMs = vms
		}
		
		override func loadFriends(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
            completion(nextResult())
		}
		
        override func save(_ newFriends: [ItemViewModel]) {
            saveCallback(newFriends)
        }
        
        override func getFriends() -> [ItemViewModel]? {
            return friendVMs
        }
	}
}
