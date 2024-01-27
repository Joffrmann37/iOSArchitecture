//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ItemsService {
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void)
}

struct FriendsRepoAdapter: ItemsService {
    let repo: FriendsRepo
    let cache: FriendsCache
    let select: (Friend) -> Void
    
    func load<T>(_ items: [T], _ completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        repo.loadFriends { res in
            completion(res.map { items in
                cache.save(items)
                return items.map { item in
                    ViewModel(friend: item) {
                        select(item)
                    }
                }
            })

        }
    }
}

class FriendsRepo {
    static var shared = FriendsRepo()
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadFriends(friends: [Friend] = [
        Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
        Friend(id: UUID(), name: "Mary", phone: "1111-1111")
        ], completion: @escaping (Result<[Friend], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            DispatchQueue.main.async {
                completion(.success(friends))
            }
        }
	}
}
