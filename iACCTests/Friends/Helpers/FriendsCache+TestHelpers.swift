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
	
	static func once(_ friends: [ViewModel]) -> FriendsCache {
        results([.success(friends)], { _ in }, friends)
	}
	
	static func once(_ error: Error) -> FriendsCache {
		results([.failure(error)])
	}
	
    static func saveCallback(uuids: [UUID] = [], _ viewModels: [ViewModel] = [],
		_ saveCallback: @escaping ([ViewModel]) -> Void
	) -> FriendsCache {
        var finalFriends = [Friend]()
        let friends = getMappedFriends(uuids: uuids, viewModels: viewModels)
        if uuids.count > 0 {
            for i in 0..<friends.count {
                let newFriend = Friend(id: uuids[i], name: friends[i].name, phone: friends[i].phone)
                finalFriends.append(newFriend)
            }
            saveCallback(getMappedViewModels(friends: finalFriends))
        }
        return results([], saveCallback)
	}
    
    static func getMappedFriends(uuids: [UUID] = [], viewModels: [ViewModel]) -> [Friend] {
        return viewModels.map { item in
            Friend(id: UUID(), name: item.title, phone: item.subtitle)
        }
    }
    
    static func getMappedViewModels(friends: [Friend]) -> [ViewModel] {
        return friends.map { friend in
            ViewModel(friend: friend) {
                
            }
        }
    }

	static func results(
		_ results: [Result<[ViewModel], Error>],
		_ saveCallback: @escaping ([ViewModel]) -> Void = { _ in },
        _ vms: [ViewModel] = []
	) -> FriendsCache {
		var results = results
		return resultBuilder({ results.removeFirst() }, saveCallback, vms)
	}
		
	static func resultBuilder(
		_ resultBuilder: @escaping () -> Result<[ViewModel], Error>,
		_ saveCallback: @escaping ([ViewModel]) -> Void = { _ in },
        _ vms: [ViewModel] = []
	) -> FriendsCache {
		FriendsCacheSpy(resultBuilder: resultBuilder, saveCallback: saveCallback, vms: vms)
	}
		
	private class FriendsCacheSpy: FriendsCache {
		private let nextResult: () -> Result<[ViewModel], Error>
		private let saveCallback: ([ViewModel]) -> Void
        private var friendVMs: [ViewModel]?
		
		init(
			resultBuilder: @escaping () -> Result<[ViewModel], Error>,
			saveCallback save: @escaping ([ViewModel]) -> Void,
            vms: [ViewModel] = []
		) {
			nextResult = resultBuilder
			saveCallback = save
            friendVMs = vms
		}
		
		override func loadFriends(completion: @escaping (Result<[ViewModel], Error>) -> Void) {
            completion(nextResult())
		}
		
        override func save(_ newFriends: [ViewModel]) {
            saveCallback(newFriends)
        }
        
        override func getFriends() -> [ViewModel]? {
            return friendVMs
        }
	}
}
