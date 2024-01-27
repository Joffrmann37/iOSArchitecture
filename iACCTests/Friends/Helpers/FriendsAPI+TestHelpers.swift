//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `FriendsViewModel` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension FriendsViewModel {
    static var never: FriendsViewModel {
        results([])
    }
    
    static func once(_ friends: [ViewModel]) -> FriendsViewModel {
        results([.success(friends)])
    }
    
    static func results(_ results: [Result<[ViewModel], Error>]) -> FriendsViewModel {
        var results = results
        return resultBuilder { results.removeFirst() }
    }
    
    static func resultBuilder(_ resultBuilder: @escaping () -> Result<[ViewModel], Error>) -> FriendsViewModel {
        FriendsViewModelStub(resultBuilder: resultBuilder)
    }
    
    func getMappedViewModels(friends: [Friend]) -> [ViewModel] {
        return friends.map { item in
            ViewModel(friend: item) {
                
            }
        }
    }
    
    func getMappedResults(_ results: [Result<[Friend], Error>]) -> [Result<[ViewModel], Error>] {
        return results.map { result in
            switch result {
            case let .success(items):
                let vms = items.map { item in
                    ViewModel(friend: item) {
                        
                    }
                }
                return .success(vms)
            case let .failure(error):
                return .failure(error)
            }
        }
    }
	
	private class FriendsViewModelStub: FriendsViewModel {
		private let nextResult: () -> Result<[ViewModel], Error>
		
		init(resultBuilder: @escaping () -> Result<[ViewModel], Error>) {
			nextResult = resultBuilder
            super.init()
		}
        
        override func loadFriends(friends: [Friend], completion: @escaping (Result<[ViewModel], Error>) -> Void) {
            completion(nextResult())
        }
	}
}
